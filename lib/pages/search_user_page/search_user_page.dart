import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schloop/pages/search_user_page/org_member_list.dart';
import 'package:schloop/services/github/organization.dart';
import 'package:schloop/stores/github_store.dart';
import 'package:schloop/widgets/github_user_list.dart';

class SearchUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GitHubStore store = context.watch<GitHubStore>();

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context))),
        body: Column(children: <Widget>[
          (store.organizations == null
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 2),
                  child: ListView(
                      children: store.organizations!
                          .map((GitHubOrganization organization) =>
                              GestureDetector(
                                  onTap: () async => Navigator.pushNamed(
                                      context, '/github/org/members',
                                      arguments: OrgListArgs(
                                          organization.avatarUrl,
                                          await organization.members())),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Row(children: <Widget>[
                                        Image.network(organization.avatarUrl,
                                            width: 100, height: 100),
                                        Text(
                                            '${organization.login}: ${organization.description}')
                                      ]))))
                          .toList()))),
          Column(children: <Widget>[
            TextFormField(validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username.';
              }
              return null;
            }),
            ElevatedButton(onPressed: store.search, child: const Text('Search'))
          ]),
          (store.searchList != null
              ? GitHubUserList(users: store.searchList!)
              : const SizedBox())
        ]));
  }
}
