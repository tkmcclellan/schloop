import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLQuery extends StatefulWidget {
  GraphQLQuery(
      {required this.client, required this.options, required this.builder});

  final GraphQLClient client;
  final QueryOptions<Widget> options;
  final Widget Function(QueryResult<Widget>) builder;

  @override
  _GraphQLQueryState createState() => _GraphQLQueryState();
}

class _GraphQLQueryState extends State<GraphQLQuery> {
  QueryResult<Widget>? _queryResult;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    super
        .widget
        .client
        .query(super.widget.options)
        .then((QueryResult<Widget> result) {
      setState(() {
        _queryResult = result;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Text('Loading...');
    } else {
      return super.widget.builder(_queryResult!);
    }
  }
}
