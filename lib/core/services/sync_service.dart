import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/calendar/models/event.dart';
import '../../features/calendar/repositories/event_repository.dart';
import '../../features/calendar/providers/event_provider.dart';
import '../../features/settings/providers/settings_provider.dart';
import 'google_calendar_service.dart';

final syncServiceProvider = Provider((ref) => SyncService(ref));

class SyncService {
  final Ref _ref;
  final GoogleCalendarService _googleCalendarService = GoogleCalendarService();

  SyncService(this._ref);

  Future<void> syncEvents() async {
    final settings = _ref.read(settingsProvider);
    if (!settings.googleSyncEnabled) return;

    final repository = _ref.read(eventRepositoryProvider);
    
    //отправка изменений
    final eventsToSync = await repository.getEventsToSync();
    for (final event in eventsToSync) {
      if (event.isDeletedLocally) {
        if (event.googleEventId != null) {
          final success = await _googleCalendarService.deleteEvent(event.googleEventId!);
          if (success) {
            await repository.hardDeleteEvent(event.id);
          }
        } else {
          await repository.hardDeleteEvent(event.id);
        }
      } else {
        final googleId = await _googleCalendarService.upsertEvent(event);
        if (googleId != null) {
          event.googleEventId = googleId;
          event.needsSync = false;
          event.lastSyncedAt = DateTime.now();
          await repository.saveEvent(event);
        }
      }
    }

    //получение изменений
    final googleEvents = await _googleCalendarService.fetchEvents(
      minTime: DateTime.now().subtract(const Duration(days: 30)),
      maxTime: DateTime.now().add(const Duration(days: 365)),
    );

    for (final gEvent in googleEvents) {
      if (gEvent.id == null) continue;

      final localEvent = await repository.getEventByGoogleId(gEvent.id!);
      
      if (localEvent == null) {
        //создание локально
        final newEvent = Event()
          ..title = gEvent.summary ?? 'Без названия'
          ..description = gEvent.description
          ..dateTime = gEvent.start?.dateTime ?? gEvent.start?.date ?? DateTime.now()
          ..endTime = gEvent.end?.dateTime ?? gEvent.end?.date
          ..googleEventId = gEvent.id
          ..etag = gEvent.etag
          ..color = GoogleCalendarService.getColorFromGoogleId(gEvent.colorId) // Синхронизация цвета
          ..lastSyncedAt = DateTime.now()
          ..needsSync = false;
        
        await repository.saveEvent(newEvent);
      } else {
        //локально обновить если ETag изменился
        if (localEvent.etag != gEvent.etag && !localEvent.needsSync) {
          localEvent
            ..title = gEvent.summary ?? 'Без названия'
            ..description = gEvent.description
            ..dateTime = gEvent.start?.dateTime ?? gEvent.start?.date ?? DateTime.now()
            ..endTime = gEvent.end?.dateTime ?? gEvent.end?.date
            ..etag = gEvent.etag
            ..color = GoogleCalendarService.getColorFromGoogleId(gEvent.colorId) // Синхронизация цвета
            ..lastSyncedAt = DateTime.now()
            ..needsSync = false;
          
          await repository.saveEvent(localEvent);
        }
      }
    }
  }
}
