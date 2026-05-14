import 'package:isar/isar.dart';

part 'shift_template.g.dart';

@collection
class ShiftTemplate {
  Id id = Isar.autoIncrement;

  late String name;

  late List<int> dayTypeIds;
}