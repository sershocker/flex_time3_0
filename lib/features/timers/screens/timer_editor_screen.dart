import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/timer_entity.dart';
import '../providers/timer_provider.dart';

class TimerEditorScreen extends ConsumerStatefulWidget {
  final TimerEntity? timer;

  const TimerEditorScreen({super.key, this.timer});

  @override
  ConsumerState<TimerEditorScreen> createState() => _TimerEditorScreenState();
}

class _TimerEditorScreenState extends ConsumerState<TimerEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;

  late DateTime _startDate;
  late DateTime _endDate;

  late Color _selectedColor;
  late ViewType _selectedViewType;
  late UnitType _selectedUnitType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.timer?.title ?? '');
    _descController = TextEditingController(text: widget.timer?.description ?? '');

    _startDate = widget.timer?.startDate ?? DateTime.now();
    _endDate = widget.timer?.endDate ?? DateTime.now().add(const Duration(days: 1));

    _selectedColor = widget.timer != null ? Color(widget.timer!.progressColor) : Colors.blue;
    _selectedViewType = widget.timer?.viewType ?? ViewType.circle;
    _selectedUnitType = widget.timer?.unitType ?? UnitType.seconds;
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final initialDate = isStart ? _startDate : _endDate;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      if (!mounted) return;
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
            _startDate = newDateTime;
            if (_startDate.isAfter(_endDate)) {
              _endDate = _startDate.add(const Duration(hours: 1));
            }
          } else {
            _endDate = newDateTime;
          }
        });
      }
    }
  }

  //палитра цветов
  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _selectedColor;
        return AlertDialog(
          title: const Text('Выберите цвет таймера'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) => tempColor = color,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Выбрать'),
              onPressed: () {
                setState(() => _selectedColor = tempColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveTimer() {
    if (_formKey.currentState!.validate()) {
      if (_endDate.isBefore(_startDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Дата завершения не может быть раньше даты начала')),
        );
        return;
      }

      final newTimer = TimerEntity()
        ..title = _titleController.text
        ..description = _descController.text
        ..startDate = _startDate
        ..endDate = _endDate
        ..progressColor = _selectedColor.value
        ..viewType = _selectedViewType
        ..unitType = _selectedUnitType;

      if (widget.timer != null) newTimer.id = widget.timer!.id;

      ref.read(timersProvider.notifier).addTimer(newTimer);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.timer == null ? 'Новый таймер' : 'Редактировать'),
        actions: [
          if (widget.timer != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(timersProvider.notifier).deleteTimer(widget.timer!.id);
                Navigator.pop(context);
              },
            )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название'),
              validator: (v) => v!.isEmpty ? 'Введите название' : null,
            ),
            const SizedBox(height: 16),

            //дата начала
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Дата и время начала'),
              subtitle: Text('${_startDate.day}.${_startDate.month}.${_startDate.year} ${_startDate.hour.toString().padLeft(2, '0')}:${_startDate.minute.toString().padLeft(2, '0')}'),
              trailing: const Icon(Icons.play_circle_outline),
              onTap: () => _pickDateTime(isStart: true),
            ),
            const Divider(),

            //дата завершения
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Дата и время завершения'),
              subtitle: Text('${_endDate.day}.${_endDate.month}.${_endDate.year} ${_endDate.hour.toString().padLeft(2, '0')}:${_endDate.minute.toString().padLeft(2, '0')}'),
              trailing: const Icon(Icons.stop_circle_outlined),
              onTap: () => _pickDateTime(isStart: false),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<ViewType>(
              value: _selectedViewType,
              decoration: const InputDecoration(labelText: 'Вид таймера'),
              items: const [
                DropdownMenuItem(value: ViewType.circle, child: Text('Круговая диаграмма')),
                DropdownMenuItem(value: ViewType.line, child: Text('Линия прогресса')),
              ],
              onChanged: (val) => setState(() => _selectedViewType = val!),
            ),
            const SizedBox(height: 16),

            //единицы измерения
            DropdownButtonFormField<UnitType>(
              value: _selectedUnitType,
              decoration: const InputDecoration(labelText: 'Единицы измерения'),
              items: const [
                DropdownMenuItem(value: UnitType.seconds, child: Text('Только секунды')),
                DropdownMenuItem(value: UnitType.minutes, child: Text('Только минуты')),
                DropdownMenuItem(value: UnitType.hours, child: Text('Только часы')),
                DropdownMenuItem(value: UnitType.days, child: Text('Только дни')),
                DropdownMenuItem(value: UnitType.weeks, child: Text('Только недели')),
                DropdownMenuItem(value: UnitType.months, child: Text('Только месяцы')),
                DropdownMenuItem(value: UnitType.years, child: Text('Только года')),
              ],
              onChanged: (val) => setState(() => _selectedUnitType = val!),
            ),
            const SizedBox(height: 24),

            //выбор цвета
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Цвет таймера'),
              trailing: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
              ),
              onTap: _openColorPicker,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
                onPressed: _saveTimer,
                child: const Text('Сохранить', style: TextStyle(fontSize: 16))
            )
          ],
        ),
      ),
    );
  }
}