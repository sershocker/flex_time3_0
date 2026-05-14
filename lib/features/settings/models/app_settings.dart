import 'package:isar/isar.dart';

part 'app_settings.g.dart';

enum ColorSchemeType { red, yellow, green, blue }
enum DayOfWeek { monday, sunday }

@collection
class AppSettings {
  Id id = 1;

  bool isDarkMode = false;

  @enumerated
  ColorSchemeType colorScheme = ColorSchemeType.blue;

  @enumerated
  DayOfWeek firstDayOfWeek = DayOfWeek.monday;

  bool notify24h = true;
  bool notify1h = true;
  bool notifyNow = true;

  bool googleSyncEnabled = false;
}