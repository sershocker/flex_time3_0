import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/day_type.dart';
import '../models/shift_template.dart';
import '../models/shift_schedule.dart';
import '../repositories/shift_repository.dart';

final shiftRepositoryProvider = Provider((ref) => ShiftRepository());

//для типов дней
final dayTypesProvider = StateNotifierProvider<DayTypesNotifier, List<DayType>>((ref) {
  final repo = ref.watch(shiftRepositoryProvider);
  return DayTypesNotifier(repo);
});

class DayTypesNotifier extends StateNotifier<List<DayType>> {
  final ShiftRepository _repository;

  DayTypesNotifier(this._repository) : super([]) {
    loadData();
  }

  Future<void> loadData() async {
    var types = await _repository.getDayTypes();
    if (types.isEmpty) {
      await _initDefaults();
      types = await _repository.getDayTypes();
    }
    state = types;
  }

  Future<void> _initDefaults() async {
    final defaults = [
      DayType()..name = 'День'..backgroundColor = Colors.amber.value..textColor = Colors.black.value,
      DayType()..name = 'Ночь'..backgroundColor = Colors.indigo.value..textColor = Colors.white.value,
      DayType()..name = 'Отсыпной'..backgroundColor = Colors.grey.value..textColor = Colors.white.value,
      DayType()..name = 'Выходной'..backgroundColor = Colors.transparent.value..textColor = Colors.white.value,
      DayType()..name = 'Рабочий'..backgroundColor = Colors.blue.value..textColor = Colors.white.value,
    ];
    for (var d in defaults) {
      await _repository.saveDayType(d);
    }
  }

  Future<void> save(DayType type) async {
    await _repository.saveDayType(type);
    await loadData();
  }

  Future<void> delete(int id) async {
    await _repository.deleteDayType(id);
    await loadData();
  }
}

//для шаблонов
final shiftTemplatesProvider = StateNotifierProvider<TemplatesNotifier, List<ShiftTemplate>>((ref) {
  final repo = ref.watch(shiftRepositoryProvider);
  return TemplatesNotifier(repo);
});

class TemplatesNotifier extends StateNotifier<List<ShiftTemplate>> {
  final ShiftRepository _repository;

  TemplatesNotifier(this._repository) : super([]) {
    loadData();
  }

  Future<void> loadData() async {
    state = await _repository.getTemplates();
  }

  Future<void> save(ShiftTemplate template) async {
    await _repository.saveTemplate(template);
    await loadData();
  }

  Future<void> delete(int id) async {
    await _repository.deleteTemplate(id);
    await loadData();
  }
}

//провайдер рафиков
final shiftSchedulesProvider = StateNotifierProvider<SchedulesNotifier, List<ShiftSchedule>>((ref) {
  final repo = ref.watch(shiftRepositoryProvider);
  return SchedulesNotifier(repo);
});

class SchedulesNotifier extends StateNotifier<List<ShiftSchedule>> {
  final ShiftRepository _repository;

  SchedulesNotifier(this._repository) : super([]) {
    loadData();
  }

  Future<void> loadData() async {
    state = await _repository.getSchedules();
  }

  Future<void> save(ShiftSchedule schedule) async {
    await _repository.saveSchedule(schedule);
    await loadData();
  }

  Future<void> delete(int id) async {
    await _repository.deleteSchedule(id);
    await loadData();
  }
}