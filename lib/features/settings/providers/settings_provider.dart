import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../core/database/local_db.dart';
import '../models/app_settings.dart';

//провайдер к настройкам
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(_loadInitialSettings());

  static AppSettings _loadInitialSettings() {
    final isar = LocalDb.instance;
    //получить настройки
    var settings = isar.appSettings.getSync(1);

    //если первый запуск
    if (settings == null) {
      settings = AppSettings();
      isar.writeTxnSync(() => isar.appSettings.putSync(settings!));
    }
    return settings;
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    final isar = LocalDb.instance;
    await isar.writeTxn(() async {
      await isar.appSettings.put(newSettings);
    });
    //обновление UI
    state = newSettings;
  }
}