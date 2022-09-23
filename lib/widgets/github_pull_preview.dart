import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:schloop/services/github/pull.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubPullPreview extends StatelessWidget {
  GitHubPullPreview({required this.pull});

  final GitHubPull pull;
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all()),
        child: Row(children: <Widget>[
          Expanded(
              child: Text(pull.repo.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(pull.title)),
          Expanded(
              child: IconButton(
                  tooltip: 'Open link in browser.',
                  onPressed: () => launchUrl(Uri.parse(pull.htmlUrl!)),
                  icon: const Icon(Icons.link, color: Colors.black))),
          Expanded(
              child: IconButton(
                  tooltip: 'Copy GitHub CLI command to clipboard.',
                  onPressed: () =>
                      FlutterClipboard.copy('gh pr checkout ${pull.number}'),
                  icon: const Icon(Icons.content_paste, color: Colors.black))),
        ]));
  }
}
