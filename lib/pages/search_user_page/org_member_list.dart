import 'package:flutter/material.dart';
import 'package:schloop/services/github/user.dart';
import 'package:schloop/widgets/github_user_list.dart';

class GitHubOrganizationMemberList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrgListArgs arguments =
        ModalRoute.of(context)!.settings.arguments as OrgListArgs;
    final List<GitHubUser> users = arguments.users;

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context))),
        body: Center(
            child: Column(children: <Widget>[
          Image.network(arguments.avatarUrl, height: 150, width: 150),
          GitHubUserList(users: users)
        ])));
  }
}

class OrgListArgs {
  OrgListArgs(this.avatarUrl, this.users);

  final String avatarUrl;
  final List<GitHubUser> users;
}
