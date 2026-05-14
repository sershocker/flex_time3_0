import 'package:syncfusion_flutter_calendar/calendar.dart';

class UnifiedDataSource extends CalendarDataSource {
  UnifiedDataSource(List<Appointment> source) {
    appointments = source;
  }
}