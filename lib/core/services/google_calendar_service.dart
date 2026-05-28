import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import '../../features/calendar/models/event.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:flutter/material.dart';

class GoogleCalendarService {
  static final GoogleCalendarService _instance = GoogleCalendarService._internal();
  factory GoogleCalendarService() => _instance;
  GoogleCalendarService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      cal.CalendarApi.calendarEventsScope,
      cal.CalendarApi.calendarScope,
    ],
  );

  GoogleSignInAccount? _currentUser;

  //цвета гугловские
  static const Map<String, int> _googleColorIdToArgb = {
    '1': 0xFFA4BDFC,
    '2': 0xFF7AE7BF,
    '3': 0xFFDBADFF,
    '4': 0xFFFF887C,
    '5': 0xFFFBD75B,
    '6': 0xFFFFB878,
    '7': 0xFF46D6DB,
    '8': 0xFFE1E1E1,
    '9': 0xFF5484ED,
    '10': 0xFF51B749,
    '11': 0xFFDC2127,
  };

  static String? _getGoogleColorId(int argb) {
    //ближайший цвет или null
    String? bestId;
    double minDistance = double.maxFinite;

    final color = Color(argb);

    _googleColorIdToArgb.forEach((id, googleArgb) {
      final googleColor = Color(googleArgb);
      final distance = _colorDistance(color, googleColor);
      if (distance < minDistance) {
        minDistance = distance;
        bestId = id;
      }
    });
    return bestId;
  }

  static double _colorDistance(Color c1, Color c2) {
    return (c1.red - c2.red).toDouble() * (c1.red - c2.red) +
           (c1.green - c2.green).toDouble() * (c1.green - c2.green) +
           (c1.blue - c2.blue).toDouble() * (c1.blue - c2.blue);
  }

  static int getColorFromGoogleId(String? colorId) {
    if (colorId == null) return 0xFF2196F3; //цвет по умолчанию
    return _googleColorIdToArgb[colorId] ?? 0xFF2196F3;
  }

  Future<bool> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      return _currentUser != null;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  Future<cal.CalendarApi?> _getCalendarApi() async {
    if (_currentUser == null) {
      _currentUser = await _googleSignIn.signInSilently();
    }
    
    if (_currentUser == null) return null;

    final authClient = await _googleSignIn.authenticatedClient();
    if (authClient == null) return null;

    return cal.CalendarApi(authClient);
  }

  Future<String?> upsertEvent(Event event) async {
    final api = await _getCalendarApi();
    if (api == null) return null;

    final googleEvent = cal.Event()
      ..summary = event.title
      ..description = event.description
      ..start = cal.EventDateTime(
        dateTime: event.dateTime.toUtc(),
        timeZone: 'UTC',
      )
      ..end = cal.EventDateTime(
        dateTime: (event.endTime ?? event.dateTime.add(const Duration(hours: 1))).toUtc(),
        timeZone: 'UTC',
      )
      ..location = event.location
      ..colorId = _getGoogleColorId(event.color);

    try {
      cal.Event result;
      if (event.googleEventId != null) {
        result = await api.events.update(googleEvent, 'primary', event.googleEventId!);
      } else {
        result = await api.events.insert(googleEvent, 'primary');
      }
      return result.id;
    } catch (e) {
      print('Error upserting event to Google Calendar: $e');
      return null;
    }
  }

  Future<bool> deleteEvent(String googleEventId) async {
    final api = await _getCalendarApi();
    if (api == null) return false;

    try {
      await api.events.delete('primary', googleEventId);
      return true;
    } catch (e) {
      print('Error deleting event from Google Calendar: $e');
      return false;
    }
  }

  Future<List<cal.Event>> fetchEvents({DateTime? minTime, DateTime? maxTime}) async {
    final api = await _getCalendarApi();
    if (api == null) return [];

    try {
      final events = await api.events.list(
        'primary',
        timeMin: minTime?.toUtc(),
        timeMax: maxTime?.toUtc(),
        singleEvents: true,
      );
      return events.items ?? [];
    } catch (e) {
      print('Error fetching events from Google Calendar: $e');
      return [];
    }
  }
}
