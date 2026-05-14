import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timer_entity.dart';
import '../repositories/timer_repository.dart';

final timerRepositoryProvider = Provider((ref) => TimerRepository());

final timersProvider = StateNotifierProvider<TimersNotifier, List<TimerEntity>>((ref) {
  final repo = ref.watch(timerRepositoryProvider);
  return TimersNotifier(repo);
});

class TimersNotifier extends StateNotifier<List<TimerEntity>> {
  final TimerRepository _repository;

  TimersNotifier(this._repository) : super([]) {
    loadTimers();
  }

  Future<void> loadTimers() async {
    state = await _repository.getAllTimers();
  }

  Future<void> addTimer(TimerEntity timer) async {
    await _repository.saveTimer(timer);
    await loadTimers();
  }

  Future<void> deleteTimer(int id) async {
    await _repository.deleteTimer(id);
    await loadTimers();
  }
}