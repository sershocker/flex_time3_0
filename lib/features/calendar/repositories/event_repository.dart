import 'package:isar_community/isar.dart';
import '../../../core/database/local_db.dart';
import '../models/event.dart';

class EventRepository {
  final Isar _isar = LocalDb.instance;

  Future<List<Event>> getAllEvents() async {
    return await _isar.events.where().filter().isDeletedLocallyEqualTo(false).findAll();
  }

  Future<int> saveEvent(Event event) async {
    print("########Я сохранился ########");
    return await _isar.writeTxn(() async {
      return await _isar.events.put(event);
    });
  }

  Future<void> deleteEvent(int id) async {
    print("########Я делитнулся ########");
    final event = await _isar.events.get(id);
    if (event == null) return;

    await _isar.writeTxn(() async {
      if (event.googleEventId != null) {
        //есть ид то помечаем как удаленное
        event.isDeletedLocally = true;
        event.needsSync = true;
        await _isar.events.put(event);
      } else {
        //нет ид гугла то удаляем сразу
        await _isar.events.delete(id);
      }
    });
  }

  Future<void> hardDeleteEvent(int id) async {
    print("########Я делитнулся хардово ########");
    await _isar.writeTxn(() async {
      await _isar.events.delete(id);
    });
  }

  Future<List<Event>> getEventsToSync() async {
    print("########Я получил для синхронизации ########");
    return await _isar.events.where().filter().needsSyncEqualTo(true).findAll();
  }

  Future<Event?> getEventByGoogleId(String googleId) async {
    print("########Я получил по гугл id ########");
    return await _isar.events.where().filter().googleEventIdEqualTo(googleId).findFirst();
  }
}
