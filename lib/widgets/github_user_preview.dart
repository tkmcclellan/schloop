import 'package:flutter/material.dart';
import 'package:schloop/models/user.dart';
import 'package:schloop/services/github/user.dart';

class GitHubUserPreview extends StatelessWidget {
  GitHubUserPreview({required this.user});

  final GitHubUser user;

  void _handleTap(BuildContext context) {
    final User u = User()
      ..avatarUrl = user.avatarUrl
      ..sourceControl = user;

    Navigator.pushNamed(context, '/user/create', arguments: u);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _handleTap(context),
        child: Container(
            child: Row(children: <Widget>[
          Image.network(user.avatarUrl!, width: 100, height: 100),
          Text(user.username!)
        ])));
  }
}
