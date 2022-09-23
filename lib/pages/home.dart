import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schloop/stores/user_store.dart';
import 'package:schloop/widgets/user_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('be schloopin!'), actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'))
      ]),
      body: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: userStore.users != null
            ? UserList(users: userStore.users!)
            : const SizedBox(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/user/search'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
