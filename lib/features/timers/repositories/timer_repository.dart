import 'package:isar/isar.dart';
import '../../../core/database/local_db.dart';
import '../models/timer_entity.dart';

class TimerRepository {
  final Isar _isar = LocalDb.instance;

  Future<List<TimerEntity>> getAllTimers() async {
    return await _isar.timerEntitys.where().findAll();
  }

  Future<void> saveTimer(TimerEntity timer) async {
    await _isar.writeTxn(() async {
      await _isar.timerEntitys.put(timer);
    });
  }

  Future<void> deleteTimer(int id) async {
    await _isar.writeTxn(() async {
      await _isar.timerEntitys.delete(id);
    });
  }
}