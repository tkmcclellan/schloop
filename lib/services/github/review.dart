import 'package:schloop/services/api_response.dart';
import 'package:schloop/services/github/user.dart';

class GitHubPullReview {
  GitHubPullReview(
      {required this.id,
      required this.user,
      required this.body,
      required this.state,
      required this.htmlUrl,
      required this.submittedAt,
      required this.commitId});

  factory GitHubPullReview.fromApiResponse(ApiResponse response) {
    return GitHubPullReview.fromHash(response.body);
  }

  factory GitHubPullReview.fromHash(Map<String, dynamic> hash) {
    return GitHubPullReview(
        id: hash['id'],
        htmlUrl: hash['htmlUrl'],
        state: _pullReviewStateFromString(hash['state']),
        body: hash['body'],
        commitId: hash['commit_id'],
        submittedAt: DateTime.parse(hash['submitted_at']),
        user: GitHubUser.fromHash(hash['user']));
  }

  static GitHubPullReviewState _pullReviewStateFromString(String state) {
    switch (state) {
      case 'APPROVED':
        return GitHubPullReviewState.approved;
      case 'COMMENT':
        return GitHubPullReviewState.comment;
      case 'REQUEST CHANGES':
        return GitHubPullReviewState.requestChanges;
      default:
        throw 'Invalid Pull State';
    }
  }

  final int id;
  final GitHubUser user;
  final String body, htmlUrl, commitId;
  final GitHubPullReviewState state;
  final DateTime submittedAt;
}

enum GitHubPullReviewState { approved, comment, requestChanges }
