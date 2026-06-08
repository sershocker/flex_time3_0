import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../utils/icon_mapper.dart';
import '../providers/activity_stats_provider.dart';

class ActivityTypeEditorScreen extends ConsumerStatefulWidget {
  final ActivityType? type;

  const ActivityTypeEditorScreen({super.key, this.type});

  @override
  ConsumerState<ActivityTypeEditorScreen> createState() => _ActivityTypeEditorScreenState();
}

class _ActivityTypeEditorScreenState extends ConsumerState<ActivityTypeEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedIconCode;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.type?.name ?? '');
    _selectedIconCode = widget.type?.iconCode ?? availableIconCodes[0];
    _selectedColor = widget.type != null ? Color(widget.type!.color) : Colors.blue;
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final newType = ActivityType()
        ..name = _nameController.text
        ..iconCode = _selectedIconCode
        ..color = _selectedColor.value;

      if (widget.type != null) newType.id = widget.type!.id;

      await ref.read(activityTypesProvider.notifier).saveType(newType);

      if (mounted) Navigator.pop(context);
    }
  }

  void _delete() async {
    await ref.read(activityTypesProvider.notifier).deleteType(widget.type!.id);
    ref.invalidate(activityHistoryProvider);
    if (mounted) Navigator.pop(context);
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _selectedColor;
        return AlertDialog(
          title: const Text('Выберите цвет'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == null ? 'Новая активность' : 'Редактировать'),
        actions: [
          if (widget.type != null)
            IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
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
                  //поле ввода названия
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Название активности'),
                    validator: (v) => v!.isEmpty ? 'Введите название' : null,

                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 24),

                  //выбор цвета
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Цвет'),
                    trailing: CircleAvatar(backgroundColor: _selectedColor),
                    onTap: _openColorPicker,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: _selectedColor.withOpacity(0.2),
                        border: Border.all(color: _selectedColor, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(getIconData(_selectedIconCode), color: _selectedColor, size: 36),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              _nameController.text.trim().isEmpty ? 'Название' : _nameController.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text('Иконка', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: availableIconCodes.length,
                    itemBuilder: (context, index) {
                      final code = availableIconCodes[index];
                      final isSelected = _selectedIconCode == code;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIconCode = code),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected ? _selectedColor : Colors.grey.shade200,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [BoxShadow(color: _selectedColor.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)]
                                : [],
                          ),
                          child: Icon(
                            getIconData(code),
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
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