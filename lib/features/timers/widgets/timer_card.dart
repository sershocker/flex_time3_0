import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../calendar/models/event.dart';

class TimerCard extends StatefulWidget {
  final Event event;
  final VoidCallback onTap;

  const TimerCard({super.key, required this.event, required this.onTap});

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  late Stream<DateTime> _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
  }

  String _formatRemainingTime(Duration remaining, DateTime end) {
    if (remaining.isNegative) return "Завершено";

    switch (widget.event.unitType) {
      case UnitType.combined:
        final now = DateTime.now();
        int years = end.year - now.year;
        int months = end.month - now.month;
        int days = end.day - now.day;

        if (days < 0) {
          final previousMonth = DateTime(end.year, end.month, 0);
          days += previousMonth.day;
          months--;
        }
        if (months < 0) {
          months += 12;
          years--;
        }

        List<String> parts = [];
        if (years > 0) parts.add('$years л.');
        if (months > 0) parts.add('$months мес.');
        if (days > 0) parts.add('$days д.');
        
        return parts.isEmpty ? "Меньше дня" : parts.join(' ');

      case UnitType.years:
        return '${remaining.inDays ~/ 365} лет';
      case UnitType.months:
        return '${remaining.inDays ~/ 30} месяцев';
      case UnitType.weeks:
        return '${remaining.inDays ~/ 7} недель';
      case UnitType.days:
        return '${remaining.inDays} дней';
      case UnitType.hours:
        return '${remaining.inHours} часов';
      case UnitType.minutes:
        return '${remaining.inMinutes} минут';
      case UnitType.seconds:
      default:
        return '${remaining.inSeconds} секунд';
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = widget.event.timerStartDate ?? DateTime.now();
    final end = widget.event.dateTime;
    final totalSeconds = end.difference(start).inSeconds;

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<DateTime>(
            stream: _ticker,
            builder: (context, snapshot) {
              final now = snapshot.data ?? DateTime.now();

              if (now.isBefore(start)) {
                return _buildCardContent(
                  timeString: "Еще не началось",
                  percent: 0.0,
                  progressColor: Colors.grey,
                );
              }

              final remainingSeconds = end.difference(now).inSeconds;

              double percent = 1.0 - (remainingSeconds / totalSeconds);
              if (percent < 0.0) percent = 0.0;
              if (percent > 1.0) percent = 1.0;

              final duration = end.difference(now);
              final timeString = _formatRemainingTime(duration, end);
              final progressColor = Color(widget.event.color);

              return _buildCardContent(
                timeString: timeString,
                percent: percent,
                progressColor: progressColor,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent({required String timeString, required double percent, required Color progressColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.event.title, style: Theme.of(context).textTheme.titleLarge),
        if (widget.event.description?.isNotEmpty ?? false) ...[
          const SizedBox(height: 4),
          Text(widget.event.description!, style: Theme.of(context).textTheme.bodyMedium),
        ],
        const SizedBox(height: 16),
        Center(
          child: widget.event.viewType == ViewType.circle
              ? CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            percent: percent,
            center: Text(timeString, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
            progressColor: progressColor,
            backgroundColor: progressColor.withOpacity(0.2),
            circularStrokeCap: CircularStrokeCap.round,
          )
              : LinearPercentIndicator(
            lineHeight: 20.0,
            percent: percent,
            center: Text(timeString, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            progressColor: progressColor,
            backgroundColor: progressColor.withOpacity(0.2),
            barRadius: const Radius.circular(10),
          ),
        ),
      ],
    );
  }
}