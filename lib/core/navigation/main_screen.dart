import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Календарь'),
          NavigationDestination(icon: Icon(Icons.timer), label: 'Таймеры'),
          NavigationDestination(icon: Icon(Icons.directions_run), label: 'Активность'),
          NavigationDestination(icon: Icon(Icons.work_history), label: 'Смены'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Настройки'),
        ],
      ),
    );
  }

  void _onTap(int index) {
    if (index == navigationShell.currentIndex) {
      //ключ по индексу
      final navigatorKey = shellNavigatorKeys[index];
      final navigator = navigatorKey.currentState;

      if (navigator != null && navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      }
    } else {
      navigationShell.goBranch(
        index,
        initialLocation: false,
      );
    }
  }
}