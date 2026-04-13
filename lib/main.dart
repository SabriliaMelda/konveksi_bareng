import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:konveksi_bareng/config/api_config.dart';
import 'package:konveksi_bareng/config/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ApiConfig.init();
  // Dev auth bypass: when DEV_AUTH_BYPASS=true, prefill a dev token and
  // launch the app to HomeScreen so frontend work can proceed without
  // hitting the backend. This only runs in development when you set the
  // variable in your .env file.
  final bypass = dotenv.env['DEV_AUTH_BYPASS'];
  if (bypass != null && bypass.toLowerCase() == 'true') {
    // store a dummy token that will be accepted by SessionGuard because
    // AuthService.checkSession will return 200 when the flag is set.
    await StorageService.setItem('auth_token', 'dev-token');
    runApp(const MyAppHome());
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static bool get devBypass =>
      dotenv.env['DEV_AUTH_BYPASS']?.toUpperCase() == 'TRUE';

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Konveksi Bareng',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B257F)),
        useMaterial3: true,
      ),
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Konveksi Bareng',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B257F)),
        useMaterial3: true,
      ),
      routerConfig: devBypass ? devRouter : appRouter,
    );
  }
}
