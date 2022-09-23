import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:schloop/models/user.dart';
import 'package:schloop/services/db/client.dart';

class UserStore extends ChangeNotifier {
  UserStore() {
    fetchUsers();
  }

  List<User>? _users;
  User? _currentUser;

  void fetchUsers() async {
    final Isar isar = await DB.instance;

    users = await isar.users.where().findAll();
  }

  List<User>? get users => _users;
  set users(List<User>? newUsers) {
    _users = newUsers;
    notifyListeners();
  }

  User? get currentUser => _currentUser;
  set currentUser(User? newUser) {
    _currentUser = newUser;
    notifyListeners();
  }
}
