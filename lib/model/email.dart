import 'package:isar/isar.dart';
part 'email.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  String? name;
  String? token;
  String? password;
}
