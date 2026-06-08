import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../models/activity.dart';
import '../models/activity_type.dart';
import '../providers/activity_provider.dart';
import '../providers/activity_stats_provider.dart';
import '../utils/icon_mapper.dart';
import 'activity_session_editor_screen.dart';

// периоды фильтрации
enum StatsPeriod { day, week, month }

class ActivityStatisticsScreen extends ConsumerStatefulWidget {
  const ActivityStatisticsScreen({super.key});

  @override
  ConsumerState<ActivityStatisticsScreen> createState() => _ActivityStatisticsScreenState();
}

class _ActivityStatisticsScreenState extends ConsumerState<ActivityStatisticsScreen> {
  StatsPeriod _selectedPeriod = StatsPeriod.day;
  bool _showUntracked = false;
  DateTime _focusedDate = DateTime.now();

  //формат времени в норм вид
  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;

    if (h > 0) return '${h}ч ${m}м';
    if (m > 0) return '${m}м ${s}с';
    return '${s}с';
  }

  void _movePeriod(int delta) {
    setState(() {
      switch (_selectedPeriod) {
        case StatsPeriod.day:
          _focusedDate = _focusedDate.add(Duration(days: delta));
          break;
        case StatsPeriod.week:
          _focusedDate = _focusedDate.add(Duration(days: delta * 7));
          break;
        case StatsPeriod.month:
          _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + delta, 1);
          break;
      }
    });
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case StatsPeriod.day:
        final now = DateTime.now();
        if (_focusedDate.year == now.year && _focusedDate.month == now.month && _focusedDate.day == now.day) {
          return 'Сегодня, ${DateFormat('d MMMM', 'ru').format(_focusedDate)}';
        }
        return DateFormat('d MMMM yyyy', 'ru').format(_focusedDate);
      case StatsPeriod.week:
        final start = _focusedDate.subtract(Duration(days: _focusedDate.weekday - 1));
        final end = start.add(const Duration(days: 6));
        if (start.month == end.month) {
          return '${DateFormat('d', 'ru').format(start)} - ${DateFormat('d MMMM yyyy', 'ru').format(end)}';
        }
        return '${DateFormat('d MMM', 'ru').format(start)} - ${DateFormat('d MMM yyyy', 'ru').format(end)}';
      case StatsPeriod.month:
        return DateFormat('MMMM yyyy', 'ru').format(_focusedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(activityHistoryProvider);
    final activityTypes = ref.watch(activityTypesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Статистика'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pie_chart), text: 'Диаграмма'),
              Tab(icon: Icon(Icons.list), text: 'История'),
            ],
          ),
        ),
        body: historyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Ошибка: $err')),
          data: (history) {
            return TabBarView(
              children: [
                _buildAnalyticsTab(history, activityTypes),
                _buildHistoryList(history, activityTypes),
              ],
            );
          },
        ),
      ),
    );
  }

  //вкладка с диаграммой
  Widget _buildAnalyticsTab(List<Activity> history, List<ActivityType> types) {
    DateTime periodStart;
    DateTime periodEnd;

    //определяем начало периода
    switch (_selectedPeriod) {
      case StatsPeriod.day:
        periodStart = DateTime(_focusedDate.year, _focusedDate.month, _focusedDate.day);
        periodEnd = periodStart.add(const Duration(days: 1));
        break;
      case StatsPeriod.week:
        int daysToSubtract = _focusedDate.weekday - 1;
        periodStart = DateTime(_focusedDate.year, _focusedDate.month, _focusedDate.day).subtract(Duration(days: daysToSubtract));
        periodEnd = periodStart.add(const Duration(days: 7));
        break;
      case StatsPeriod.month:
        periodStart = DateTime(_focusedDate.year, _focusedDate.month, 1);
        periodEnd = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
        break;
    }

    // Если период включает "сегодня", ограничиваем конец текущим моментом для расчета свободного времени
    final now = DateTime.now();
    DateTime effectiveEnd = periodEnd.isAfter(now) ? now : periodEnd;
    if (effectiveEnd.isBefore(periodStart)) effectiveEnd = periodStart;

    Duration totalPeriodDuration = effectiveEnd.difference(periodStart);

    //время для каждой активности в окне
    final Map<int, Duration> totals = {};
    Duration totalTracked = Duration.zero;

    for (var act in history) {
      if (act.endTime == null) continue;

      if (act.endTime!.isBefore(periodStart) || act.startTime.isAfter(periodEnd)) {
        continue;
      }

      //активности по границам периода
      DateTime start = act.startTime.isBefore(periodStart) ? periodStart : act.startTime;
      DateTime end = act.endTime!.isAfter(periodEnd) ? periodEnd : act.endTime!;
      Duration durationInPeriod = end.difference(start);

      totals[act.typeId] = (totals[act.typeId] ?? Duration.zero) + durationInPeriod;
      totalTracked += durationInPeriod;
    }

    //счет неотслеженного времени
    Duration untracked = totalPeriodDuration - totalTracked;
    if (untracked.isNegative) untracked = Duration.zero;

    //база для расчета процентов
    Duration baseForPercent = _showUntracked ? totalPeriodDuration : totalTracked;

    return Column(
      children: [
        //панель фильтров
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SegmentedButton<StatsPeriod>(
                segments: const [
                  ButtonSegment(value: StatsPeriod.day, label: Text('День')),
                  ButtonSegment(value: StatsPeriod.week, label: Text('Неделя')),
                  ButtonSegment(value: StatsPeriod.month, label: Text('Месяц')),
                ],
                selected: {_selectedPeriod},
                onSelectionChanged: (Set<StatsPeriod> newSelection) {
                  setState(() {
                    _selectedPeriod = newSelection.first;
                    _focusedDate = DateTime.now(); // сброс даты при смене масштаба
                  });
                },
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _movePeriod(-1),
                    tooltip: 'Назад',
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _focusedDate = DateTime.now()),
                      child: Center(
                        child: Text(
                          _getPeriodLabel(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => _movePeriod(1),
                    tooltip: 'Вперед',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Учитывать свободное время', style: TextStyle(fontSize: 14)),
                value: _showUntracked,
                onChanged: (val) => setState(() => _showUntracked = val),
              ),
            ],
          ),
        ),

        const Divider(height: 1),


        Expanded(
          child: totals.isEmpty && (!_showUntracked || untracked.inMinutes == 0)
              ? const Center(child: Text('Нет данных за этот период'))
              : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              //круговая диаграмма
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    sections: _buildChartSections(totals, types, untracked, baseForPercent),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text('Детализация времени', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              //детализация
              ..._buildLegendItems(totals, types, untracked, baseForPercent),
            ],
          ),
        ),
      ],
    );
  }

  //генерация графика
  List<PieChartSectionData> _buildChartSections(Map<int, Duration> totals, List<ActivityType> types, Duration untracked, Duration baseDuration) {
    List<PieChartSectionData> sections = [];

    if (baseDuration.inSeconds == 0) return sections;

    // псевдо активности графика
    totals.forEach((typeId, duration) {
      final type = types.firstWhere(
        (t) => t.id == typeId, 
        orElse: () => ActivityType()..name = '?'..iconCode = ''..color = 0xFF9E9E9E
      );
      final double percent = (duration.inSeconds / baseDuration.inSeconds) * 100;

      if (percent > 0) {
        sections.add(
          PieChartSectionData(
            color: Color(type.color),
            value: percent,
            title: percent > 4 ? '${percent.toStringAsFixed(1)}%' : '',
            radius: 70,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }
    });

    //неотслеженное время (если включено)
    if (_showUntracked && untracked.inSeconds > 0) {
      final double percent = (untracked.inSeconds / baseDuration.inSeconds) * 100;
      sections.add(
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: percent,
          title: percent > 4 ? '${percent.toStringAsFixed(1)}%' : '',
          radius: 60,
          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
      );
    }

    return sections;
  }

  //детализация активностей
  List<Widget> _buildLegendItems(Map<int, Duration> totals, List<ActivityType> types, Duration untracked, Duration baseDuration) {
    List<Widget> items = [];

    if (baseDuration.inSeconds == 0) return items;

    var sortedEntries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (var entry in sortedEntries) {
      final type = types.firstWhere(
        (t) => t.id == entry.key, 
        orElse: () => ActivityType()..name = '?'..iconCode = ''..color = 0xFF9E9E9E
      );
      final double percent = (entry.value.inSeconds / baseDuration.inSeconds) * 100;

      items.add(ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: Color(type.color).withOpacity(0.2),
          child: Icon(getIconData(type.iconCode), color: Color(type.color)),
        ),
        title: Text(type.name),
        subtitle: Text(_formatDuration(entry.value)),
        trailing: Text('${percent.toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ));
    }

    //неотслеженное время
    if (_showUntracked && untracked.inSeconds > 0) {
      final double percent = (untracked.inSeconds / baseDuration.inSeconds) * 100;
      items.add(ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Icon(Icons.help_outline, color: Colors.grey.shade600),
        ),
        title: Text('Свободное время', style: TextStyle(color: Colors.grey.shade700)),
        subtitle: Text(_formatDuration(untracked)),
        trailing: Text('${percent.toStringAsFixed(1)}%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade700)),
      ));
    }

    return items;
  }

  // вкладка 2 вся история
  Widget _buildHistoryList(List<Activity> history, List<ActivityType> types) {
    if (history.isEmpty) return const Center(child: Text('История пуста'));

    // Сортировка по убыванию времени
    final sortedHistory = List<Activity>.from(history)..sort((a, b) => b.startTime.compareTo(a.startTime));

    return ListView.builder(
      itemCount: sortedHistory.length,
      itemBuilder: (context, index) {
        final act = sortedHistory[index];
        final type = types.firstWhere((t) => t.id == act.typeId, orElse: () => types.first);

        final duration = act.endTime != null ? act.endTime!.difference(act.startTime) : Duration.zero;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(type.color).withOpacity(0.2),
            child: Icon(getIconData(type.iconCode), color: Color(type.color)),
          ),
          title: Text(type.name),
          subtitle: Text(DateFormat('dd.MM.yyyy  HH:mm', 'ru').format(act.startTime)),
          trailing: Text(_formatDuration(duration), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ActivitySessionEditorScreen(session: act)),
            );
          },
        );
      },
    );
  }
}
