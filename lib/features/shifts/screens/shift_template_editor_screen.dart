import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/day_type.dart';
import '../models/shift_template.dart';
import '../providers/shift_provider.dart';

class ShiftTemplateEditorScreen extends ConsumerStatefulWidget {
  final ShiftTemplate? template;

  const ShiftTemplateEditorScreen({super.key, this.template});

  @override
  ConsumerState<ShiftTemplateEditorScreen> createState() => _ShiftTemplateEditorScreenState();
}

class _ShiftTemplateEditorScreenState extends ConsumerState<ShiftTemplateEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  //лист id дней шаблона
  List<int> _selectedDayIds = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.template?.name ?? '');
    if (widget.template != null) {
      _selectedDayIds = List.from(widget.template!.dayTypeIds);
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDayIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Добавьте хотя бы один день в шаблон!')),
        );
        return;
      }

      final newTemplate = ShiftTemplate()
        ..name = _nameController.text
        ..dayTypeIds = _selectedDayIds;

      if (widget.template != null) newTemplate.id = widget.template!.id;

      ref.read(shiftTemplatesProvider.notifier).save(newTemplate);
      Navigator.pop(context);
    }
  }

  //выбор дня для добавления в шаблон
  void _showAddDayDialog(List<DayType> availableDays) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: availableDays.length,
          itemBuilder: (context, index) {
            final day = availableDays[index];
            return ListTile(
              leading: Container(
                width: 24, height: 24,
                decoration: BoxDecoration(color: Color(day.backgroundColor), shape: BoxShape.circle),
              ),
              title: Text(day.name),
              onTap: () {
                setState(() => _selectedDayIds.add(day.id));
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //получить все типы дней
    final availableDays = ref.watch(dayTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.template == null ? 'Новый шаблон' : 'Редактировать'),
        actions: [
          if (widget.template != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(shiftTemplatesProvider.notifier).delete(widget.template!.id);
                Navigator.pop(context);
              },
            )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Название шаблона'),
                validator: (v) => v!.isEmpty ? 'Введите название' : null,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Последовательность дней:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),

          //drag and drop за счет заведения(ReorderableListView)
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _selectedDayIds.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _selectedDayIds.removeAt(oldIndex);
                  _selectedDayIds.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final id = _selectedDayIds[index];
                //тип дня по ид
                final day = availableDays.firstWhere(
                        (d) => d.id == id,
                    orElse: () => DayType()..name = 'Удаленный день'..backgroundColor = Colors.grey.value..textColor = Colors.white.value
                );

                return Card(
                  key: ValueKey('day_${index}_$id'),
                  color: Color(day.backgroundColor),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(day.name, style: TextStyle(color: Color(day.textColor), fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Color(day.textColor)),
                          onPressed: () => setState(() => _selectedDayIds.removeAt(index)),
                        ),
                        Icon(Icons.drag_handle, color: Color(day.textColor)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить день'),
                      onPressed: () => _showAddDayDialog(availableDays),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text('Сохранить'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}