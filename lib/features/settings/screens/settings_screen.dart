import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/google_calendar_service.dart';
import '../../../core/services/sync_service.dart';
import '../providers/settings_provider.dart';
import '../../calendar/providers/event_provider.dart';

//провайдеры уведомлений
final notificationsEnabledProvider = StateProvider<bool>((ref) => false);
final notifyAtEventProvider = StateProvider<bool>((ref) => false);
final notify15MinProvider = StateProvider<bool>((ref) => true);
final notify1HourProvider = StateProvider<bool>((ref) => false);
final notify1DayProvider = StateProvider<bool>((ref) => false);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isGoogleSyncing = false;
  final GoogleCalendarService _googleCalendarService = GoogleCalendarService();

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    ref.read(notificationsEnabledProvider.notifier).state = prefs.getBool('notifications_enabled') ?? false;
    ref.read(notifyAtEventProvider.notifier).state = prefs.getBool('notify_at_event') ?? false;
    ref.read(notify15MinProvider.notifier).state = prefs.getBool('notify_15_min') ?? true;
    ref.read(notify1HourProvider.notifier).state = prefs.getBool('notify_1_hour') ?? false;
    ref.read(notify1DayProvider.notifier).state = prefs.getBool('notify_1_day') ?? false;
  }

  Future<void> _toggleMainNotifications(bool value) async {
    if (value) {
      final granted = await NotificationService().requestPermissions();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Необходимо выдать разрешение в настройках телефона')),
          );
        }
        return;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    ref.read(notificationsEnabledProvider.notifier).state = value;
  }

  Future<void> _toggleSubSetting(String key, bool value, StateProvider<bool> provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    ref.read(provider.notifier).state = value;
  }

  Future<void> _handleGoogleSync() async {
    final settings = ref.read(settingsProvider);
    
    setState(() => _isGoogleSyncing = true);
    
    try {
      if (!settings.googleSyncEnabled) {
        final success = await _googleCalendarService.signIn();
        if (success) {
          final newSettings = settings..googleSyncEnabled = true;
          await ref.read(settingsProvider.notifier).updateSettings(newSettings);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Синхронизация включена')),
            );
          }
          
          // Запуск первой синхронизации
          await ref.read(syncServiceProvider).syncEvents();
          ref.read(eventsProvider.notifier).loadEvents();
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Не удалось войти в Google')),
            );
          }
        }
      } else {
        await _googleCalendarService.signOut();
        final newSettings = settings..googleSyncEnabled = false;
        await ref.read(settingsProvider.notifier).updateSettings(newSettings);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Синхронизация отключена')),
          );
        }
      }
    } catch (e) {
      print('Google Sync Error: $e');
    } finally {
      if (mounted) setState(() => _isGoogleSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);

    final appColor = ref.watch(appColorProvider);
    final colorNotifier = ref.read(appColorProvider.notifier);

    final isMondayFirst = ref.watch(firstDayProvider);
    final isNotificationsEnabled = ref.watch(notificationsEnabledProvider);
    final appSettings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Внешний вид', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Темная тема'),
                  secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                  value: isDarkMode,
                  onChanged: (val) => ref.read(themeProvider.notifier).toggleTheme(val),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Цветовая схема', style: TextStyle(fontSize: 16)),
                      Wrap(
                        spacing: 12,
                        children: List.generate(colorNotifier.colors.length, (index) {
                          final color = colorNotifier.colors[index];
                          final isSelected = appColor == color;
                          return GestureDetector(
                            onTap: () => colorNotifier.changeColor(index),
                            child: CircleAvatar(
                              backgroundColor: color,
                              radius: 16,
                              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          //настройка календаря
          const Text('Календарь', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Первый день недели'),
              trailing: DropdownButton<bool>(
                value: isMondayFirst,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Понедельник')),
                  DropdownMenuItem(value: false, child: Text('Воскресенье')),
                ],
                onChanged: (val) {
                  if (val != null) ref.read(firstDayProvider.notifier).toggle(val);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          //уведомления
          const Text('Уведомления', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text('Разрешить уведомления', style: TextStyle(fontWeight: FontWeight.bold)),
                  secondary: Icon(
                    isNotificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
                    color: isNotificationsEnabled ? Theme.of(context).colorScheme.primary : Colors.grey,
                  ),
                  value: isNotificationsEnabled,
                  onChanged: _toggleMainNotifications,
                ),

                if (isNotificationsEnabled) ...[
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('В момент начала'),
                    value: ref.watch(notifyAtEventProvider),
                    onChanged: (val) => _toggleSubSetting('notify_at_event', val, notifyAtEventProvider),
                  ),
                  SwitchListTile(
                    title: const Text('За 15 минут'),
                    value: ref.watch(notify15MinProvider),
                    onChanged: (val) => _toggleSubSetting('notify_15_min', val, notify15MinProvider),
                  ),
                  SwitchListTile(
                    title: const Text('За 1 час'),
                    value: ref.watch(notify1HourProvider),
                    onChanged: (val) => _toggleSubSetting('notify_1_hour', val, notify1HourProvider),
                  ),
                  SwitchListTile(
                    title: const Text('За 1 сутки'),
                    value: ref.watch(notify1DayProvider),
                    onChanged: (val) => _toggleSubSetting('notify_1_day', val, notify1DayProvider),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(height: 24),

          //google синхронизация
          const Text('Синхронизация', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.sync),
                  title: Text(appSettings.googleSyncEnabled ? 'Google Аккаунт подключен' : 'Синхронизация с Google'),
                  subtitle: Text(appSettings.googleSyncEnabled ? 'События сохраняются в облаке' : 'Сохраняйте события и графики'),
                  trailing: _isGoogleSyncing
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : OutlinedButton(
                    onPressed: _handleGoogleSync,
                    child: Text(appSettings.googleSyncEnabled ? 'Отключить' : 'Войти'),
                  ),
                ),
                if (appSettings.googleSyncEnabled) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.refresh),
                    title: const Text('Синхронизировать сейчас'),
                    onTap: _isGoogleSyncing ? null : () async {
                      setState(() => _isGoogleSyncing = true);
                      try {
                        await ref.read(syncServiceProvider).syncEvents();
                        await ref.read(eventsProvider.notifier).loadEvents();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Синхронизация завершена')),
                          );
                        }
                      } catch (e) {
                         if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ошибка синхронизации: $e')),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _isGoogleSyncing = false);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
