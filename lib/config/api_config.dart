import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ApiConfig {
  ApiConfig._();

  /// URL yang sudah di-resolve saat app startup via [init()]
  static String _baseUrl = '';

  static String get baseUrl => _baseUrl;

  /// Panggil sekali di main() sebelum runApp()
  static Future<void> init() async {
    final envUrl = dotenv.env['API_URL'];

    // Kalau .env diisi URL production (bukan localhost/10.0.2.2), pakai itu
    if (envUrl != null &&
        envUrl.isNotEmpty &&
        !envUrl.contains('localhost') &&
        !envUrl.contains('10.0.2.2')) {
      _baseUrl = envUrl;
      return;
    }

    // Development: fallback otomatis per platform
    if (kIsWeb) {
      _baseUrl = 'http://localhost:4001';
      return;
    }

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.isPhysicalDevice) {
        // HP fisik → pakai IP LAN PC
        _baseUrl = 'http://192.168.1.6:4001';
      } else {
        // Emulator → pakai alias 10.0.2.2
        _baseUrl = 'http://10.0.2.2:4001';
      }
      return;
    }

    // iOS / desktop
    _baseUrl = 'http://localhost:4001';
  }
}
