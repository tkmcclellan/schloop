import 'dart:async' show Timer;
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schloop/services/api_response.dart';
import 'package:schloop/services/github/api_client.dart';
import 'package:schloop/stores/github_store.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubLoginSheet extends StatefulWidget {
  @override
  _GitHubLoginSheetState createState() => _GitHubLoginSheetState();
}

class _GitHubLoginSheetState extends State<GitHubLoginSheet> {
  _GitHubLoginStep _step = _GitHubLoginStep.one;
  String? _deviceCode, _userCode, _verificationUri;
  int? _pollInterval;

  void _handleOpenGitHub() async {
    await launchUrl(Uri.parse(_verificationUri!));
    setState(() => _step = _GitHubLoginStep.three);
  }

  void _pollGitHub(Timer timer) async {
    final ApiResponse response = await GitHub.pollAuthToken(_deviceCode!);

    if (response.body['access_token'] != null &&
        response.body['token_type'] != null &&
        response.body['scope'] != null) {
      await GitHub.init(response.body);
      await context.read<GitHubStore>().init();
      timer.cancel();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    GitHub.getDeviceCode().then((ApiResponse response) {
      setState(() {
        _deviceCode = response.body['device_code'];
        _userCode = response.body['user_code'];
        _verificationUri = response.body['verification_uri'];
        _pollInterval = response.body['interval'];
        _step = _GitHubLoginStep.two;
        Timer.periodic(Duration(seconds: _pollInterval!), _pollGitHub);
        FlutterClipboard.copy(_userCode!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget content;

    switch (_step) {
      case _GitHubLoginStep.one:
        content = Column(children: const <Widget>[
          Text('Loading...'),
          CircularProgressIndicator()
        ]);
        break;
      case _GitHubLoginStep.two:
        content = Column(children: <Widget>[
          const Text(
              'The code below has been copied to your clipboard, please click the button to open GitHub and enter the user code'),
          Text('User Code: $_userCode'),
          ElevatedButton(
              child: const Text('Open GitHub'), onPressed: _handleOpenGitHub)
        ]);
        break;
      case _GitHubLoginStep.three:
        content = const Text('Polling for access token...');
        break;
    }

    return FractionallySizedBox(
        widthFactor: 1.0, heightFactor: 1.0, child: content);
  }
}

enum _GitHubLoginStep { one, two, three }
