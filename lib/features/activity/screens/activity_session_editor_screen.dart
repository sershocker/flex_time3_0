import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../providers/activity_stats_provider.dart';

class ActivitySessionEditorScreen extends ConsumerStatefulWidget {
  final Activity session;

  const ActivitySessionEditorScreen({super.key, required this.session});

  @override
  ConsumerState<ActivitySessionEditorScreen> createState() => _ActivitySessionEditorScreenState();
}

class _ActivitySessionEditorScreenState extends ConsumerState<ActivitySessionEditorScreen> {
  late DateTime _startTime;
  late DateTime _endTime;
  late int _selectedTypeId;

  @override
  void initState() {
    super.initState();
    _startTime = widget.session.startTime;
    _endTime = widget.session.endTime ?? DateTime.now();
    _selectedTypeId = widget.session.typeId;
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final initialDate = isStart ? _startTime : _endTime;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute,
          );
          if (isStart) {
            _startTime = newDateTime;
          } else {
            _endTime = newDateTime;
          }
        });
      }
    }
  }

  void _save() async {
    if (_endTime.isBefore(_startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Время окончания не может быть раньше начала!')),
      );
      return;
    }

    final repo = ref.read(activityRepositoryProvider);
    final updatedSession = Activity()
      ..id = widget.session.id
      ..typeId = _selectedTypeId
      ..startTime = _startTime
      ..endTime = _endTime;

    await repo.saveActivitySession(updatedSession);

    //обновить статистику
    ref.invalidate(activityHistoryProvider);
    if (mounted) Navigator.pop(context);
  }

  void _delete() async {
    final repo = ref.read(activityRepositoryProvider);
    await repo.deleteActivitySession(widget.session.id);

    ref.invalidate(activityHistoryProvider);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final types = ref.watch(activityTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать запись'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            value: _selectedTypeId,
            decoration: const InputDecoration(labelText: 'Тип активности'),
            items: types.map((t) {
              return DropdownMenuItem(value: t.id, child: Text(t.name));
            }).toList(),
            onChanged: (val) => setState(() => _selectedTypeId = val!),
          ),
          const SizedBox(height: 24),

          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Начало'),
            subtitle: Text('${_startTime.day}.${_startTime.month}.${_startTime.year} ${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}'),
            trailing: const Icon(Icons.edit),
            onTap: () => _pickDateTime(isStart: true),
          ),
          const Divider(),

          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Окончание'),
            subtitle: Text('${_endTime.day}.${_endTime.month}.${_endTime.year} ${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}'),
            trailing: const Icon(Icons.edit),
            onTap: () => _pickDateTime(isStart: false),
          ),

          const SizedBox(height: 32),
          ElevatedButton(onPressed: _save, child: const Text('Сохранить изменения'))
        ],
      ),
    );
  }
}