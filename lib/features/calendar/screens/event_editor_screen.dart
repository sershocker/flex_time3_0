import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/notification_service.dart';

class EventEditorScreen extends ConsumerStatefulWidget {
  final Event? event; //если null то будет новое
  final DateTime? initialDate; // начальная дата для нового события
  final EventType? initialType; // Тип при создании

  const EventEditorScreen({
    super.key,
    this.event,
    this.initialDate,
    this.initialType,
  });

  @override
  ConsumerState<EventEditorScreen> createState() => _EventEditorScreenState();
}

class _EventEditorScreenState extends ConsumerState<EventEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _selectedDate;
  DateTime? _endTime;
  late bool _isAllDay;
  late Color _selectedColor;
  late EventType _type;
  late bool _isCompleted;

  // Timer field
  late bool _isTimer;
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _type = e?.type ?? widget.initialType ?? EventType.event;
    _titleController = TextEditingController(text: e?.title ?? '');
    _descController = TextEditingController(text: e?.description ?? '');
    _selectedDate = e?.dateTime ?? widget.initialDate ?? DateTime.now();
    _endTime = e?.endTime;
    _isAllDay = e?.isAllDay ?? (_type == EventType.holiday);
    _selectedColor = e != null ? Color(e.color) : Colors.blue;
    _isCompleted = e?.isCompleted ?? false;

    _isTimer = e?.isTimer ?? false;
    _notificationsEnabled = e?.notificationsEnabled ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  String _getScreenTitle() {
    final isNew = widget.event == null;
    switch (_type) {
      case EventType.holiday:
        return isNew ? 'Новый праздник' : 'Редактировать праздник';
      case EventType.task:
        return isNew ? 'Новая задача' : 'Редактировать задачу';
      case EventType.event:
      default:
        return isNew ? 'Новое событие' : 'Редактировать событие';
    }
  }

  String _getTitleLabel() {
    switch (_type) {
      case EventType.holiday:
        return 'Название праздника';
      case EventType.task:
        return 'Название задачи';
      case EventType.event:
      default:
        return 'Название события';
    }
  }

  String _getColorLabel() {
    switch (_type) {
      case EventType.holiday:
        return 'Цвет праздника';
      case EventType.task:
        return 'Цвет задачи';
      case EventType.event:
      default:
        return 'Цвет события';
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final DateTime initial = isStart ? _selectedDate : (_endTime ?? _selectedDate);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            _selectedDate.hour,
            _selectedDate.minute,
          );
        } else {
          _endTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            _endTime?.hour ?? _selectedDate.hour + 1,
            _endTime?.minute ?? _selectedDate.minute,
          );
        }
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final DateTime initial = isStart ? _selectedDate : (_endTime ?? _selectedDate.add(const Duration(hours: 1)));

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        } else {
          _endTime = DateTime(
            (_endTime ?? _selectedDate).year,
            (_endTime ?? _selectedDate).month,
            (_endTime ?? _selectedDate).day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      });
    }
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _selectedColor;
        return AlertDialog(
          title: Text(_getColorLabel()),
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

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_type == EventType.event && !_isAllDay && _endTime != null && _endTime!.isBefore(_selectedDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Время окончания не может быть раньше начала'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final event = widget.event ?? Event();
      
      // Логика для разных типов
      bool finalIsAllDay = _isAllDay;
      DateTime? finalEndTime = _endTime;
      
      if (_type == EventType.holiday) {
        finalIsAllDay = true;
        finalEndTime = null;
      } else if (_type == EventType.task) {
        finalEndTime = null;
      }

      event
        ..title = _titleController.text
        ..description = _descController.text
        ..dateTime = _selectedDate
        ..endTime = finalEndTime
        ..isAllDay = finalIsAllDay
        ..color = _selectedColor.toARGB32()
        ..type = _type
        ..isCompleted = _isCompleted
        ..isTimer = _isTimer
        ..notificationsEnabled = _notificationsEnabled;

      if (widget.event == null && _isTimer) {
        event.timerStartDate = DateTime.now();
        event.unitType = UnitType.combined;
        event.viewType = ViewType.circle;
      }

      await ref.read(eventsProvider.notifier).addEvent(event);

      final prefs = await SharedPreferences.getInstance();
      final globalNotificationsEnabled = prefs.getBool('notifications_enabled') ?? false;

      if (globalNotificationsEnabled && _notificationsEnabled) {
        final notifyAtEvent = prefs.getBool('notify_at_event') ?? false;
        final notify15Min = prefs.getBool('notify_15_min') ?? true;
        final notify1Hour = prefs.getBool('notify_1_hour') ?? false;
        final notify1Day = prefs.getBool('notify_1_day') ?? false;

        await NotificationService().scheduleEventNotification(
          eventId: event.id,
          title: event.title,
          eventDate: event.dateTime,
          notifyAtEvent: notifyAtEvent,
          notify15Min: notify15Min,
          notify1Hour: notify1Hour,
          notify1Day: notify1Day,
        );
      } else {
        await NotificationService().cancelEventNotifications(event.id);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getScreenTitle()),
        actions: [
          if (widget.event != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                ref.read(eventsProvider.notifier).deleteEvent(widget.event!.id);
                await NotificationService().cancelEventNotifications(widget.event!.id);
                if (mounted) Navigator.pop(context);
              },
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: _getTitleLabel()),
                validator: (value) => value!.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              
              if (_type == EventType.task)
                CheckboxListTile(
                  title: const Text('Выполнено'),
                  value: _isCompleted,
                  onChanged: (val) => setState(() => _isCompleted = val ?? false),
                ),

              if (_type == EventType.event)
                SwitchListTile(
                  title: const Text('Весь день'),
                  value: _isAllDay,
                  onChanged: (val) => setState(() => _isAllDay = val),
                ),
                
              SwitchListTile(
                title: const Text('Уведомления'),
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
              ),
              
              //if (_type != EventType.holiday )
              if (true)
                SwitchListTile(
                  title: const Text('Таймер до события'),
                  value: _isTimer,
                  onChanged: (val) => setState(() => _isTimer = val),
                ),
                
              const SizedBox(height: 16),
              Text(
                _type == EventType.task ? 'Срок выполнения:' : 'Время:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text('${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}'),
                      onPressed: () => _pickDate(true),
                    ),
                  ),
                  if (!(_type == EventType.holiday || _isAllDay)) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: Text('${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}'),
                        onPressed: () => _pickTime(true),
                      ),
                    ),
                  ],
                ],
              ),
              
              if (_type == EventType.event && !_isAllDay) ...[
                const SizedBox(height: 16),
                const Text('Конец:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_endTime == null ? 'Указать дату' : '${_endTime!.day}.${_endTime!.month}.${_endTime!.year}'),
                        onPressed: () => _pickDate(false),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: Text(_endTime == null ? 'Указать время' : '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'),
                        onPressed: () => _pickTime(false),
                      ),
                    ),
                    if (_endTime != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _endTime = null),
                      ),
                  ],
                ),
              ],
              
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_getColorLabel()),
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
                onPressed: _saveEvent,
                child: const Text('Сохранить'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
