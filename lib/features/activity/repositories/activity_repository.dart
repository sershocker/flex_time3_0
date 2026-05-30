import 'package:isar_community/isar.dart';
import '../../../core/database/local_db.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';

class ActivityRepository {
  final Isar _isar = LocalDb.instance;

  //типы активностей
  Future<List<ActivityType>> getTypes() async {
    return await _isar.activityTypes.where().findAll();
  }

  Future<void> saveType(ActivityType type) async {
    await _isar.writeTxn(() async {
      await _isar.activityTypes.put(type);
    });
  }

  Future<void> deleteType(int typeId) async {
    await _isar.writeTxn(() async {
      await _isar.activityTypes.delete(typeId);
      await _isar.activitys.filter().typeIdEqualTo(typeId).deleteAll();
    });
  }

  //история активностей
  Future<List<Activity>> getAllActivitySessions() async {
    return await _isar.activitys.where().sortByStartTimeDesc().findAll();
  }

  Future<void> saveActivitySession(Activity activity) async {
    await _isar.writeTxn(() async {
      await _isar.activitys.put(activity);
    });
  }

  Future<void> deleteActivitySession(int id) async {
    await _isar.writeTxn(() async {
      await _isar.activitys.delete(id);
    });
  }
}