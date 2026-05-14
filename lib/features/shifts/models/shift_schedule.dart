import 'package:isar/isar.dart';

part 'shift_schedule.g.dart';

@collection
class ShiftSchedule {
  Id id = Isar.autoIncrement;

  late String title;

  //шаблон
  late int templateId;

  late DateTime startDate;

  DateTime? endDate;

  late int offset;

  late int color;

  String? description;
}