import 'package:isar_community/isar.dart';
import '../../../core/database/local_db.dart';
import '../models/day_type.dart';
import '../models/shift_template.dart';
import '../models/shift_schedule.dart';

class ShiftRepository {
  final Isar _isar = LocalDb.instance;

  Future<List<DayType>> getDayTypes() async {
    return await _isar.dayTypes.where().findAll();
  }

  Future<void> saveDayType(DayType dayType) async {
    await _isar.writeTxn(() async {
      await _isar.dayTypes.put(dayType);
    });
  }

  Future<void> deleteDayType(int id) async {
    await _isar.writeTxn(() async {
      await _isar.dayTypes.delete(id);
      //добавить проверку на испольнование
    });
  }

  Future<List<ShiftTemplate>> getTemplates() async {
    return await _isar.shiftTemplates.where().findAll();
  }

  Future<void> saveTemplate(ShiftTemplate template) async {
    await _isar.writeTxn(() async {
      await _isar.shiftTemplates.put(template);
    });
  }

  Future<void> deleteTemplate(int id) async {
    await _isar.writeTxn(() async {
      await _isar.shiftTemplates.delete(id);
    });
  }

  Future<List<ShiftSchedule>> getSchedules() async {
    return await _isar.shiftSchedules.where().findAll();
  }

  Future<void> saveSchedule(ShiftSchedule schedule) async {
    await _isar.writeTxn(() async {
      await _isar.shiftSchedules.put(schedule);
    });
  }

  Future<void> deleteSchedule(int id) async {
    await _isar.writeTxn(() async {
      await _isar.shiftSchedules.delete(id);
    });
  }
}