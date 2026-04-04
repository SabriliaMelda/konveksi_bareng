import 'dart:convert';
import 'package:dio/dio.dart';

class AuthService {
  AuthService._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.xsoftco.com/api-auth',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      followRedirects: false,
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  static Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      final s = data.trim();
      if (!s.startsWith('{') && !s.startsWith('[')) {
        return {'success': false, 'message': s.isEmpty ? 'Empty response' : s};
      }
      try {
        final decoded = jsonDecode(s);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
        return {'success': true, 'data': decoded};
      } catch (_) {
        return {'success': false, 'message': 'Invalid JSON', 'raw': s};
      }
    }
    return {'success': false, 'message': 'Unsupported response format'};
  }

  // ── Request OTP ──

  static Future<({bool ok, int statusCode, String? message})> requestOtp(
      String email) async {
    try {
      final res = await _dio.post(
        '/request-otp.php',
        data: {'email': email},
        options: Options(responseType: ResponseType.plain),
      );
      final data = _asMap(res.data);
      return (
        ok: res.statusCode != null &&
            res.statusCode! >= 200 &&
            res.statusCode! < 300,
        statusCode: res.statusCode ?? 500,
        message: data['message'] as String?,
      );
    } on DioException catch (e) {
      return (
        ok: false,
        statusCode: e.response?.statusCode ?? 0,
        message: 'Network error',
      );
    }
  }

  // ── Verify OTP ──

  static Future<
      ({bool ok, int statusCode, String? token, String? message})> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await _dio.post(
        '/verify-otp.php',
        data: {'email': email, 'otp': otp},
        options: Options(responseType: ResponseType.plain),
      );
      final data = _asMap(res.data);
      return (
        ok: res.statusCode != null &&
            res.statusCode! >= 200 &&
            res.statusCode! < 300,
        statusCode: res.statusCode ?? 500,
        token: data['token'] as String?,
        message: data['message'] as String?,
      );
    } on DioException catch (e) {
      return (
        ok: false,
        statusCode: e.response?.statusCode ?? 0,
        token: null,
        message: 'Network error',
      );
    }
  }

  // ── Register ──

  static Future<({bool ok, String? message})> register({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final res = await _dio.post(
        '/register.php',
        data: {
          'name': name,
          'email': email.toLowerCase().trim(),
          'phone': phone,
        },
        options: Options(responseType: ResponseType.plain),
      );
      final data = _asMap(res.data);
      return (
        ok: res.statusCode != null &&
            res.statusCode! >= 200 &&
            res.statusCode! < 300,
        message: data['message'] as String?,
      );
    } on DioException {
      return (ok: false, message: 'Network error');
    }
  }
}
