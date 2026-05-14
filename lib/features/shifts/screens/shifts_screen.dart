import 'package:flex_time3_0/features/shifts/screens/shift_schedule_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/shift_provider.dart';
import 'day_type_editor_screen.dart';
import 'shift_template_editor_screen.dart';

class ShiftsScreen extends ConsumerWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Графики смен'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Мои графики'),
              Tab(text: 'Шаблоны'),
              Tab(text: 'Типы дней'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _SchedulesTab(),
            _TemplatesTab(),
            _DayTypesTab(),
          ],
        ),
      ),
    );
  }
}

//графики
class _SchedulesTab extends ConsumerWidget {
  const _SchedulesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(shiftSchedulesProvider);
    final templates = ref.watch(shiftTemplatesProvider);

    return Scaffold(
      body: schedules.isEmpty
          ? const Center(child: Text('У вас пока нет активных графиков'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];

          //имя шаблона
          String templateName = 'Удаленный шаблон';
          if (templates.any((t) => t.id == schedule.templateId)) {
            templateName = templates.firstWhere((t) => t.id == schedule.templateId).name;
          }

          return Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(schedule.color)),
              title: Text(schedule.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Шаблон: $templateName\nСтарт: ${schedule.startDate.day}.${schedule.startDate.month}.${schedule.startDate.year}'),
              isThreeLine: true,
              trailing: const Icon(Icons.edit),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ShiftScheduleEditorScreen(schedule: schedule),
                ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const ShiftScheduleEditorScreen(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

//шаблоны
class _TemplatesTab extends ConsumerWidget {
  const _TemplatesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(shiftTemplatesProvider);

    return Scaffold(
      body: templates.isEmpty
          ? const Center(child: Text('Создайте свой первый шаблон смены'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return Card(
            child: ListTile(
              title: Text(template.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Дней в цикле: ${template.dayTypeIds.length}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ShiftTemplateEditorScreen(template: template),
                ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const ShiftTemplateEditorScreen(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

//типы дней
class _DayTypesTab extends ConsumerWidget {
  const _DayTypesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayTypes = ref.watch(dayTypesProvider);

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dayTypes.length,
        itemBuilder: (context, index) {
          final day = dayTypes[index];
          return Card(
            child: ListTile(
              leading: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: Color(day.backgroundColor), shape: BoxShape.circle),
              ),
              title: Text(day.name),
              trailing: const Icon(Icons.edit, size: 20),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DayTypeEditorScreen(dayType: day),
                ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const DayTypeEditorScreen(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}