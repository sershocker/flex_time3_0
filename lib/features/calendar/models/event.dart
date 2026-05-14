import 'package:isar/isar.dart';

part 'event.g.dart';

@collection
class Event {
  Id id = Isar.autoIncrement;

  late String title;

  String? description;

  late DateTime dateTime;

  late int color;
}