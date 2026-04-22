import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:konveksi_bareng/config/api_config.dart';
import 'package:konveksi_bareng/config/app_router.dart';
import 'package:konveksi_bareng/config/app_theme.dart';
import 'package:konveksi_bareng/providers/theme_provider.dart';
import 'package:konveksi_bareng/services/biometric_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Draw edge-to-edge — Flutter content extends behind status bar & nav bar.
  // Each screen/widget controls its own insets via SafeArea / MediaQuery.padding.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  await dotenv.load(fileName: ".env");
  await ApiConfig.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      await BiometricService.markPaused();
    } else if (state == AppLifecycleState.resumed) {
      final shouldLock = await BiometricService.shouldLockOnResume();
      if (shouldLock) {
        await BiometricService.clearUnlock();
        final ctx = rootNavigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          appRouter.go('/biometric-lock');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().darkMode;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Konveksi Bareng',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
