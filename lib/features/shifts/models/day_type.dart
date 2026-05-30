import 'package:isar_community/isar.dart';

part 'day_type.g.dart';

@collection
class DayType {
  Id id = Isar.autoIncrement;

  late String name;

  late int backgroundColor;
  late int textColor;

  int? startHour;
  int? startMinute;
  int? endHour;
  int? endMinute;

  bool isWorkDay = true;
}