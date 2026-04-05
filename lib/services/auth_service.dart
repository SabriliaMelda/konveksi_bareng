import 'dart:convert';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  AuthService._();

  static String get _baseUrl {
    // Web/Desktop → localhost
    if (kIsWeb) return 'http://localhost:4001';
    // Android Emulator → 10.0.2.2 (alias ke host localhost)
    if (Platform.isAndroid) return 'http://10.0.2.2:4001';
    // iOS Simulator → localhost
    if (Platform.isIOS) return 'http://localhost:4001';
    // Desktop (Windows/macOS/Linux)
    return 'http://localhost:4001';
  }

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
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

  static bool _isOk(int? statusCode) =>
      statusCode != null && statusCode >= 200 && statusCode < 300;

  // ── Request OTP ──

  static Future<({bool ok, int statusCode, String? message})> requestOtp(
      String email) async {
    try {
      final res = await _dio.post(
        '/auth/request-otp',
        data: {'email': email},
        options: Options(responseType: ResponseType.plain),
      );
      final data = _asMap(res.data);
      return (
        ok: _isOk(res.statusCode),
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
    Map<String, dynamic>? deviceInfo,
  }) async {
    try {
      final body = <String, dynamic>{'email': email, 'otp': otp};
      if (deviceInfo != null) body['deviceInfo'] = deviceInfo;
      final res = await _dio.post(
        '/auth/verify-otp',
        data: body,
        options: Options(responseType: ResponseType.plain),
      );
      final parsed = _asMap(res.data);
      return (
        ok: _isOk(res.statusCode),
        statusCode: res.statusCode ?? 500,
        token: parsed['token'] as String?,
        message: parsed['message'] as String?,
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
        '/auth/register',
        data: {
          'name': name,
          'email': email.toLowerCase().trim(),
          'phone': phone,
        },
        options: Options(responseType: ResponseType.plain),
      );
      final data = _asMap(res.data);
      return (
        ok: _isOk(res.statusCode),
        message: data['message'] as String?,
      );
    } on DioException {
      return (ok: false, message: 'Network error');
    }
  }

  // ── Verify Register OTP ──

  static Future<({bool ok, int statusCode, String? message})>
      verifyRegisterOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await _dio.post(
        '/auth/verify-register-otp',
        data: {'email': email, 'otp': otp},
        options: Options(responseType: ResponseType.plain),
      );
      final data = _asMap(res.data);
      return (
        ok: _isOk(res.statusCode),
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

  // ── Resend Register OTP ──

  static Future<({bool ok, int statusCode, String? message})>
      resendRegisterOtp(String email) async {
    try {
      final res = await _dio.post(
        '/auth/resend-register-otp',
        data: {'email': email},
        options: Options(responseType: ResponseType.plain),
      );
      final data = _asMap(res.data);
      return (
        ok: _isOk(res.statusCode),
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

  // ── Security Questions ──

  static Future<({bool ok, String? message})> saveSecurityQuestions({
    required String email,
    required String question1,
    required String answer1,
    required String question2,
    required String answer2,
  }) async {
    try {
      final res = await _dio.post(
        '/auth/security-questions',
        data: {
          'email': email,
          'question1': question1,
          'answer1': answer1,
          'question2': question2,
          'answer2': answer2,
        },
        options: Options(responseType: ResponseType.plain),
      );
      final data = _asMap(res.data);
      return (
        ok: _isOk(res.statusCode),
        message: data['message'] as String?,
      );
    } on DioException {
      return (ok: false, message: 'Network error');
    }
  }

  static Future<
      ({
        bool ok,
        Map<String, dynamic>? user,
        List<Map<String, dynamic>> questions,
        String? message,
      })> getSecurityQuestions(String email) async {
    try {
      final res = await _dio.get(
        '/auth/security-questions',
        queryParameters: {'email': email},
        options: Options(responseType: ResponseType.plain),
      );
      final data = _asMap(res.data);
      final user = data['user'] as Map<String, dynamic>?;
      final questions = (data['questions'] as List?)
              ?.map((q) => q as Map<String, dynamic>)
              .toList() ??
          [];
      return (
        ok: _isOk(res.statusCode),
        user: user,
        questions: questions,
        message: data['message'] as String?,
      );
    } on DioException {
      return (
        ok: false,
        user: null,
        questions: <Map<String, dynamic>>[],
        message: 'Network error',
      );
    }
  }

  static Future<({bool ok, String? message})> verifySecurityAnswers({
    required String email,
    required String answer1,
    required String answer2,
  }) async {
    try {
      final res = await _dio.post(
        '/auth/verify-security-answers',
        data: {
          'email': email,
          'answer1': answer1,
          'answer2': answer2,
        },
        options: Options(responseType: ResponseType.plain),
      );
      final data = _asMap(res.data);
      return (
        ok: _isOk(res.statusCode),
        message: data['message'] as String?,
      );
    } on DioException {
      return (ok: false, message: 'Network error');
    }
  }

  // ── Check Session (untuk Session Guard) ──

  static Future<int> checkSession(String token) async {
    try {
      final res = await _dio.get(
        '/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.plain,
        ),
      );
      return res.statusCode ?? 500;
    } on DioException catch (e) {
      return e.response?.statusCode ?? 0;
    }
  }

  // ── Logout ──

  static Future<bool> logout(String token) async {
    try {
      final res = await _dio.post(
        '/auth/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return _isOk(res.statusCode);
    } on DioException {
      return false;
    }
  }
}
