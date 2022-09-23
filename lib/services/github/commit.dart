import 'package:schloop/services/api_response.dart';
import 'package:schloop/services/github/user.dart';

class GitHubCommit {
  GitHubCommit(
      {required this.url,
      required this.htmlUrl,
      required this.sha,
      required this.author,
      required this.committer,
      required this.submittedAt});

  factory GitHubCommit.fromApiResponse(ApiResponse response) {
    return GitHubCommit.fromHash(response.body);
  }

  factory GitHubCommit.fromHash(Map<String, dynamic> hash) {
    return GitHubCommit(
        url: hash['url'],
        htmlUrl: hash['htmlUrl'],
        sha: hash['sha'],
        author: GitHubUser.fromHash(hash['author']),
        committer: GitHubUser.fromHash(hash['committer']),
        submittedAt: DateTime.parse(hash['committer']['date']));
  }

  final String url, htmlUrl, sha;
  final GitHubUser author, committer;
  final DateTime submittedAt;
}
