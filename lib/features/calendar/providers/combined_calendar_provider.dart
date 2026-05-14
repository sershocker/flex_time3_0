import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event_provider.dart';
import '../../shifts/providers/shift_provider.dart';

final selectedScheduleIdProvider = StateProvider<int?>((ref) => null);

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

//провайдер база
final allAppointmentsProvider = Provider<List<Appointment>>((ref) {
  final events = ref.watch(eventsProvider);
  final schedules = ref.watch(shiftSchedulesProvider);
  final templates = ref.watch(shiftTemplatesProvider);
  final dayTypes = ref.watch(dayTypesProvider);

  List<Appointment> appointments = [];

  //события
  for (var e in events) {
    appointments.add(Appointment(
      id: 'event_${e.id}',
      startTime: e.dateTime,
      endTime: e.dateTime.add(const Duration(hours: 1)),
      subject: e.title,
      color: Color(e.color),
      notes: e.description,
    ));
  }

  //смены всех графиков
  if (templates.isNotEmpty && dayTypes.isNotEmpty) {
    final now = DateTime.now();
    final limitStart = DateTime(now.year - 1, now.month, now.day);
    final limitEnd = DateTime(now.year + 1, now.month, now.day);

    for (var schedule in schedules) {

      final template = templates.where((t) => t.id == schedule.templateId).firstOrNull;
      if (template == null || template.dayTypeIds.isEmpty) continue;

      DateTime currentDay = schedule.startDate;

      if (currentDay.isBefore(limitStart)) currentDay = limitStart;

      DateTime endLimit = schedule.endDate ?? limitEnd;
      if (endLimit.isAfter(limitEnd)) endLimit = limitEnd;

      int cycleLength = template.dayTypeIds.length;

      while (currentDay.isBefore(endLimit) || currentDay.isAtSameMomentAs(endLimit)) {
        int diff = daysBetween(schedule.startDate, currentDay);

        if (diff < 0) {
          currentDay = DateTime(currentDay.year, currentDay.month, currentDay.day + 1);
          continue;
        }

        int cycleIndex = (diff + schedule.offset) % cycleLength;
        int dayTypeId = template.dayTypeIds[cycleIndex];

        final dayType = dayTypes.where((d) => d.id == dayTypeId).firstOrNull;

        if (dayType != null) {
          DateTime shiftStart = currentDay;
          DateTime shiftEnd = currentDay;
          bool isAllDay = true;

          if (dayType.startHour != null && dayType.startMinute != null) {
            shiftStart = DateTime(currentDay.year, currentDay.month, currentDay.day, dayType.startHour!, dayType.startMinute!);
            isAllDay = false;
          }

          if (dayType.endHour != null && dayType.endMinute != null) {
            shiftEnd = DateTime(currentDay.year, currentDay.month, currentDay.day, dayType.endHour!, dayType.endMinute!);
            if (shiftEnd.isBefore(shiftStart)) {
              shiftEnd = shiftEnd.add(const Duration(days: 1));
            }
          } else if (!isAllDay) {
            shiftEnd = shiftStart.add(const Duration(hours: 8));
          }

          appointments.add(Appointment(
            id: 'shift_${schedule.id}_${currentDay.millisecondsSinceEpoch}',
            startTime: shiftStart,
            endTime: shiftEnd,
            subject: '${schedule.title}: ${dayType.name}',
            color: Color(dayType.backgroundColor),
            isAllDay: isAllDay,
          ));
        }

        currentDay = DateTime(currentDay.year, currentDay.month, currentDay.day + 1);
      }
    }
  }

  return appointments;
});

//провайдер календаря
final combinedCalendarProvider = Provider<List<Appointment>>((ref) {
  final allAppointments = ref.watch(allAppointmentsProvider);
  final selectedScheduleId = ref.watch(selectedScheduleIdProvider);

  return allAppointments.where((app) {
    if (app.id.toString().startsWith('event_')) return true;

    if (selectedScheduleId != null && app.id.toString().startsWith('shift_${selectedScheduleId}_')) {
      return true;
    }

    return false;
  }).toList();
});