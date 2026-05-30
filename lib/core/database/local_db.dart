import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/calendar/models/event.dart';
import '../../features/timers/models/timer_entity.dart';
import '../../features/activity/models/activity_type.dart';
import '../../features/activity/models/activity.dart';
import '../../features/shifts/models/day_type.dart';
import '../../features/shifts/models/shift_template.dart';
import '../../features/shifts/models/shift_schedule.dart';
import '../../features/settings/models/app_settings.dart';

class LocalDb {
  static late Isar instance;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    instance = await Isar.open(
      [
        EventSchema,
        TimerEntitySchema,
        ActivityTypeSchema,
        ActivitySchema,
        DayTypeSchema,
        ShiftTemplateSchema,
        ShiftScheduleSchema,
        AppSettingsSchema,
      ],
      directory: dir.path,
    );
  }
}