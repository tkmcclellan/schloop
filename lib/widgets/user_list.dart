import 'package:flutter/material.dart';
import 'package:schloop/models/user.dart';
import 'package:schloop/widgets/user_list_item.dart';

class UserList extends StatelessWidget {
  UserList({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: users
            .map<Widget>((User user) => UserListItem(user: user))
            .toList());
  }
}
