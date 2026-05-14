import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';

//провайдер репозитория
final eventRepositoryProvider = Provider((ref) => EventRepository());

//провайдер списка событий
final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  final repo = ref.watch(eventRepositoryProvider);
  return EventsNotifier(repo);
});

class EventsNotifier extends StateNotifier<List<Event>> {
  final EventRepository _repository;

  EventsNotifier(this._repository) : super([]) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    state = await _repository.getAllEvents();
  }

  Future<void> addEvent(Event event) async {
    await _repository.saveEvent(event);
    await loadEvents(); //перезагрузка после добавления
  }

  Future<void> deleteEvent(int id) async {
    await _repository.deleteEvent(id);
    await loadEvents();
  }
}