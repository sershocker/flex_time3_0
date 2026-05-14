import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../providers/event_provider.dart';
import '../providers/combined_calendar_provider.dart';
import '../models/unified_data_source.dart';
import '../../shifts/providers/shift_provider.dart';
import 'event_editor_screen.dart';
import 'day_details_screen.dart';
import '../../../core/providers/theme_provider.dart';
import '../models/event.dart';

enum CustomCalendarView { month, year }

final calendarViewProvider = StateProvider<CustomCalendarView>((ref) => CustomCalendarView.month);
final currentYearProvider = StateProvider<int>((ref) => DateTime.now().year);

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final CalendarController _calendarController = CalendarController();

  bool _isEventsExpanded = true;

  @override
  void initState() {
    super.initState();
    _calendarController.view = CalendarView.month;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointments = ref.watch(combinedCalendarProvider);
    final schedules = ref.watch(shiftSchedulesProvider);
    final selectedScheduleId = ref.watch(selectedScheduleIdProvider);
    final isMondayFirst = ref.watch(firstDayProvider);

    final currentView = ref.watch(calendarViewProvider);
    final isYearView = currentView == CustomCalendarView.year;

    final allEvents = ref.watch(eventsProvider);
    final upcomingEvents = allEvents
        .where((e) => e.dateTime.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    ref.listen<CustomCalendarView>(calendarViewProvider, (previous, next) {
      if (next == CustomCalendarView.month) {
        _calendarController.view = CalendarView.month;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Сегодня',
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              final now = DateTime.now();
              if (isYearView) {
                ref.read(currentYearProvider.notifier).state = now.year;
              } else {
                _calendarController.displayDate = now;
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: SegmentedButton<CustomCalendarView>(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              segments: const [
                ButtonSegment(value: CustomCalendarView.month, label: Text('Месяц')),
                ButtonSegment(value: CustomCalendarView.year, label: Text('Год')),
              ],
              selected: {currentView},
              onSelectionChanged: (Set<CustomCalendarView> newSelection) {
                ref.read(calendarViewProvider.notifier).state = newSelection.first;
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (schedules.isNotEmpty && !isYearView)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              child: Row(
                children: [
                  Icon(Icons.work_history, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        isExpanded: true,
                        value: selectedScheduleId,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 16),
                        items: [
                          const DropdownMenuItem(
                              value: null,
                              child: Text('Без смен', style: TextStyle(fontWeight: FontWeight.bold))
                          ),
                          ...schedules.map((s) => DropdownMenuItem(
                              value: s.id,
                              child: Text('График: ${s.title}')
                          )),
                        ],
                        onChanged: (val) {
                          ref.read(selectedScheduleIdProvider.notifier).state = val;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: isYearView
                ? _buildYearView(context, ref, ref.watch(currentYearProvider), isMondayFirst)
                : Column(
              children: [
                Expanded(
                  //flexный календарь
                  flex: _isEventsExpanded ? 5 : 1,
                  child: _buildSfCalendar(context, ref, appointments, isMondayFirst),
                ),
                const Divider(height: 1),

                _buildEventsHeader(),
                //если развернут
                if (_isEventsExpanded)
                  Expanded(
                    flex: 2,
                    child: _buildUpcomingEventsList(upcomingEvents),
                  ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isYearView || !_isEventsExpanded ? null : FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EventEditorScreen()));
        },
        icon: const Icon(Icons.add),
        label: const Text('Добавить', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }


  // список ближайших событий
  Widget _buildEventsHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 4.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ближайшие события',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary
            ),
          ),
          IconButton(
            icon: Icon(_isEventsExpanded ? Icons.expand_more : Icons.expand_less),
            onPressed: () {
              setState(() {
                _isEventsExpanded = !_isEventsExpanded;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsList(List<Event> upcomingEvents) {
    if (upcomingEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 48, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 8),
            const Text('Нет предстоящих событий', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: upcomingEvents.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final event = upcomingEvents[index];
        final dateStr = '${event.dateTime.day.toString().padLeft(2, '0')}.${event.dateTime.month.toString().padLeft(2, '0')}.${event.dateTime.year}';
        final timeStr = '${event.dateTime.hour.toString().padLeft(2, '0')}:${event.dateTime.minute.toString().padLeft(2, '0')}';

        return ListTile(
          leading: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Color(event.color),
              shape: BoxShape.circle,
            ),
          ),
          title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('$dateStr в $timeStr'),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventEditorScreen(event: event)),
            );
          },
        );
      },
    );
  }

  //вид календаря год
  Widget _buildYearView(BuildContext context, WidgetRef ref, int year, bool isMondayFirst) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: () => ref.read(currentYearProvider.notifier).state--,
              ),
              const SizedBox(width: 16),
              Text(
                  year.toString(),
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 32),
                onPressed: () => ref.read(currentYearProvider.notifier).state++,
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8).copyWith(bottom: 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return _buildMiniMonth(context, ref, year, index + 1, isMondayFirst);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMiniMonth(BuildContext context, WidgetRef ref, int year, int month, bool isMondayFirst) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstDayWeekday = DateTime(year, month, 1).weekday;

    int offset;
    if (isMondayFirst) {
      offset = firstDayWeekday - 1;
    } else {
      offset = firstDayWeekday == 7 ? 0 : firstDayWeekday;
    }

    const monthNames = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'];
    final isCurrentMonth = DateTime.now().year == year && DateTime.now().month == month;

    return GestureDetector(
      onTap: () {
        _calendarController.displayDate = DateTime(year, month, 1);
        ref.read(calendarViewProvider.notifier).state = CustomCalendarView.month;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: isCurrentMonth ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Text(
                monthNames[month - 1],
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCurrentMonth ? Theme.of(context).colorScheme.primary : null
                )
            ),
            const SizedBox(height: 4),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                itemCount: 42,
                itemBuilder: (context, index) {
                  if (index < offset || index >= offset + daysInMonth) {
                    return const SizedBox();
                  }

                  final day = index - offset + 1;
                  final isToday = DateTime.now().year == year && DateTime.now().month == month && DateTime.now().day == day;

                  return Container(
                    decoration: BoxDecoration(
                      color: isToday ? Theme.of(context).colorScheme.primary : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                        day.toString(),
                        style: TextStyle(
                          fontSize: 9,
                          color: isToday ? Theme.of(context).colorScheme.onPrimary : null,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        )
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  //SfCalendarь

  Widget _buildSfCalendar(BuildContext context, WidgetRef ref, List<Appointment> appointments, bool isMondayFirst) {
    return SfCalendar(
      controller: _calendarController,
      dataSource: UnifiedDataSource(appointments),
      firstDayOfWeek: isMondayFirst ? 1 : 7,
      showNavigationArrow: true,
      headerDateFormat: 'MMMM yyyy',
      headerStyle: CalendarHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      monthViewSettings: const MonthViewSettings(
        showAgenda: false,
        appointmentDisplayMode: MonthAppointmentDisplayMode.none,
      ),
      monthCellBuilder: (BuildContext context, MonthCellDetails details) {
        return _buildCustomMonthCell(context, details);
      },
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell) {
          final selectedDate = details.date;
          if (selectedDate != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DayDetailsScreen(date: selectedDate),
              ),
            );
          }
        }
      },
    );
  }


  //ячейка календаря

  Widget _buildCustomMonthCell(BuildContext context, MonthCellDetails details) {
    final isToday = details.date.year == DateTime.now().year &&
        details.date.month == DateTime.now().month &&
        details.date.day == DateTime.now().day;

    final isCurrentMonth = details.date.month == details.visibleDates[details.visibleDates.length ~/ 2].month;
    final isWeekend = details.date.weekday == DateTime.saturday || details.date.weekday == DateTime.sunday;

    final shiftApp = details.appointments.cast<Appointment>().where(
            (a) {
          if (!a.id.toString().startsWith('shift_')) return false;
          return a.startTime.year == details.date.year &&
              a.startTime.month == details.date.month &&
              a.startTime.day == details.date.day;
        }
    ).firstOrNull;

    final events = details.appointments.cast<Appointment>().where(
            (a) => a.id.toString().startsWith('event_')
    ).toList();

    final isTransparentShift = shiftApp != null && shiftApp.color.value == Colors.transparent.value;

    Color cellBackgroundColor = Colors.grey.withOpacity(0.05);
    if (isToday) {

      //фон сегодняшего дня
      cellBackgroundColor = Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6);
    } else if (isCurrentMonth) {
      cellBackgroundColor = isWeekend ? Colors.red.withOpacity(0.1) : Colors.transparent;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
        color: cellBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 4),

          if (shiftApp != null)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: shiftApp.color,
                shape: BoxShape.circle,
                border: isToday
                    ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
                    : (isTransparentShift ? Border.all(color: Colors.grey.withOpacity(0.3), width: 1) : null),
              ),
              alignment: Alignment.center,
              child: Text(
                details.date.day.toString(),
                style: TextStyle(
                    color: isTransparentShift
                        ? (isToday ? Theme.of(context).colorScheme.primary : (isCurrentMonth ? Theme.of(context).textTheme.bodyLarge?.color : Colors.grey))
                        : Colors.white,
                    fontWeight: (isToday || !isTransparentShift) ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16
                ),
              ),
            )
          else
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday ? Theme.of(context).colorScheme.primary : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: Text(
                details.date.day.toString(),
                style: TextStyle(
                    color: isToday
                        ? Colors.white
                        : (isCurrentMonth ? Theme.of(context).textTheme.bodyLarge?.color : Colors.grey),
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16
                ),
              ),
            ),

          const SizedBox(height: 2),

          if ((shiftApp == null || isTransparentShift) && events.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: events.take(4).map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: e.color,
                    shape: BoxShape.circle,
                  ),
                ),
              )).toList(),
            )
        ],
      ),
    );
  }
}