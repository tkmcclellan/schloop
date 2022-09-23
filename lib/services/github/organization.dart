import 'package:schloop/services/api_response.dart';
import 'package:schloop/services/github/api_client.dart';
import 'package:schloop/services/github/repo.dart';
import 'package:schloop/services/github/user.dart';

class GitHubOrganization {
  GitHubOrganization(
      {required this.login,
      required this.id,
      required this.description,
      required this.avatarUrl});

  factory GitHubOrganization.fromApiResponse(ApiResponse response) {
    return GitHubOrganization.fromHash(response.body);
  }

  factory GitHubOrganization.fromHash(Map<String, dynamic> hash) {
    return GitHubOrganization(
        login: hash['login'],
        id: hash['id'],
        avatarUrl: hash['avatar_url'],
        description: hash['description']);
  }

  Future<List<GitHubUser>> members() async {
    final ApiResponse response = await GitHub.get('/orgs/$login/members');

    final List<GitHubUser> githubUsers = response.body
        .map<GitHubUser>((dynamic item) =>
            GitHubUser.fromHash(Map<String, dynamic>.from(item)))
        .toList();

    return githubUsers;
  }

  Future<List<GitHubRepo>> repos() async {
    final ApiResponse response = await GitHub.get('/orgs/$login/repos');

    final List<GitHubRepo> githubRepos = response.body
        .map<GitHubRepo>((dynamic item) =>
            GitHubRepo.fromHash(Map<String, dynamic>.from(item)))
        .toList();

    return githubRepos;
  }

  final String login, description, avatarUrl;
  final int id;
}
