import 'package:isar/isar.dart';

part 'activity.g.dart';

@collection
class Activity {
  Id id = Isar.autoIncrement;

  late int typeId;

  late DateTime startTime;

  DateTime? endTime;

  String? comment;
}