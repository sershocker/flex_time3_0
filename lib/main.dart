import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/local_db.dart';
import 'core/navigation/app_router.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация БД с обработкой ошибок
  try {
    await LocalDb.init();
  } catch (e) {
    debugPrint('LocalDb initialization error: $e');
  }

  // Инициализация уведомлений с обработкой ошибок
  try {
    await NotificationService().init();
  } catch (e) {
    debugPrint('NotificationService initialization error: $e');
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //тема SharedPreferences
    final themeMode = ref.watch(themeProvider);

    //выбранный цвет из настроек
    final primaryColor = ref.watch(appColorProvider);

    return MaterialApp.router(
      title: 'Organizer App',
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
      ],

      themeMode: themeMode,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      routerConfig: appRouter,
    );
  }
}
