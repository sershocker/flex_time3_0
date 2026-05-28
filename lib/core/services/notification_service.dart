import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final tzResult = await FlutterTimezone.getLocalTimezone();
      String timeZoneName = tzResult is String
          ? tzResult
          : (tzResult as dynamic).identifier;

      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('NotificationService: error setting timezone: $e');
      try {
        tz.setLocalLocation(tz.getLocation('Europe/Moscow'));
      } catch (e2) {
        debugPrint('NotificationService: fallback timezone error: $e2');
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    try {
      await _notificationsPlugin.initialize(
        settings: initializationSettings,
      );
    } catch (e) {
      debugPrint('NotificationService: initialization error: $e');
    }
  }

  Future<bool> requestPermissions() async {
    bool? granted = false;
    try {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        granted = await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
      }
      final iosImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (iosImplementation != null) {
        granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      debugPrint('NotificationService: requestPermissions error: $e');
    }
    return granted ?? false;
  }

  Future<void> scheduleEventNotification({
    required int eventId,
    required String title,
    required DateTime eventDate,
    required bool notifyAtEvent,
    required bool notify15Min,
    required bool notify1Hour,
    required bool notify1Day,
  }) async {
    await cancelEventNotifications(eventId);

    tz.Location deviceLocation;
    try {
      final tzResult = await FlutterTimezone.getLocalTimezone();
      String tzName =
          tzResult is String ? tzResult : (tzResult as dynamic).identifier;
      deviceLocation = tz.getLocation(tzName);
    } catch (e) {
      deviceLocation = tz.getLocation('UTC');
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'events_channel',
        'События',
        channelDescription: 'Напоминания о запланированных событиях',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    Future<void> scheduleOffset(
        int offsetId, Duration offset, String bodyText) async {
      final scheduledTime = eventDate.subtract(offset);
      if (scheduledTime.isBefore(DateTime.now())) return;

      final targetDate = tz.TZDateTime.from(scheduledTime, deviceLocation);

      try {
        final int notificationId = (eventId.abs() * 10 + offsetId) & 0x7FFFFFFF;

        await _notificationsPlugin.zonedSchedule(
          id: notificationId,
          title: 'Напоминание: $title',
          body: bodyText,
          scheduledDate: targetDate,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (e) {
        debugPrint('Ошибка установки уведомления: $e');
      }
    }

    if (notifyAtEvent) await scheduleOffset(0, Duration.zero, 'Событие началось!');
    if (notify15Min) {
      await scheduleOffset(1, const Duration(minutes: 15), 'Начнется через 15 минут');
    }
    if (notify1Hour) {
      await scheduleOffset(2, const Duration(hours: 1), 'Начнется через 1 час');
    }
    if (notify1Day) {
      final timeStr =
          '${eventDate.hour.toString().padLeft(2, '0')}:${eventDate.minute.toString().padLeft(2, '0')}';
      await scheduleOffset(
          3, const Duration(days: 1), 'Начнется завтра в $timeStr');
    }
  }

  Future<void> cancelEventNotifications(int eventId) async {
    for (int i = 0; i <= 3; i++) {
      final int notificationId = (eventId.abs() * 10 + i) & 0x7FFFFFFF;
      try {
        await _notificationsPlugin.cancel(id: notificationId);
      } catch (e) {
        debugPrint('NotificationService: cancel error: $e');
      }
    }
  }
}
