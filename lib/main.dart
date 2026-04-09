import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:konveksi_bareng/config/api_config.dart';
import 'package:konveksi_bareng/config/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ApiConfig.init();
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
