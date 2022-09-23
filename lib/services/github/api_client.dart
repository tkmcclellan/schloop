import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:schloop/services/api_response.dart';
import 'package:schloop/services/config.dart';
import 'package:schloop/services/storage.dart';

class GitHub {
  static Future<void> init([Map<String, dynamic>? token]) async {
    if (token != null) {
      await Storage.writeString('github_auth_token', jsonEncode(token));
    } else {
      token =
          jsonDecode((await Storage.readString('github_auth_token')) ?? 'null');
    }

    _authToken = token;
  }

  static Future<void> reset() async {
    await Storage.delete('github_auth_token');
    _authToken = null;
  }

  static bool get initialized {
    return _authToken != null;
  }

  static Map<String, dynamic>? _authToken;

  static Future<ApiResponse> get(String url,
      {Map<String, dynamic>? query}) async {
    final Uri uri = Uri.https('api.github.com', url, query);
    final http.Response response = await http.get(uri, headers: _headers);

    return ApiResponse.fromHttpResponse(response);
  }

  static GraphQLClient get graphQL {
    final HttpLink httpLink = HttpLink('https://api.github.com/graphql');
    final AuthLink authLink =
        AuthLink(getToken: () => 'Bearer ${_authToken?['access_token']}');
    final Link link = authLink.concat(httpLink);
    final GraphQLClient client =
        GraphQLClient(link: link, cache: GraphQLCache());

    return client;
  }

  static Future<ApiResponse> getDeviceCode() async {
    final String clientId = Config.get('client_id')!;
    final Uri uri = Uri.https(
        'github.com', '/login/device/code', <String, String>{
      'client_id': clientId,
      'scope': 'repo read:org read:user user:email'
    });
    final http.Response response = await http.post(uri, headers: _headers);

    return ApiResponse.fromHttpResponse(response);
  }

  static Future<ApiResponse> pollAuthToken(String deviceCode) async {
    final String clientId = Config.get('client_id')!;
    final Uri uri =
        Uri.https('github.com', '/login/oauth/access_token', <String, String>{
      'client_id': clientId,
      'device_code': deviceCode,
      'grant_type': 'urn:ietf:params:oauth:grant-type:device_code'
    });
    final http.Response response = await http.post(uri, headers: _headers);

    return ApiResponse.fromHttpResponse(response);
  }

  static Map<String, String> get _headers {
    return <String, String>{
      'Accept': 'application/vnd.github.v3+json',
      'Authorization': 'Bearer ${_authToken?['access_token']}'
    };
  }
}
