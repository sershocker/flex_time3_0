import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';
import '../services/sync_service.dart';
import '../../features/calendar/providers/event_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    //запуск синхронизации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performInitialSync();
    });
  }

  Future<void> _performInitialSync() async {
    try {
      await ref.read(syncServiceProvider).syncEvents();
      //обновляем события
      ref.read(eventsProvider.notifier).loadEvents();
    } catch (e) {
      debugPrint('Initial sync error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
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
    if (index == widget.navigationShell.currentIndex) {
      final navigatorKey = shellNavigatorKeys[index];
      final navigator = navigatorKey.currentState;

      if (navigator != null && navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      }
    } else {
      widget.navigationShell.goBranch(
        index,
        initialLocation: false,
      );
    }
  }
}
