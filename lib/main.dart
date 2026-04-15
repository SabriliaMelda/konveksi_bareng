import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:konveksi_bareng/config/api_config.dart';
import 'package:konveksi_bareng/config/app_router.dart';
import 'package:konveksi_bareng/config/app_theme.dart';
import 'package:konveksi_bareng/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ApiConfig.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static bool get devBypass =>
      dotenv.env['DEV_AUTH_BYPASS']?.toUpperCase() == 'TRUE';

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().darkMode;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Konveksi Bareng',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: devBypass ? devRouter : appRouter,
    );
  }
}

class MyAppHome extends StatelessWidget {
  const MyAppHome({super.key});

  static bool get devBypass =>
      dotenv.env['DEV_AUTH_BYPASS']?.toUpperCase() == 'TRUE';

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().darkMode;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Konveksi Bareng',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: devBypass ? devRouter : appRouter,
    );
  }
}
