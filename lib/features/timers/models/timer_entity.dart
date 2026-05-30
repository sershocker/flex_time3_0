import 'package:isar_community/isar.dart';

part 'timer_entity.g.dart';

enum UnitType { seconds, minutes, hours, days, weeks, months, years, combined }
enum ViewType { circle, line }

@collection
class TimerEntity {
  Id id = Isar.autoIncrement;

  late String title;

  String? description;

  DateTime? startDate;

  DateTime? endDate;

  int? eventId;

  late int progressColor;

  @enumerated
  late UnitType unitType;

  @enumerated
  late ViewType viewType;
}
