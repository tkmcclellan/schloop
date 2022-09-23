import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences? _prefs;

  static Future<bool> writeString(String key, String value) async {
    _prefs ??= await SharedPreferences.getInstance();

    return await _prefs!.setString(key, value);
  }

  static Future<String?> readString(String key) async {
    _prefs ??= await SharedPreferences.getInstance();

    return _prefs!.getString(key);
  }

  static Future<bool> delete(String key) async {
    _prefs ??= await SharedPreferences.getInstance();

    return _prefs!.remove(key);
  }
}
