import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main_screen.dart';
import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/timers/screens/timers_screen.dart';
import '../../features/activity/screens/activity_screen.dart';
import '../../features/shifts/screens/shifts_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

//ключи
final calendarNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'calendarNav');
final timersNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'timersNav');
final activityNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'activityNav');
final shiftsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shiftsNav');
final settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settingsNav');

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/calendar',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        //календарь
        StatefulShellBranch(
          navigatorKey: calendarNavigatorKey,
          routes: [GoRoute(path: '/calendar', builder: (context, state) => const CalendarScreen())],
        ),
        //таймеры
        StatefulShellBranch(
          navigatorKey: timersNavigatorKey,
          routes: [GoRoute(path: '/timers', builder: (context, state) => const TimersScreen())],
        ),
        //активность
        StatefulShellBranch(
          navigatorKey: activityNavigatorKey,
          routes: [GoRoute(path: '/activity', builder: (context, state) => const ActivityScreen())],
        ),
        //смены
        StatefulShellBranch(
          navigatorKey: shiftsNavigatorKey,
          routes: [GoRoute(path: '/shifts', builder: (context, state) => const ShiftsScreen())],
        ),
        //настройки
        StatefulShellBranch(
          navigatorKey: settingsNavigatorKey,
          routes: [GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen())],
        ),
      ],
    ),
  ],
);
final List<GlobalKey<NavigatorState>> shellNavigatorKeys = [
  calendarNavigatorKey,
  timersNavigatorKey,
  activityNavigatorKey,
  shiftsNavigatorKey,
  settingsNavigatorKey,
];