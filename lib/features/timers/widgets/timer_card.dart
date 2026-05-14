import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/timer_entity.dart';

class TimerCard extends StatefulWidget {
  final TimerEntity timerEntity;
  final VoidCallback onTap;

  const TimerCard({super.key, required this.timerEntity, required this.onTap});

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

  String _formatRemainingTime(Duration remaining) {
    if (remaining.isNegative) return "Завершено";

    switch (widget.timerEntity.unitType) {
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
    final start = widget.timerEntity.startDate ?? DateTime.now();
    final end = widget.timerEntity.endDate ?? DateTime.now().add(const Duration(days: 1));
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

              //если now < start
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
              final timeString = _formatRemainingTime(duration);
              final progressColor = Color(widget.timerEntity.progressColor);

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
        Text(widget.timerEntity.title, style: Theme.of(context).textTheme.titleLarge),
        if (widget.timerEntity.description?.isNotEmpty ?? false) ...[
          const SizedBox(height: 4),
          Text(widget.timerEntity.description!, style: Theme.of(context).textTheme.bodyMedium),
        ],
        const SizedBox(height: 16),
        Center(
          child: widget.timerEntity.viewType == ViewType.circle
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