import 'package:isar_community/isar.dart';

part 'shift_schedule.g.dart';

@collection
class ShiftSchedule {
  Id id = Isar.autoIncrement;

  late String title;
  String? description;

  late int templateId;
  late DateTime startDate;
  DateTime? endDate;

  late int offset;
  late int color;
}