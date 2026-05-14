import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_type.dart';
import '../repositories/activity_repository.dart';

final activityRepositoryProvider = Provider((ref) => ActivityRepository());

final activityTypesProvider = StateNotifierProvider<ActivityTypesNotifier, List<ActivityType>>((ref) {
  final repo = ref.watch(activityRepositoryProvider);
  return ActivityTypesNotifier(repo);
});

class ActivityTypesNotifier extends StateNotifier<List<ActivityType>> {
  final ActivityRepository _repository;

  ActivityTypesNotifier(this._repository) : super([]) {
    loadTypes();
  }

  Future<void> saveType(ActivityType type) async {
    await _repository.saveType(type);
    await loadTypes();
  }

  Future<void> deleteType(int id) async {
    await _repository.deleteType(id);
    await loadTypes();
  }

  Future<void> loadTypes() async {
    var types = await _repository.getTypes();

    //инит при первом запуске
    if (types.isEmpty) {
      await _initDefaultTypes();
      types = await _repository.getTypes();
    }
    state = types;
  }

  Future<void> _initDefaultTypes() async {
    final defaults = [
      ActivityType()..name = 'Работа'..iconCode = 'work'..color = Colors.blue.value,
      ActivityType()..name = 'Вождение'..iconCode = 'drive'..color = Colors.orange.value,
      ActivityType()..name = 'Еда'..iconCode = 'restaurant'..color = Colors.red.value,
      ActivityType()..name = 'Душ'..iconCode = 'shower'..color = Colors.cyan.value,
      ActivityType()..name = 'Сон'..iconCode = 'bed'..color = Colors.indigo.value,
      ActivityType()..name = 'Спорт'..iconCode = 'fitness'..color = Colors.green.value,
      ActivityType()..name = 'Чтение'..iconCode = 'book'..color = Colors.brown.value,
      ActivityType()..name = 'Отдых'..iconCode = 'weekend'..color = Colors.teal.value,
      ActivityType()..name = 'Игры'..iconCode = 'games'..color = Colors.purple.value,
      ActivityType()..name = 'Учеба'..iconCode = 'school'..color = Colors.amber.value,
      ActivityType()..name = 'Уборка'..iconCode = 'cleaning'..color = Colors.lime.value,
      ActivityType()..name = 'Покупки'..iconCode = 'shopping'..color = Colors.pink.value,
      ActivityType()..name = 'Прогулка'..iconCode = 'walk'..color = Colors.lightGreen.value,
      ActivityType()..name = 'Встреча'..iconCode = 'people'..color = Colors.deepOrange.value,
      ActivityType()..name = 'Хобби'..iconCode = 'palette'..color = Colors.deepPurple.value,
    ];
    for (var type in defaults) {
      await _repository.saveType(type);
    }
  }
}