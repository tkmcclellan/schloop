import 'package:schloop/services/api_response.dart';
import 'package:schloop/services/github/api_client.dart';
import 'package:schloop/services/github/commit.dart';
import 'package:schloop/services/github/repo.dart';
import 'package:schloop/services/github/review.dart';
import 'package:schloop/services/github/user.dart';

class GitHubPull {
  GitHubPull(
      {required this.id,
      required this.url,
      required this.htmlUrl,
      required this.number,
      required this.state,
      required this.locked,
      required this.title,
      required this.user,
      required this.body,
      required this.assignees,
      required this.reviewers,
      required this.draft,
      required this.repo});

  factory GitHubPull.fromApiResponse(ApiResponse response) {
    return GitHubPull.fromHash(response.body);
  }

  factory GitHubPull.fromHash(Map<String, dynamic> hash) {
    return GitHubPull(
        id: hash['id'],
        url: hash['url'],
        htmlUrl: hash['html_url'],
        number: hash['number'],
        state: _pullStateFromString(hash['state']),
        locked: hash['locked'],
        title: hash['title'],
        body: hash['body'],
        draft: hash['draft'],
        user: GitHubUser.fromHash(hash['user']),
        assignees: hash['assignees']
            .map<GitHubUser>((dynamic user) =>
                GitHubUser.fromHash(Map<String, dynamic>.from(user)))
            .toList(),
        reviewers: hash['reviewers']
            .map<GitHubUser>((dynamic user) =>
                GitHubUser.fromHash(Map<String, dynamic>.from(user)))
            .toList(),
        repo: GitHubRepo.fromHash(hash['repo']));
  }

  factory GitHubPull.fromGraphQL(Map<String, dynamic> hash) {
    return GitHubPull(
        id: hash['id'],
        url: null,
        htmlUrl: hash['url'],
        number: hash['number'],
        state: _pullStateFromString(hash['state']),
        locked: hash['locked'],
        title: hash['title'],
        body: hash['bodyText'],
        draft: hash['isDraft'],
        user: GitHubUser.fromHash(hash['author']),
        assignees: hash['assignees']['edges']
            .map<GitHubUser>((dynamic user) =>
                GitHubUser.fromGraphQL(Map<String, dynamic>.from(user['node'])))
            .toList(),
        reviewers: hash['reviewRequests']?['nodes']
            ?.map<GitHubUser>((dynamic user) => GitHubUser.fromGraphQL(
                Map<String, dynamic>.from(user['requestedReviewer'])))
            .toList(),
        repo: GitHubRepo.fromGraphQL(hash['repository']));
  }

  static GitHubPullState _pullStateFromString(String state) {
    switch (state.toLowerCase()) {
      case 'open':
        return GitHubPullState.open;
      case 'closed':
        return GitHubPullState.closed;
      case 'merged':
        return GitHubPullState.merged;
      default:
        throw 'Invalid Pull State';
    }
  }

  Future<List<GitHubPullReview>> reviews() async {
    final ApiResponse response =
        await GitHub.get('/repos/${repo.fullName}/pulls/$number/reviews');

    final List<GitHubPullReview> githubPulls = response.body
        .map<GitHubPullReview>((dynamic item) =>
            GitHubPullReview.fromHash(Map<String, dynamic>.from(item)))
        .toList();

    return githubPulls;
  }

  Future<List<GitHubCommit>> commits() async {
    final ApiResponse response =
        await GitHub.get('/repos/${repo.fullName}/pulls/$number/commits');

    final List<GitHubCommit> githubCommits = response.body
        .map<GitHubCommit>((dynamic item) =>
            GitHubCommit.fromHash(Map<String, dynamic>.from(item)))
        .toList();

    return githubCommits;
  }

  final int number;
  final String? url, htmlUrl;
  final String id, title, body;
  final GitHubPullState state;
  final bool locked, draft;
  final GitHubUser user;
  final GitHubRepo repo;
  final List<GitHubUser> assignees, reviewers;
}

enum GitHubPullState { open, closed, merged }
