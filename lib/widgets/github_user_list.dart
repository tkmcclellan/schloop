import 'package:flutter/material.dart';
import 'package:schloop/services/github/user.dart';
import 'package:schloop/widgets/github_user_preview.dart';

class GitHubUserList extends StatelessWidget {
  GitHubUserList({required this.users});

  final List<GitHubUser> users;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
            child: ListView(
                children: users
                    .map((GitHubUser user) => GitHubUserPreview(user: user))
                    .toList())));
  }
}
