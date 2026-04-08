import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/screens/main/main.dart
=======
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:konveksi_bareng/config/api_config.dart';
>>>>>>> db0fead1bdd8415c3e0d6567f9ffcc9446bff833:lib/main.dart
import 'package:konveksi_bareng/screens/auth/welcome.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await ApiConfig.init();
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
