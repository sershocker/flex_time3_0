import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';
import '../../../core/services/sync_service.dart';

//провайдер репозитория
final eventRepositoryProvider = Provider((ref) => EventRepository());

//провайдер списка событий
final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  final repo = ref.watch(eventRepositoryProvider);
  return EventsNotifier(repo, ref);
});

class EventsNotifier extends StateNotifier<List<Event>> {
  final EventRepository _repository;
  final Ref _ref;

  EventsNotifier(this._repository, this._ref) : super([]) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    state = await _repository.getAllEvents();
  }

  Future<void> addEvent(Event event) async {
    event.markAsModified(); // Помечаем для синхронизации
    final id = await _repository.saveEvent(event);
    event.id = id;
    await loadEvents();
    
    // Пытаемся синхронизировать в фоновом режиме
    _ref.read(syncServiceProvider).syncEvents().catchError((e) => print('Sync error: $e'));
  }

  Future<void> updateEvent(Event event) async {
    event.markAsModified();
    await _repository.saveEvent(event);
    await loadEvents();
    
    _ref.read(syncServiceProvider).syncEvents().catchError((e) => print('Sync error: $e'));
  }

  Future<void> deleteEvent(int id) async {
    await _repository.deleteEvent(id);
    await loadEvents();
    
    _ref.read(syncServiceProvider).syncEvents().catchError((e) => print('Sync error: $e'));
  }

  Future<void> forceSync() async {
    await _ref.read(syncServiceProvider).syncEvents();
    await loadEvents();
  }
}
