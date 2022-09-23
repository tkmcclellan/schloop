import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:schloop/models/source_control.dart';
import 'package:schloop/services/github/api_client.dart';
import 'package:schloop/services/github/pull.dart';
import 'package:schloop/widgets/github_pull_preview.dart';
import 'package:schloop/widgets/graphql_query.dart';

class GitHubPullList extends StatelessWidget {
  GitHubPullList({required this.user});

  final SourceControl user;

  @override
  Widget build(BuildContext context) {
    return GraphQLQuery(
        client: GitHub.graphQL,
        options: QueryOptions<Widget>(
            document: gql(_query),
            variables: <String, String?>{'userLogin': user.username}),
        builder: (QueryResult<Widget> result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Text('Loading');
          }

          final List<GitHubPull>? pulls = result.data?['user']?['pullRequests']
                  ?['edges']
              ?.map<GitHubPull>((dynamic edge) => GitHubPull.fromGraphQL(
                  Map<String, dynamic>.from(edge['node'])))
              .toList();

          if (pulls == null || pulls.isEmpty) {
            return const Center(child: Text('No pull requests.'));
          } else {
            return Container(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: pulls.length,
                    itemBuilder: (BuildContext context, int index) {
                      final GitHubPull pull = pulls[(pulls.length - 1) - index];

                      return GitHubPullPreview(pull: pull);
                    }));
          }
        });
  }

  static const String _query = '''
query (\$userLogin: String!) {
  user(login: \$userLogin) {
    id
    login
    pullRequests(first: 100, states: OPEN) {
      edges {
        node {
          id,
          url,
          number,
          state,
          locked,
          title,
          bodyText,
          isDraft,
          assignees(first:100) {
            edges {
              node {
                id,
                avatarUrl,
                login
              }
            }
          },
          author {
            avatarUrl,
            login
          },
          reviewRequests(first:100) {
            nodes {
              id,
              requestedReviewer {
                ... on User {
                  id,
                  login,
                  avatarUrl
                }
              }
            }
          },
          repository {
            id,
            name,
            nameWithOwner,
            description,
            url
          }
        }
      }
    }
  }
}
      ''';
}
