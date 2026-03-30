import 'dart:convert';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.xsoftco.com/api-auth',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
      followRedirects: false,
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Map<String, dynamic> _asMap(dynamic data) {
    // 1) Kalau sudah Map
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);

    // 2) Kalau String, coba decode JSON
    if (data is String) {
      final s = data.trim();

      // kalau HTML / teks biasa
      if (!s.startsWith('{') && !s.startsWith('[')) {
        return {
          'success': false,
          'message': s.isEmpty ? 'Response kosong dari server' : s,
        };
      }

      try {
        final decoded = jsonDecode(s);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
        return {
          'success': true,
          'data': decoded,
        };
      } catch (_) {
        return {
          'success': false,
          'message': 'Response String tapi bukan JSON valid',
          'raw': s,
        };
      }
    }

    // 3) Tipe lain
    return {
      'success': false,
      'message': 'Format response tidak didukung',
      'raw': data,
    };
  }

  Future<Map<String, dynamic>> register({
    required String name,
    String? phone,
    String? email,
    required String password,
    required String passwordConfirmation,
    required bool agreeTerms,
  }) async {
    final response = await _dio.post(
      '/register.php',
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'agree_terms': agreeTerms,
      },
      options: Options(
        responseType: ResponseType.plain, // ✅ biar aman kalau server balas string
        contentType: Headers.jsonContentType,
      ),
    );

    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> login({
    required String login,
    required String password,
  }) async {
    final response = await _dio.post(
      '/login.php',
      data: {
        'login': login,
        'password': password,
      },
      options: Options(
        responseType: ResponseType.plain, // ✅ biar aman kalau server balas string
        contentType: Headers.jsonContentType,
      ),
    );

    return _asMap(response.data);
  }
}