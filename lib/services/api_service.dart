import 'package:dio/dio.dart';

class ApiService {
  ApiService._();

  // GANTI dengan base URL API Anda:
  // - Emulator Android: http://10.0.2.2:4001
  // - HP fisik (satu wifi): http://IP_LAPTOP:4001
  // - Web/Desktop: http://localhost:4001
  static const String baseUrl = 'http://10.0.2.2:4001';

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
