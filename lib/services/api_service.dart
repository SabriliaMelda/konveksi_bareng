import 'package:dio/dio.dart';

class ApiService {
  ApiService._();

  // GANTI dengan base URL API Anda:
  // - Emulator Android: http://10.0.2.2:8000
  // - HP fisik (satu wifi/hotspot): http://IP_LAPTOP:8000 (mis. http://192.168.1.10:8000)
  static const String baseUrl = 'http://10.0.2.2:8000';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
}
