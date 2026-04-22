import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  BiometricService._();

  static const _prefKey = 'biometric_enabled';
  static const _unlockedAtKey = 'biometric_unlocked_at';
  static const _pausedAtKey = 'biometric_paused_at';

  /// Grace period: kalau user di-background kurang dari ini, tidak perlu
  /// biometrik ulang saat resume. Mirip Livin/BCA (~5 menit).
  static const Duration unlockGrace = Duration(minutes: 5);

  static final LocalAuthentication _auth = LocalAuthentication();

  /// Device punya hardware biometrik & user sudah daftar minimal 1 sidik jari/face.
  static Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;
      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return false;
      final available = await _auth.getAvailableBiometrics();
      return available.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  /// Munculkan prompt biometrik native OS.
  /// Return true hanya kalau user berhasil autentikasi.
  static Future<bool> authenticate({
    String reason = 'Autentikasi untuk masuk Konveksi Bareng',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Masuk dengan biometrik',
            biometricHint: 'Verifikasi identitas Anda',
            cancelButton: 'Batal',
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? false;
  }

  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);
    if (!value) {
      await prefs.remove(_unlockedAtKey);
      await prefs.remove(_pausedAtKey);
    }
  }

  /// Tandai session ini sudah ter-unlock via biometrik.
  static Future<void> markUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _unlockedAtKey, DateTime.now().millisecondsSinceEpoch);
    await prefs.remove(_pausedAtKey);
  }

  /// Paksa lock di redirect berikutnya.
  static Future<void> clearUnlock() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_unlockedAtKey);
  }

  /// Dipanggil saat app masuk background.
  static Future<void> markPaused() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _pausedAtKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Dipanggil saat app resume. Return true kalau harus minta biometrik
  /// ulang karena gap di background > [unlockGrace].
  static Future<bool> shouldLockOnResume() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_prefKey) ?? false)) return false;
    final pausedAt = prefs.getInt(_pausedAtKey);
    if (pausedAt == null) return false;
    final gap = DateTime.now().millisecondsSinceEpoch - pausedAt;
    return gap >= unlockGrace.inMilliseconds;
  }

  /// Cek saat redirect router: apakah perlu ke lock screen?
  /// True jika biometrik ON dan session belum ter-unlock (atau sudah expired).
  static Future<bool> needsUnlock() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_prefKey) ?? false)) return false;
    final unlockedAt = prefs.getInt(_unlockedAtKey);
    if (unlockedAt == null) return true;
    return false;
  }
}
