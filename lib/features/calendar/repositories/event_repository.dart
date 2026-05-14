import 'package:isar/isar.dart';
import '../../../core/database/local_db.dart';
import '../models/event.dart';

class EventRepository {
  final Isar _isar = LocalDb.instance;

  Future<List<Event>> getAllEvents() async {
    return await _isar.events.where().findAll();
  }

  Future<void> saveEvent(Event event) async {
    await _isar.writeTxn(() async {
      await _isar.events.put(event);
    });
  }

  Future<void> deleteEvent(int id) async {
    await _isar.writeTxn(() async {
      await _isar.events.delete(id);
    });
  }
}