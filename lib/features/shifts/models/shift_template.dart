import 'package:isar_community/isar.dart';

part 'shift_template.g.dart';

@collection
class ShiftTemplate {
  Id id = Isar.autoIncrement;

  late String name;

  //список ID типов дней в цикле
  late List<int> dayTypeIds;
}