import 'package:schloop/services/api_response.dart';
import 'package:schloop/services/github/api_client.dart';
import 'package:schloop/services/github/pull.dart';

class GitHubRepo {
  GitHubRepo(
      {required this.id,
      required this.name,
      required this.fullName,
      required this.description,
      required this.url});

  factory GitHubRepo.fromApiResponse(ApiResponse response) {
    return GitHubRepo.fromHash(response.body);
  }

  factory GitHubRepo.fromHash(Map<String, dynamic> hash) {
    return GitHubRepo(
        id: hash['id'].toString(),
        name: hash['name'],
        fullName: hash['full_name'],
        description: hash['description'],
        url: hash['url']);
  }

  factory GitHubRepo.fromGraphQL(Map<String, dynamic> hash) {
    return GitHubRepo(
        id: hash['id'].toString(),
        name: hash['name'],
        fullName: hash['nameWithOwner'],
        description: hash['description'],
        url: hash['url']);
  }

  Future<List<GitHubPull>> pulls() async {
    final ApiResponse response = await GitHub.get('/repos/$fullName/pulls');

    final List<GitHubPull> githubPulls = response.body
        .map<GitHubPull>((dynamic item) =>
            GitHubPull.fromHash(Map<String, dynamic>.from(item)))
        .toList();

    return githubPulls;
  }

  final String id, name, fullName, url;
  final String? description;
}
