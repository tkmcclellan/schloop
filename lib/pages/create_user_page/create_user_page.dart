import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:schloop/models/user.dart';
import 'package:schloop/services/db/client.dart';
import 'package:schloop/services/github/user.dart';
import 'package:schloop/stores/user_store.dart';
import 'package:schloop/widgets/github_user_preview.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _avatarUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(Duration.zero, () {
      final User? argUser = ModalRoute.of(context)?.settings.arguments as User;
      final UserStore store = context.read<UserStore>();

      if (argUser != null) {
        _nameController.text = argUser.name ?? '';
        _avatarUrlController.text = argUser.avatarUrl ?? '';
      }

      store.currentUser = argUser ?? User();
    });
  }

  void _createUser() async {
    final Isar isar = await DB.instance;
    final UserStore store = context.read<UserStore>();

    await isar.writeTxn(() async {
      await isar.users.put(store.currentUser!);
    });

    store.fetchUsers();
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    final UserStore store = context.watch<UserStore>();
    final User? user = store.currentUser;

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context))),
        body: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              const Text('Name:'),
              TextFormField(
                  onSaved: (String? value) =>
                      setState(() => user!.name = value),
                  controller: _nameController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username.';
                    }
                    return null;
                  }),
              const Text('Avatar Url:'),
              TextFormField(
                  onSaved: (String? value) =>
                      setState(() => user!.avatarUrl = value),
                  controller: _avatarUrlController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an avatar url.';
                    }
                    return null;
                  }),
              const Text('Source Control:'),
              user?.sourceControl == null
                  ? ElevatedButton(
                      child: const Text('Add Source Control Account'),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/user/search'))
                  : Row(children: <Widget>[
                      GitHubUserPreview(
                          user: user?.sourceControl! as GitHubUser),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () =>
                              setState(() => user!.sourceControl = null))
                    ]),
              ElevatedButton(
                  onPressed: () {
                    final FormState currentState = _formKey.currentState!;

                    if (currentState.validate()) {
                      currentState.save();

                      _createUser();
                    }
                  },
                  child: const Text('Create User'))
            ])));
  }
}
