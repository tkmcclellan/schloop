import 'dart:convert';
import 'package:http/http.dart' show Response;

class ApiResponse {
  ApiResponse({required this.status, required this.body});

  factory ApiResponse.fromHttpResponse(Response response) {
    final dynamic parsedBody = jsonDecode(response.body);

    return ApiResponse(status: response.statusCode, body: parsedBody);
  }

  final int status;
  final dynamic body;
}
