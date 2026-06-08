import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/day_type.dart';
import '../providers/shift_provider.dart';

class DayTypeEditorScreen extends ConsumerStatefulWidget {
  final DayType? dayType;

  const DayTypeEditorScreen({super.key, this.dayType});

  @override
  ConsumerState<DayTypeEditorScreen> createState() => _DayTypeEditorScreenState();
}

class _DayTypeEditorScreenState extends ConsumerState<DayTypeEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late Color _bgColor;
  late Color _textColor;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dayType?.name ?? '');
    _bgColor = widget.dayType != null ? Color(widget.dayType!.backgroundColor) : Colors.blue;
    _textColor = widget.dayType != null ? Color(widget.dayType!.textColor) : Colors.white;

    if (widget.dayType != null) {
      if (widget.dayType!.startHour != null && widget.dayType!.startMinute != null) {
        _startTime = TimeOfDay(hour: widget.dayType!.startHour!, minute: widget.dayType!.startMinute!);
      }
      if (widget.dayType!.endHour != null && widget.dayType!.endMinute != null) {
        _endTime = TimeOfDay(hour: widget.dayType!.endHour!, minute: widget.dayType!.endMinute!);
      }
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newType = DayType()
        ..name = _nameController.text
        ..backgroundColor = _bgColor.value
        ..textColor = _textColor.value
        ..startHour = _startTime?.hour
        ..startMinute = _startTime?.minute
        ..endHour = _endTime?.hour
        ..endMinute = _endTime?.minute;

      if (widget.dayType != null) newType.id = widget.dayType!.id;

      ref.read(dayTypesProvider.notifier).save(newType);
      Navigator.pop(context);
    }
  }

  void _openColorPicker({required bool isBackground}) {
    Color tempColor = isBackground ? _bgColor : _textColor;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(isBackground ? 'Цвет фона' : 'Цвет текста'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //кнопка прозрачня
                      if (isBackground) ...[
                        InkWell(
                          onTap: () {
                            setDialogState(() {
                              tempColor = Colors.transparent;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: tempColor == Colors.transparent
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade300,
                                width: tempColor == Colors.transparent ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.format_color_reset, color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Прозрачный (обычный день)', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                      ],

                      //палитра по умолчанию
                      BlockPicker(
                        pickerColor: tempColor == Colors.transparent ? Colors.blue : tempColor,
                        onColorChanged: (c) {
                          setDialogState(() {
                            tempColor = c;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Отмена'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text('Выбрать'),
                    onPressed: () {
                      setState(() {
                        if (isBackground) {
                          _bgColor = tempColor;
                        } else {
                          _textColor = tempColor;
                        }
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dayType == null ? 'Новый тип дня' : 'Редактировать'),
        actions: [
          if (widget.dayType != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(dayTypesProvider.notifier).delete(widget.dayType!.id);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Название'),
                    validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 24),

                  //ввод времени
                  const Text('Время смены (оставьте пустым для выходного):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Начало'),
                    subtitle: Text(_startTime != null ? _startTime!.format(context) : 'Не задано'),
                    trailing: _startTime != null
                        ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _startTime = null))
                        : const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                          context: context,
                          initialTime: _startTime ?? const TimeOfDay(hour: 8, minute: 0)
                      );
                      if (picked != null) setState(() => _startTime = picked);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Окончание'),
                    subtitle: Text(_endTime != null ? _endTime!.format(context) : 'Не задано'),
                    trailing: _endTime != null
                        ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _endTime = null))
                        : const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                          context: context,
                          initialTime: _endTime ?? const TimeOfDay(hour: 20, minute: 0)
                      );
                      if (picked != null) setState(() => _endTime = picked);
                    },
                  ),
                  //готовый круг
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _bgColor,
                        shape: BoxShape.circle,
                        border: _bgColor == Colors.transparent
                            ? Border.all(color: Colors.grey, style: BorderStyle.solid)                            : Border.all(color: Colors.transparent),
                      ),
                      child: Text(
                        _nameController.text.isEmpty ? 'Текст' : _nameController.text,
                        style: TextStyle(
                          //если прозрачный
                            color: _bgColor == Colors.transparent ? Theme.of(context).textTheme.bodyLarge?.color : _textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  ListTile(
                    title: const Text('Цвет фона'),
                    trailing: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: _bgColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _bgColor == Colors.transparent
                          ? const Icon(Icons.format_color_reset, color: Colors.grey, size: 20)
                          : null,
                    ),
                    onTap: () => _openColorPicker(isBackground: true),
                  ),
                  ListTile(
                    title: const Text('Цвет текста'),
                    trailing: CircleAvatar(
                        backgroundColor: _textColor,
                        child: Icon(Icons.text_fields, color: _bgColor == Colors.transparent ? Colors.grey : _bgColor, size: 16)
                    ),
                    onTap: () => _openColorPicker(isBackground: false),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Сохранить', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}