import 'package:isar/isar.dart';
import './source_control.dart';

part 'user.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;

  String? name, avatarUrl;

  SourceControl? sourceControl;
}
