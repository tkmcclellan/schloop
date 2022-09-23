import 'package:schloop/models/source_control.dart';
import 'package:schloop/services/api_response.dart';
import 'package:schloop/services/github/api_client.dart';
import 'package:schloop/services/github/organization.dart';

class GitHubUser extends SourceControl {
  GitHubUser(
      {int? id, String? platformId, String? username, String? avatarUrl}) {
    this.id = id;
    this.platformId = platformId;
    this.username = username;
    this.avatarUrl = avatarUrl;
  }

  factory GitHubUser.fromApiResponse(ApiResponse response) {
    return GitHubUser.fromHash(response.body);
  }

  factory GitHubUser.fromHash(Map<String, dynamic> hash) {
    return GitHubUser(
        username: hash['login'], id: hash['id'], avatarUrl: hash['avatar_url']);
  }

  factory GitHubUser.fromGraphQL(Map<String, dynamic> hash) {
    return GitHubUser(
        username: hash['login'],
        platformId: hash['id'],
        avatarUrl: hash['avatarUrl']);
  }

  String? get login => username;

  static Future<List<GitHubUser>> search(String username) async {
    final ApiResponse response = await GitHub.get('/search/users',
        query: <String, dynamic>{'q': username});

    final List<Map<String, dynamic>> githubUsers = response.body['items']
        .map<Map<String, dynamic>>(
            (dynamic item) => Map<String, dynamic>.from(item))
        .toList();

    return githubUsers
        .map((Map<String, dynamic> githubUser) =>
            GitHubUser.fromHash(githubUser))
        .toList();
  }

  static Future<GitHubUser> current() async {
    return GitHubUser.fromApiResponse(await GitHub.get('/user'));
  }

  Future<List<GitHubOrganization>> organizations() async {
    final ApiResponse response = await GitHub.get('/user/orgs');

    final List<GitHubOrganization> githubOrgs = response.body
        .map<GitHubOrganization>((dynamic item) =>
            GitHubOrganization.fromHash(Map<String, dynamic>.from(item)))
        .toList();

    return githubOrgs;
  }
}
