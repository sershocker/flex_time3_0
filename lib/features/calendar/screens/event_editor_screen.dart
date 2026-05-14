import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/notification_service.dart';

class EventEditorScreen extends ConsumerStatefulWidget {
  final Event? event; //если null то будет новое

  const EventEditorScreen({super.key, this.event});

  @override
  ConsumerState<EventEditorScreen> createState() => _EventEditorScreenState();
}

class _EventEditorScreenState extends ConsumerState<EventEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _selectedDate;
  late Color _selectedColor;

  final List<Color> _availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    //контроллеры
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descController = TextEditingController(text: widget.event?.description ?? '');
    _selectedDate = widget.event?.dateTime ?? DateTime.now();
    _selectedColor = widget.event != null ? Color(widget.event!.color) : _availableColors[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  //выбор даты
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
      });
    }
  }

  //выбор времени
  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (pickedTime != null) {
      setState(() {
        //меняется только время
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final newEvent = Event()
        ..title = _titleController.text
        ..description = _descController.text
        ..dateTime = _selectedDate
        ..color = _selectedColor.value;

      if (widget.event != null) {

        newEvent.id = widget.event!.id;
      } else {
        newEvent.id = DateTime.now().millisecondsSinceEpoch % 100000000;
      }

      ref.read(eventsProvider.notifier).addEvent(newEvent);

      //уведомления
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;

      if (notificationsEnabled) {
        final notifyAtEvent = prefs.getBool('notify_at_event') ?? false;
        final notify15Min = prefs.getBool('notify_15_min') ?? true;
        final notify1Hour = prefs.getBool('notify_1_hour') ?? false;
        final notify1Day = prefs.getBool('notify_1_day') ?? false;

        await NotificationService().scheduleEventNotification(
          eventId: newEvent.id,
          title: newEvent.title,
          eventDate: newEvent.dateTime,
          notifyAtEvent: notifyAtEvent,
          notify15Min: notify15Min,
          notify1Hour: notify1Hour,
          notify1Day: notify1Day,
        );
      } else {
        await NotificationService().cancelEventNotifications(newEvent.id);
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
        title: Text(widget.event == null ? 'Новое событие' : 'Редактировать событие'),
        actions: [
          if (widget.event != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                //удалить событие из базы
                ref.read(eventsProvider.notifier).deleteEvent(widget.event!.id);

                //удалить все уведомления
                await NotificationService().cancelEventNotifications(widget.event!.id);

                if (mounted) {
                  Navigator.pop(context);
                }
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
                decoration: const InputDecoration(labelText: 'Название события'),
                validator: (value) => value!.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text('${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}'),
                      onPressed: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text('${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}'),
                      onPressed: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Цвет события:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _availableColors.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: _selectedColor == color
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
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