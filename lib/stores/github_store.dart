import 'package:flutter/foundation.dart';
import 'package:schloop/services/github/api_client.dart';
import 'package:schloop/services/github/organization.dart';
import 'package:schloop/services/github/user.dart';

class GitHubStore extends ChangeNotifier {
  GitHubStore() {
    if (GitHub.initialized) {
      init();
    }
  }

  GitHubUser? _currentUser;
  List<GitHubOrganization>? _organizations;
  List<GitHubUser>? _searchList;
  String _searchTerm = '';

  Future<void> init() async {
    currentUser = await GitHubUser.current();
    organizations = await currentUser!.organizations();
  }

  Future<void> reset() async {
    _currentUser = null;
    _organizations = null;
    _searchList = null;
    _searchTerm = '';
    notifyListeners();
  }

  void search() async {
    _searchList = await GitHubUser.search(searchTerm);
  }

  List<GitHubUser>? get searchList => _searchList;
  set searchList(List<GitHubUser>? newSearchUserList) {
    _searchList = newSearchUserList;
    notifyListeners();
  }

  GitHubUser? get currentUser => _currentUser;
  set currentUser(GitHubUser? newValue) {
    _currentUser = newValue;
    notifyListeners();
  }

  List<GitHubOrganization>? get organizations => _organizations;
  set organizations(List<GitHubOrganization>? newValue) {
    _organizations = newValue;
    notifyListeners();
  }

  String get searchTerm => _searchTerm;
  set searchTerm(String newValue) {
    _searchTerm = newValue;
    notifyListeners();
  }
}
