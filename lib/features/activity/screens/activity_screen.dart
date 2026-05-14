import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../providers/activity_stats_provider.dart';
import '../utils/icon_mapper.dart';
import 'activity_statistics_screen.dart';
import 'activity_type_editor_screen.dart';


class ActiveSession {
  final ActivityType type;
  final DateTime startTime;
  final StopWatchTimer timer;
  bool isPaused;

  ActiveSession({
    required this.type,
    required this.startTime,
    required this.timer,
    this.isPaused = false,
  });
}

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  //список запущенных активностей
  final List<ActiveSession> _activeSessions = [];

  @override
  void dispose() {
    //очистка таймеров
    for (var session in _activeSessions) {
      session.timer.dispose();
    }
    super.dispose();
  }

  void _startActivity(ActivityType type) {
    //провека на запуск
    if (_activeSessions.any((s) => s.type.id == type.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Активность "${type.name}" уже запущена!')),
      );
      return;
    }

    //новый таймер для этой активности
    final newTimer = StopWatchTimer(mode: StopWatchMode.countUp);
    newTimer.onStartTimer();

    setState(() {
      _activeSessions.add(
        ActiveSession(
          type: type,
          startTime: DateTime.now(),
          timer: newTimer,
        ),
      );
    });
  }

  void _togglePause(ActiveSession session) {
    setState(() {
      session.isPaused = !session.isPaused;
      if (session.isPaused) {
        session.timer.onStopTimer();
      } else {
        session.timer.onStartTimer();
      }
    });
  }

  void _stopAndSaveActivity(ActiveSession session) async {
    //сохраняем в базу
    final activityData = Activity()
      ..typeId = session.type.id
      ..startTime = session.startTime
      ..endTime = DateTime.now();

    await ref.read(activityRepositoryProvider).saveActivitySession(activityData);
    ref.invalidate(activityHistoryProvider);

    //стоп и удалить из активных
    session.timer.dispose();
    setState(() {
      _activeSessions.remove(session);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Активность сохранена!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityTypes = ref.watch(activityTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Трекер'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivityTypeEditorScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActivityStatisticsScreen()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          //список запущенных активностей
          if (_activeSessions.isNotEmpty)
            ConstrainedBox(
              // ограничиваем высоту
              constraints: const BoxConstraints(maxHeight: 250),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _activeSessions.length,
                itemBuilder: (context, index) {
                  final session = _activeSessions[index];
                  final color = Color(session.type.color);

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.4), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Icon(getIconData(session.type.iconCode), color: color, size: 28),
                        const SizedBox(width: 16),

                        //название и время
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  session.type.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                              ),
                              StreamBuilder<int>(
                                stream: session.timer.rawTime,
                                initialData: session.timer.rawTime.value,
                                builder: (context, snap) {
                                  final value = snap.data!;
                                  final displayTime = StopWatchTimer.getDisplayTime(value, hours: true, milliSecond: false);
                                  return Text(
                                      displayTime,
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 14,
                                        color: session.isPaused ? Colors.grey : Theme.of(context).textTheme.bodyLarge?.color,
                                      )
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        // кнопки управления
                        IconButton(
                          icon: Icon(session.isPaused ? Icons.play_arrow : Icons.pause),
                          color: session.isPaused ? Colors.green : Colors.grey.shade700,
                          onPressed: () => _togglePause(session),
                        ),
                        IconButton(
                          icon: const Icon(Icons.stop),
                          color: Colors.red,
                          onPressed: () => _stopAndSaveActivity(session),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          //сетка доступных активностей
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: activityTypes.length,
              itemBuilder: (context, index) {
                final type = activityTypes[index];
                //проверяем, запущена ли именно эта активность
                final isRunning = _activeSessions.any((s) => s.type.id == type.id);

                return InkWell(
                  onTap: () {
                    if (!isRunning) {
                      _startActivity(type);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Эта активность уже запущена (см. выше)')),
                      );
                    }
                  },
                  onLongPress: () {
                    if (isRunning) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Остановите активность перед редактированием')),
                      );
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ActivityTypeEditorScreen(type: type))
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isRunning ? Color(type.color).withOpacity(0.2) : Theme.of(context).cardColor,
                      border: Border.all(
                        color: isRunning ? Color(type.color) : Colors.grey.withOpacity(0.3),
                        width: isRunning ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(getIconData(type.iconCode), color: Color(type.color), size: 32),
                        SizedBox(height: 8),
                        Text(type.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}