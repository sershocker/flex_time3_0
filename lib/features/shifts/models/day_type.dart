import 'package:isar/isar.dart';

part 'day_type.g.dart';

@collection
class DayType {
  Id id = Isar.autoIncrement;

  late String name;

  late int backgroundColor;

  late int textColor;

  //начало смены время
  int? startHour;
  int? startMinute;

  //конец смены время
  int? endHour;
  int? endMinute;
}