import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../calendar/providers/event_provider.dart';
import '../widgets/timer_card.dart';
import 'timer_editor_screen.dart';

class TimersScreen extends ConsumerWidget {
  const TimersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEvents = ref.watch(eventsProvider);
    final timers = allEvents.where((e) => e.isTimer).toList();

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
          final event = timers[index];
          return TimerCard(
            event: event,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimerEditorScreen(timer: event),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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