import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math' as math;

import '../providers/event_provider.dart';
import '../models/event.dart';
import '../models/month_backgrounds.dart';
import 'event_editor_screen.dart';

import '../../shifts/providers/shift_provider.dart';
import '../providers/combined_calendar_provider.dart';
import '../../shifts/screens/shift_schedule_editor_screen.dart';

class DayDetailsScreen extends ConsumerStatefulWidget {
  final DateTime date;

  const DayDetailsScreen({super.key, required this.date});

  @override
  ConsumerState<DayDetailsScreen> createState() => _DayDetailsScreenState();
}

class SunData {
  final String sunriseString;
  final String sunsetString;
  final double sunriseDecimal;
  final double sunsetDecimal;

  SunData(this.sunriseString, this.sunsetString, this.sunriseDecimal, this.sunsetDecimal);
}

class _DayDetailsScreenState extends ConsumerState<DayDetailsScreen> {
  late DateTime _currentDate;

  //id графика на ленте времени
  int? _visibleTimelineScheduleId;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.date;
  }

  void _nextDay() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 1));
    });
  }

  void _prevDay() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 1));
    });
  }

  bool _isToday() {
    final now = DateTime.now();
    return _currentDate.year == now.year &&
        _currentDate.month == now.month &&
        _currentDate.day == now.day;
  }

  SunData _calculateSunData(DateTime date) {
    int dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    double angle = (dayOfYear + 10) / 365 * 2 * math.pi;

    double sunriseDecimal = 6.5 + 2.0 * math.cos(angle);
    double sunsetDecimal = 18.5 - 2.5 * math.cos(angle);

    String formatTime(double decimalTime) {
      int hour = decimalTime.floor();
      int minute = ((decimalTime - hour) * 60).round();
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    return SunData(
      formatTime(sunriseDecimal),
      formatTime(sunsetDecimal),
      sunriseDecimal,
      sunsetDecimal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;

    final isWeekend = _currentDate.weekday == DateTime.saturday || _currentDate.weekday == DateTime.sunday;
    final dateColor = isWeekend ? Colors.redAccent : onSurface;

    final sunData = _calculateSunData(_currentDate);

    const weekDays = ['понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота', 'воскресенье'];
    const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];

    // границы текущего дня
    final startOfDay = DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final allEvents = ref.watch(eventsProvider);
    
    // Фильтрация событий: берем те, что пересекаются с текущим днем
    final dayEvents = allEvents.where((e) {
      final eventStart = e.dateTime;
      final eventEnd = e.isAllDay 
          ? DateTime(eventStart.year, eventStart.month, eventStart.day).add(const Duration(days: 1))
          : (e.endTime ?? eventStart.add(const Duration(minutes: 1)));
      
      return eventStart.isBefore(endOfDay) && eventEnd.isAfter(startOfDay);
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final schedules = ref.watch(shiftSchedulesProvider);
    final selectedScheduleId = ref.watch(selectedScheduleIdProvider);
    final appointments = ref.watch(allAppointmentsProvider);

    final dayShifts = appointments.cast<Appointment>().where((a) {
      return a.id.toString().startsWith('shift_') &&
          a.startTime.isBefore(endOfDay) &&
          a.endTime.isAfter(startOfDay);
    }).toList();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(monthBackgrounds[_currentDate.month]!),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            colorScheme.surface.withOpacity(0.55),
            BlendMode.srcOver,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: onSurface),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.arrow_back_ios, size: 28, color: onSurface), onPressed: _prevDay),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(weekDays[_currentDate.weekday - 1], style: TextStyle(fontSize: 22, color: dateColor, fontWeight: FontWeight.w500)),
                        Text(_currentDate.day.toString(), style: TextStyle(fontSize: 96, fontWeight: FontWeight.bold, color: dateColor, height: 1.0)),
                        Text('${months[_currentDate.month - 1]} ${_currentDate.year}', style: TextStyle(fontSize: 22, color: onSurfaceVariant)),
                      ],
                    ),
                  ),
                  IconButton(icon: Icon(Icons.arrow_forward_ios, size: 28, color: onSurface), onPressed: _nextDay),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.6),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    //лента времени
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double width = constraints.maxWidth;

                          double getX(DateTime time) {
                            if (time.isBefore(startOfDay)) return 0.0;
                            if (time.isAfter(endOfDay) || time.isAtSameMomentAs(endOfDay)) return width;
                            return ((time.hour + time.minute / 60) / 24) * width;
                          }

                          final double sunriseX = (sunData.sunriseDecimal / 24) * width;
                          final double sunsetX = (sunData.sunsetDecimal / 24) * width;
                          const double lineY = 80.0;

                          return SizedBox(
                            height: 120,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned.fill(
                                  child: CustomPaint(painter: SunArcPainter(startX: sunriseX, endX: sunsetX, lineY: lineY)),
                                ),
                                Positioned(
                                  top: lineY, left: 0, right: 0,
                                  child: Container(height: 2, color: onSurface.withOpacity(0.3)),
                                ),

                                //полосы смены графика
                                if (_visibleTimelineScheduleId != null)
                                  ...dayShifts
                                      .where((a) => a.id.toString().contains('_${_visibleTimelineScheduleId}_') && !a.isAllDay)
                                      .map((shift) {
                                    final startX = getX(shift.startTime);
                                    final endX = getX(shift.endTime);

                                    return Positioned(
                                      top: lineY + 14,
                                      left: startX,
                                      child: Container(
                                        width: (endX - startX).clamp(4.0, width),
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Color(schedules.firstWhere((s) => s.id == _visibleTimelineScheduleId).color).withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    );
                                  }),

                                for (int i = 0; i <= 24; i += 4)
                                  Positioned(
                                    top: lineY + 6,
                                    left: (i / 24 * width) - (i == 24 ? 12 : (i == 0 ? 0 : 8)),
                                    child: Text('$i:00', style: TextStyle(fontSize: 10, color: onSurfaceVariant)),
                                  ),
                                Positioned(
                                  top: lineY - 12, left: sunriseX - 12,
                                  child: const Icon(Icons.wb_twilight, color: Colors.orangeAccent, size: 24),
                                ),
                                Positioned(
                                  top: lineY - 12, left: sunsetX - 12,
                                  child: const Icon(Icons.nights_stay, color: Colors.indigoAccent, size: 24),
                                ),
                                
                                // Отрисовка событий на ленте
                                for (var event in dayEvents.where((e) => !e.isAllDay))
                                  if (event.endTime != null)
                                    Positioned(
                                      top: lineY - 3,
                                      left: getX(event.dateTime),
                                      child: Tooltip(
                                        message: event.title,
                                        child: Container(
                                          width: (getX(event.endTime!) - getX(event.dateTime)).clamp(4.0, width),
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Color(event.color),
                                            borderRadius: BorderRadius.circular(3),
                                            boxShadow: [BoxShadow(color: Color(event.color).withOpacity(0.5), blurRadius: 4)],
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Positioned(
                                      top: lineY - 6, left: getX(event.dateTime) - 6,
                                      child: Tooltip(
                                        message: event.title,
                                        child: Container(
                                          width: 12, height: 12,
                                          decoration: BoxDecoration(
                                            color: Color(event.color),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: colorScheme.surface, width: 2),
                                            boxShadow: [BoxShadow(color: Color(event.color).withOpacity(0.8), blurRadius: 4)],
                                          ),
                                        ),
                                      ),
                                    ),
                                if (_isToday())
                                  Positioned(
                                    top: lineY - 30, bottom: 20, left: getX(DateTime.now()) - 1,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                                          child: Text(
                                            '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(child: Container(width: 2, color: Colors.red)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    //восход и закат
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.wb_twilight, color: Colors.orangeAccent, size: 16),
                              const SizedBox(width: 6),
                              Text('Восход: ${sunData.sunriseString}', style: TextStyle(color: onSurfaceVariant, fontSize: 12)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.nights_stay, color: Colors.indigoAccent, size: 16),
                              const SizedBox(width: 6),
                              Text('Закат: ${sunData.sunsetString}', style: TextStyle(color: onSurfaceVariant, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Divider(color: onSurface.withOpacity(0.1), height: 1, indent: 16, endIndent: 16),

                    // низ список
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(top: 8, bottom: 80),
                        children: [
                          if (schedules.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ГРАФИКИ СМЕН', style: TextStyle(color: onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                  const SizedBox(height: 12),
                                  ...schedules.map((s) {
                                    final sShifts = dayShifts.where((a) => a.id.toString().contains('_${s.id}_')).toList();
                                    final hasTimedShift = sShifts.any((a) => !a.isAllDay);
                                    final primaryShift = sShifts.where((a) => a.startTime.year == _currentDate.year && a.startTime.day == _currentDate.day).firstOrNull ?? sShifts.firstOrNull;
                                    final isTransparent = primaryShift != null && primaryShift.color.value == Colors.transparent.value;

                                    String shiftName = 'Выходной';
                                    Color shiftColor = onSurfaceVariant;
                                    String shiftTime = '';

                                    if (primaryShift != null) {
                                      if (!isTransparent) {
                                        shiftName = primaryShift.subject;
                                        shiftColor = primaryShift.color;
                                        if (!primaryShift.isAllDay) {
                                          final start = '${primaryShift.startTime.hour.toString().padLeft(2, '0')}:${primaryShift.startTime.minute.toString().padLeft(2, '0')}';
                                          final end = '${primaryShift.endTime.hour.toString().padLeft(2, '0')}:${primaryShift.endTime.minute.toString().padLeft(2, '0')}';
                                          shiftTime = '$start - $end';
                                        }
                                      }
                                    } else {
                                      shiftName = 'День свободен';
                                    }

                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftScheduleEditorScreen(schedule: s)));
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surface.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: selectedScheduleId == s.id ? colorScheme.primary.withOpacity(0.8) : onSurface.withOpacity(0.1),
                                            width: selectedScheduleId == s.id ? 2 : 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  if (hasTimedShift)
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _visibleTimelineScheduleId = (_visibleTimelineScheduleId == s.id) ? null : s.id;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 12.0),
                                                        child: Icon(
                                                          _visibleTimelineScheduleId == s.id ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                                          color: Color(s.color),
                                                        ),
                                                      ),
                                                    ),
                                                  Expanded(
                                                    child: Text(
                                                      s.title,
                                                      style: TextStyle(color: Color(s.color), fontWeight: FontWeight.bold, fontSize: 16),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    if (primaryShift != null && !isTransparent)
                                                      Container(
                                                        width: 10, height: 10,
                                                        margin: const EdgeInsets.only(right: 8),
                                                        decoration: BoxDecoration(color: shiftColor, shape: BoxShape.circle),
                                                      ),
                                                    Text(shiftName, style: TextStyle(color: shiftColor, fontWeight: primaryShift != null && !isTransparent ? FontWeight.bold : FontWeight.normal)),
                                                  ],
                                                ),
                                                if (shiftTime.isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0),
                                                    child: Text(shiftTime, style: TextStyle(color: shiftColor.withOpacity(0.8), fontSize: 12)),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),

                          if (schedules.isNotEmpty)
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: onSurface.withOpacity(0.1), height: 1)),

                          if (dayEvents.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Center(child: Text('Список событий пуст', style: TextStyle(color: onSurfaceVariant))),
                            )
                          else
                            ...dayEvents.map((event) {
                              // Расчет времени для отображения в списке конкретного дня
                              DateTime displayStart = event.dateTime.isBefore(startOfDay) ? startOfDay : event.dateTime;
                              
                              DateTime displayEnd;
                              if (event.isAllDay) {
                                displayEnd = endOfDay;
                              } else {
                                final actualEnd = event.endTime ?? event.dateTime.add(const Duration(minutes: 1));
                                displayEnd = actualEnd.isAfter(endOfDay) ? endOfDay : actualEnd;
                              }

                              String timeStr;
                              if (event.isAllDay) {
                                timeStr = 'Весь день';
                              } else if (event.endTime == null) {
                                timeStr = '${displayStart.hour.toString().padLeft(2, '0')}:${displayStart.minute.toString().padLeft(2, '0')}';
                              } else {
                                final s = '${displayStart.hour.toString().padLeft(2, '0')}:${displayStart.minute.toString().padLeft(2, '0')}';
                                final e = '${displayEnd.hour.toString().padLeft(2, '0')}:${displayEnd.minute.toString().padLeft(2, '0')}';
                                timeStr = '$s - $e';
                              }

                              Color? backgroundColor;
                              if (event.type == EventType.holiday) {
                                backgroundColor = Colors.yellow.withOpacity(0.2);
                              } else if (event.type == EventType.task) {
                                backgroundColor = Colors.green.withOpacity(0.15);
                              }

                              return Container(
                                color: backgroundColor,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: event.type == EventType.task
                                          ? Checkbox(
                                              value: event.isCompleted,
                                              activeColor: Colors.green,
                                              onChanged: (val) {
                                                event.isCompleted = val ?? false;
                                                ref.read(eventsProvider.notifier).updateEvent(event);
                                              },
                                            )
                                          : Container(
                                              width: 12, height: 12,
                                              margin: const EdgeInsets.symmetric(horizontal: 16),
                                              decoration: BoxDecoration(color: Color(event.color), shape: BoxShape.circle),
                                            ),
                                      title: Opacity(
                                        opacity: event.isCompleted ? 0.5 : 1.0,
                                        child: Text(event.title, style: TextStyle(fontWeight: FontWeight.bold, color: onSurface)),
                                      ),
                                      subtitle: Opacity(
                                        opacity: event.isCompleted ? 0.5 : 1.0,
                                        child: Text(timeStr, style: TextStyle(color: onSurfaceVariant)),
                                      ),
                                      trailing: Icon(Icons.chevron_right, color: onSurfaceVariant),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => EventEditorScreen(event: event)));
                                      },
                                    ),
                                    Divider(color: onSurface.withOpacity(0.1), height: 1),
                                  ],
                                ),
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          onPressed: () {
            final newEventDate = DateTime(_currentDate.year, _currentDate.month, _currentDate.day, DateTime.now().hour, DateTime.now().minute);
            Navigator.push(context, MaterialPageRoute(builder: (context) => EventEditorScreen(initialDate: newEventDate)));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class SunArcPainter extends CustomPainter {
  final double startX;
  final double endX;
  final double lineY;

  SunArcPainter({required this.startX, required this.endX, required this.lineY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(startX, lineY);
    path.quadraticBezierTo(startX + (endX - startX) / 2, 10, endX, lineY);

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.amber.withOpacity(0.2), Colors.transparent],
      ).createShader(Rect.fromLTRB(startX, 10, endX, lineY))
      ..style = PaintingStyle.fill;

    final fillPath = Path.from(path)
      ..lineTo(endX, lineY)
      ..lineTo(startX, lineY)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SunArcPainter oldDelegate) {
    return oldDelegate.startX != startX || oldDelegate.endX != endX;
  }
}
