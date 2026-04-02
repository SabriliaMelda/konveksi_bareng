import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class AuthServiceEmu {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: kIsWeb
          ? 'http://localhost:8080'
          : 'http://10.0.2.2:8080', // localhost for web, 10.0.2.2 for Android emulator
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> register({
    required String name,
    String? phone,
    String? email,
    required String password,
    required String passwordConfirmation,
    required bool agreeTerms,
  }) async {
    final res = await _dio.post(
      '/register.php',
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'agree_terms': agreeTerms,
      },
    );
    return Map<String, dynamic>.from(res.data);
  }
}
