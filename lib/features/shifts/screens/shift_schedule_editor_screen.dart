import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/day_type.dart';
import '../models/shift_schedule.dart';
import '../models/shift_template.dart';
import '../providers/shift_provider.dart';

class ShiftScheduleEditorScreen extends ConsumerStatefulWidget {
  final ShiftSchedule? schedule;

  const ShiftScheduleEditorScreen({super.key, this.schedule});

  @override
  ConsumerState<ShiftScheduleEditorScreen> createState() => _ShiftScheduleEditorScreenState();
}

class _ShiftScheduleEditorScreenState extends ConsumerState<ShiftScheduleEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;

  ShiftTemplate? _selectedTemplate;
  late DateTime _startDate;
  DateTime? _endDate;
  late int _offset;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.schedule?.title ?? '');
    _descController = TextEditingController(text: widget.schedule?.description ?? '');
    _startDate = widget.schedule?.startDate ?? DateTime.now();
    _endDate = widget.schedule?.endDate;
    _offset = widget.schedule?.offset ?? 0;
    _selectedColor = widget.schedule != null ? Color(widget.schedule!.color) : Colors.blue;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = isStart ? _startDate : (_endDate ?? DateTime.now());
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
          if (_endDate != null && _startDate.isAfter(_endDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (_selectedTemplate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Выберите шаблон смены!')),
        );
        return;
      }

      final newSchedule = ShiftSchedule()
        ..title = _titleController.text
        ..description = _descController.text
        ..templateId = _selectedTemplate!.id
        ..startDate = DateTime(_startDate.year, _startDate.month, _startDate.day)
        ..endDate = _endDate != null ? DateTime(_endDate!.year, _endDate!.month, _endDate!.day) : null
        ..offset = _offset
        ..color = _selectedColor.value;

      if (widget.schedule != null) newSchedule.id = widget.schedule!.id;

      ref.read(shiftSchedulesProvider.notifier).save(newSchedule);
      Navigator.pop(context);
    }
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _selectedColor;
        return AlertDialog(
          title: const Text('Цвет маркера графика'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) => tempColor = color,
            ),
          ),
          actions: [
            TextButton(child: const Text('Выбрать'), onPressed: () {
              setState(() => _selectedColor = tempColor);
              Navigator.pop(context);
            }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final templates = ref.watch(shiftTemplatesProvider);
    final dayTypes = ref.watch(dayTypesProvider);

    //если редактировать существующий график, то подставить его шаблон
    if (_selectedTemplate == null && widget.schedule != null && templates.isNotEmpty) {
      try {
        _selectedTemplate = templates.firstWhere((t) => t.id == widget.schedule!.templateId);
      } catch (e) {
        //шаблон был удален
      }
    }

    //защита от смещения
    if (_selectedTemplate != null && _offset >= _selectedTemplate!.dayTypeIds.length) {
      _offset = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schedule == null ? 'Новый график' : 'Редактировать'),
        actions: [
          if (widget.schedule != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(shiftSchedulesProvider.notifier).delete(widget.schedule!.id);
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
              decoration: const InputDecoration(labelText: 'Название графика'),
              validator: (v) => v!.isEmpty ? 'Введите название' : null,
            ),
            const SizedBox(height: 16),

            //выбор шаблона
            DropdownButtonFormField<ShiftTemplate>(
              value: _selectedTemplate,
              decoration: const InputDecoration(labelText: 'Шаблон графика'),
              items: templates.map((t) {
                return DropdownMenuItem(value: t, child: Text(t.name));
              }).toList(),
              onChanged: (val) => setState(() {
                _selectedTemplate = val;
                _offset = 0;
              }),
              validator: (v) => v == null ? 'Выберите шаблон' : null,
            ),
            const SizedBox(height: 24),

            //даты
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Начало графика'),
              subtitle: Text('${_startDate.day}.${_startDate.month}.${_startDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(isStart: true),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Конец графика'),
              subtitle: Text(_endDate != null ? '${_endDate!.day}.${_endDate!.month}.${_endDate!.year}' : 'не выбрано'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_endDate != null)
                    IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _endDate = null)),
                  const Icon(Icons.calendar_today),
                ],
              ),
              onTap: () => _pickDate(isStart: false),
            ),
            const Divider(),

            //смещение
            if (_selectedTemplate != null && _selectedTemplate!.dayTypeIds.isNotEmpty) ...[
              const SizedBox(height: 16),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _offset,
                decoration: const InputDecoration(labelText: 'Первая смена графика'),
                items: List.generate(_selectedTemplate!.dayTypeIds.length, (index) {
                  final dayId = _selectedTemplate!.dayTypeIds[index];
                  final dayName = dayTypes.firstWhere((d) => d.id == dayId, orElse: () => DayType()..name = 'Неизвестно').name;
                  return DropdownMenuItem(
                      value: index,
                      child: Text('Смена ${index + 1}: $dayName')
                  );
                }),
                onChanged: (val) => setState(() => _offset = val!),
              ),
              const SizedBox(height: 24),
            ],

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Цвет графика'),
              trailing: CircleAvatar(backgroundColor: _selectedColor),
              onTap: _openColorPicker,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _save,
              child: const Text('Сохранить график', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}