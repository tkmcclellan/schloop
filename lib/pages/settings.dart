import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schloop/services/github/api_client.dart';
import 'package:schloop/stores/github_store.dart';
import 'package:schloop/widgets/github_login_sheet.dart';
import 'package:schloop/widgets/github_user_preview.dart';

class SettingsPage extends StatelessWidget {
  void _handleLogout(GitHubStore store) async {
    await GitHub.reset();
    await store.reset();
  }

  @override
  Widget build(BuildContext context) {
    final GitHubStore store = context.watch<GitHubStore>();

    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: store.currentUser == null
            ? ElevatedButton(
                child: const Text('Login with GitHub'),
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => GitHubLoginSheet()))
            : Row(children: <Widget>[
                GitHubUserPreview(user: store.currentUser!),
                ElevatedButton(
                    child: const Text('Logout'),
                    onPressed: () => _handleLogout(store))
              ]));
  }
}
