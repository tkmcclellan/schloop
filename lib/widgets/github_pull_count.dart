import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:schloop/models/source_control.dart';
import 'package:schloop/services/github/api_client.dart';
import 'package:schloop/widgets/graphql_query.dart';

class GitHubPullCount extends StatelessWidget {
  GitHubPullCount({required this.user});

  final SourceControl user;

  static const String _query = '''
      query(\$userLogin: String!) {
        user(login: \$userLogin) {
          id,
          login,
          pullRequests(first: 100, states: OPEN) {
            edges {
              node {
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
                }
              }
            }
          }
        }
      }
      ''';

  @override
  Widget build(BuildContext context) {
    return GraphQLQuery(
        client: GitHub.graphQL,
        options: QueryOptions<Widget>(
            document: gql(_query),
            variables: <String, String?>{'userLogin': user.username}),
        builder: (QueryResult<Widget> result) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Text('Loading');
          }

          final int? pulls =
              result.data?['user']?['pullRequests']?['edges']?.length;

          if (pulls == null) {
            return const Text('No repositories');
          } else {
            return Text('Open Pull Requests: $pulls');
          }
        });
  }
}
