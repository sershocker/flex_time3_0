import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  //загрузка темы
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode');

    if (isDark != null) {
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }
}

final appColorProvider = StateNotifierProvider<AppColorNotifier, MaterialColor>((ref) => AppColorNotifier());

class AppColorNotifier extends StateNotifier<MaterialColor> {
  AppColorNotifier() : super(Colors.blue) { _load(); }

  final List<MaterialColor> colors = [Colors.red, Colors.amber, Colors.green, Colors.blue];

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('app_color_index') ?? 3;
    state = colors[index];
  }

  Future<void> changeColor(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_color_index', index);
    state = colors[index];
  }
}

//первый день недели
//true = пон false = непон
final firstDayProvider = StateNotifierProvider<FirstDayNotifier, bool>((ref) => FirstDayNotifier());

class FirstDayNotifier extends StateNotifier<bool> {
  FirstDayNotifier() : super(true) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('is_monday_first') ?? true;
  }

  Future<void> toggle(bool isMonday) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_monday_first', isMonday);
    state = isMonday;
  }
}