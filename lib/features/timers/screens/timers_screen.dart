import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_provider.dart';
import '../widgets/timer_card.dart';
import 'timer_editor_screen.dart';

class TimersScreen extends ConsumerWidget {
  const TimersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timers = ref.watch(timersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Таймеры'),
      ),
      body: timers.isEmpty
          ? const Center(child: Text('Нет активных таймеров'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: timers.length,
        itemBuilder: (context, index) {
          final timer = timers[index];
          return TimerCard(
            timerEntity: timer,
            onTap: () {
              //открыть редактор
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimerEditorScreen(timer: timer),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //создание нового таймера
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimerEditorScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}