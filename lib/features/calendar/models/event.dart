import 'package:isar_community/isar.dart';

part 'event.g.dart';

enum UnitType { seconds, minutes, hours, days, weeks, months, years, combined }
enum ViewType { circle, line }
enum EventType { holiday, task, event }

@collection
class Event {
  Id id = Isar.autoIncrement;

  late String title;

  String? description;

  late DateTime dateTime; //начало события/конец таймера/deadline задачи

  DateTime? endTime; //конец события

  bool isAllDay = false;

  late int color;

  @enumerated
  EventType type = EventType.event;

  bool isCompleted = false; // Для задачи

  // Поля таймера
  bool isTimer = false;

  @enumerated
  UnitType unitType = UnitType.combined;

  @enumerated
  ViewType viewType = ViewType.circle;

  DateTime? timerStartDate;

  bool notificationsEnabled = true;

  // --- Поля для синхронизации с Google Calendar ---

  @Index()
  String? googleEventId; // ID в Google Calendar (для API запросов)

  String? iCalUID; // Глобальный уникальный ID (для импорта/экспорта)

  String? etag; // Версия объекта в Google для предотвращения конфликтов

  String? calendarId; // ID календаря (например, 'primary')

  String? location; // Местоположение

  // Правила повторения в формате iCalendar (напр. "RRULE:FREQ=WEEKLY;BYDAY=MO")
  String? recurrenceRule;

  // Для экземпляров повторяющихся событий: ID родительского события
  String? recurringEventId;

  // Для исключений: исходное время начала события из серии
  DateTime? originalStartTime;

  // Статус события: confirmed, tentative, cancelled
  String? status;

  // Флаг "мягкого удаления" для синхронизации удаления в облако
  bool isDeletedLocally = false;

  // Флаг того, что локальные изменения еще не отправлены в облако
  bool needsSync = false;

  // Время последнего изменения для разрешения конфликтов
  DateTime lastModifiedLocally;

  // Время последней успешной синхронизации
  DateTime? lastSyncedAt;

  Event() : lastModifiedLocally = DateTime.now() {
    unitType = UnitType.combined;
    viewType = ViewType.circle;
    timerStartDate = DateTime.now();
    status = 'confirmed';
    type = EventType.event;
  }

  // Метод для обновления метки времени при изменении полей
  void markAsModified() {
    lastModifiedLocally = DateTime.now();
    needsSync = true;
  }
}
