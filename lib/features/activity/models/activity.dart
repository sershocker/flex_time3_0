import 'package:isar_community/isar.dart';

part 'activity.g.dart';

@collection
class Activity {
  Id id = Isar.autoIncrement;

  late int typeId;

  late DateTime startTime;
  DateTime? endTime;

  String? comment;

  //продолжительность в секундах
  int get durationInSeconds {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inSeconds;
  }
}