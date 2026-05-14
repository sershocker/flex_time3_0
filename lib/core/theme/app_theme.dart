import 'package:flutter/material.dart';
import '../../features/settings/models/app_settings.dart';

class AppTheme {
  static ThemeData getTheme(AppSettings settings) {
    Color seedColor;
    switch (settings.colorScheme) {
      case ColorSchemeType.red:
        seedColor = Colors.red;
        break;
      case ColorSchemeType.yellow:
        seedColor = Colors.amber;
        break;
      case ColorSchemeType.green:
        seedColor = Colors.green;
        break;
      case ColorSchemeType.blue:
      default:
        seedColor = Colors.blue;
        break;
    }

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: settings.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      useMaterial3: true,
    );
  }
}