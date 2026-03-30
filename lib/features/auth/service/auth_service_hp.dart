import 'package:dio/dio.dart';

class AuthServiceHp {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.237', // IP LAPTOP kamu
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
