import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:schloop/models/source_control.dart';
import 'package:schloop/models/user.dart';
import 'package:schloop/services/db/client.dart';
import 'package:schloop/stores/user_store.dart';
import 'package:schloop/widgets/github_pull_count.dart';
import 'package:schloop/widgets/github_pull_list.dart';

class UserListItem extends StatefulWidget {
  UserListItem({required this.user});

  final User user;

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  bool _open = false;

  void _handleDelete(UserStore store, int id) async {
    final Isar isar = await DB.instance;

    await isar.writeTxn(() async {
      await isar.users.delete(id);
    });

    store.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();
    final SourceControl? gitHubUser = super.widget.user.sourceControl;

    return Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        Expanded(
            child: Row(children: <Widget>[
          Image.network(super.widget.user.avatarUrl!, height: 150, width: 150),
          Text(super.widget.user.name ?? '')
        ])),
        Expanded(
            child: gitHubUser == null
                ? const Text('Unable to find sourceControl')
                : GitHubPullCount(user: gitHubUser)),
        Expanded(
            child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () =>
                    _handleDelete(userStore, super.widget.user.id))),
        Expanded(
            child: IconButton(
                icon: Icon(_open ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                onPressed: () => setState(() => _open = !_open)))
      ]),
      if (_open) GitHubPullList(user: gitHubUser!)
    ]);
  }
}
