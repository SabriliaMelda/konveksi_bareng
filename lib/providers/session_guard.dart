import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

/// Polls /auth/me every 15 seconds.
/// If 401 -> clears token and calls [onExpired].
/// Skipped entirely when DEV_AUTH_BYPASS=TRUE in .env.
class SessionGuard {
  Timer? _timer;
  VoidCallback? onSessionExpired;

  static bool get _bypass =>
      dotenv.env['DEV_AUTH_BYPASS']?.toUpperCase() == 'TRUE';

  void start({required VoidCallback onExpired}) {
    if (_bypass) return; // skip in dev
    onSessionExpired = onExpired;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _check());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _check() async {
    try {
      final token = await StorageService.getItem('auth_token');
      if (token == null) {
        onSessionExpired?.call();
        return;
      }
      final status = await AuthService.checkSession(token);
      if (status == 401) {
        await StorageService.deleteItem('auth_token');
        onSessionExpired?.call();
      }
    } catch (_) {
      // Network error - don't redirect, might be temporarily offline
    }
  }
}
