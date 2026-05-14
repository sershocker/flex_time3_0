import 'package:isar/isar.dart';

part 'activity_type.g.dart';

@collection
class ActivityType {
  Id id = Isar.autoIncrement;

  late String name;

  //код иконки
  late String iconCode;

  late int color;
}