import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/biometric_service.dart';
import '../../services/storage_service.dart';

class BiometricLockScreen extends StatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  bool _busy = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prompt());
  }

  Future<void> _prompt() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = '';
    });
    final ok = await BiometricService.authenticate(
      reason: 'Autentikasi untuk masuk Konveksi Bareng',
    );
    if (!mounted) return;
    if (ok) {
      await BiometricService.markUnlocked();
      if (!mounted) return;
      context.go('/home');
    } else {
      setState(() {
        _busy = false;
        _error = 'Autentikasi gagal atau dibatalkan.';
      });
    }
  }

  Future<void> _manualLogin() async {
    final token = await StorageService.getItem('auth_token');
    if (token != null) {
      await AuthService.logout(token);
    }
    await StorageService.deleteItem('auth_token');
    await BiometricService.clearUnlock();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6B257F);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF3E8FF),
                  border: Border.all(color: purple.withValues(alpha: 0.2)),
                ),
                child: const Icon(Icons.fingerprint_rounded,
                    color: purple, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                'Buka Konveksi Bareng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Gunakan sidik jari untuk melanjutkan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  _error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: _busy ? null : _prompt,
                  icon: const Icon(Icons.fingerprint_rounded, size: 20),
                  label: Text(_busy ? 'Memproses...' : 'Coba lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        purple.withValues(alpha: 0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: _busy ? null : _manualLogin,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: purple, width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Login dengan akun lain',
                    style: TextStyle(
                      color: purple,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
