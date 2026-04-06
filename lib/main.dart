import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:konveksi_bareng/config/api_config.dart';
import 'package:konveksi_bareng/screens/auth/welcome.dart';
import 'package:konveksi_bareng/screens/main/home.dart';
import 'package:konveksi_bareng/services/storage_service.dart';

Future<void> main() async {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(), // <-- diarahkan ke Welcome Page
    );
  }
}

class MyAppHome extends StatelessWidget {
  const MyAppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Konveksi Bareng (Dev)',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
