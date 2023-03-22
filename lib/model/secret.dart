import 'package:isar/isar.dart';
part 'secret.g.dart';

@collection
class Secret {
  Id id = Isar.autoIncrement;
  @Index()
  late String uid;
  @Index(unique: true, replace: true)
  // ignore: non_constant_identifier_names
  late String name;
  // ignore: non_constant_identifier_names
  late String type;
  late String secret;
}
