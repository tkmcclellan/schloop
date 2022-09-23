import 'dart:convert' show jsonDecode;
import 'package:flutter/services.dart' show rootBundle;

class Config {
  static Map<String, dynamic>? _config;

  static Future<Map<String, dynamic>?> init() async {
    final String? configString =
        await rootBundle.loadString('assets/config.json');

    _config = jsonDecode(configString ?? 'null');

    return _config;
  }

  static dynamic get(String key) {
    return _config?[key];
  }
}
