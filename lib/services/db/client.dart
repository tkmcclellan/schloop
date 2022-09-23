import 'dart:io' show Directory;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schloop/models/user.dart';

class DB {
  static Isar? _instance;

  static Future<Isar> get instance async {
    if (_instance != null) return _instance!;

    Directory? dir;

    try {
      dir = await getApplicationSupportDirectory();
    } catch (e) {
      print(e);
      dir = null;
    }

    _instance = await Isar.open(<CollectionSchema<dynamic>>[UserSchema],
        directory: dir?.path);

    return _instance!;
  }
}
