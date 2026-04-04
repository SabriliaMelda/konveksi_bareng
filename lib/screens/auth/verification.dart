import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/auth_background.dart';
import '../main/home.dart';
import 'login.dart';

const _strings = {
  'id': {
    'title': 'Kode Verifikasi',
    'subtitle': 'Email yang berisi kode verifikasi baru saja dikirim ke',
    'errorDigits': 'Masukkan 4 digit kode verifikasi.',
    'errorOtp': 'Kode OTP salah. Silakan coba lagi.',
    'errorExpired': 'Kode OTP kadaluarsa. Minta kode baru.',
    'errorTooMany': 'Terlalu banyak percobaan. Minta kode baru.',
    'errorNetwork': 'Gagal terhubung ke server. Coba lagi.',
    'resendWait': 'Tunggu 1 menit sebelum minta OTP baru.',
    'resendInfo': 'Kode baru sudah dikirim. Cek inbox/spam.',
    'processing': 'Memproses...',
    'resend': 'Kirim Ulang Kode',
    'verify': 'Verifikasi',
    'help': 'Bantuan',
  },
  'en': {
    'title': 'Verification Code',
    'subtitle': 'An email containing a verification code has just been sent to',
    'errorDigits': 'Enter the 4-digit verification code.',
    'errorOtp': 'Incorrect OTP code. Please try again.',
    'errorExpired': 'OTP code expired. Request a new code.',
    'errorTooMany': 'Too many attempts. Request a new code.',
    'errorNetwork': 'Failed to connect to server. Try again.',
    'resendWait': 'Wait 1 minute before requesting a new OTP.',
    'resendInfo': 'New code sent. Check your inbox/spam.',
    'processing': 'Processing...',
    'resend': 'Resend Code',
    'verify': 'Verify',
    'help': 'Help',
  },
};

String _maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2 || parts[0].length <= 2) return email;
  final local = parts[0];
  return '${local.substring(0, 2)}${'*' * (local.length - 2)}@${parts[1]}';
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String _email = '';
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  String _info = '';
  String _error = '';
  bool _loading = false;
  String _lang = 'id';

  Map<String, String> get t => _strings[_lang]!;

  @override
  void initState() {
    super.initState();
    _loadEmail();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  Future<void> _loadEmail() async {
    final email = await StorageService.getItem('pending_email');
    if (email == null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }
    setState(() => _email = email ?? '');
  }

  String get _code => _otpControllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    setState(() {
      _error = '';
      _info = '';
    });
    final v = value.replaceAll(RegExp(r'\D'), '');

    // Paste support
    if (v.length > 1) {
      final chars = v.substring(0, v.length.clamp(0, 4)).split('');
      for (var i = 0; i < 4; i++) {
        _otpControllers[i].text = i < chars.length ? chars[i] : '';
      }
      if (chars.length >= 4) {
        _focusNodes[3].unfocus();
      } else {
        _focusNodes[chars.length].requestFocus();
      }
      return;
    }

    _otpControllers[index].text = v;
    if (v.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_otpControllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  Future<void> _handleResend() async {
    setState(() {
      _error = '';
      _info = '';
      _loading = true;
    });
    try {
      final result = await AuthService.requestOtp(_email);
      setState(() {
        if (!result.ok) {
          _error = result.statusCode == 429
              ? t['resendWait']!
              : (result.message ?? t['errorNetwork']!);
        } else {
          _info = t['resendInfo']!;
        }
      });
    } catch (_) {
      setState(() => _error = t['errorNetwork']!);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleVerify() async {
    if (_code.length < 4) {
      setState(() => _error = t['errorDigits']!);
      return;
    }
    setState(() => _loading = true);

    try {
      final result = await AuthService.verifyOtp(email: _email, otp: _code);
      if (!result.ok) {
        setState(() {
          if (result.statusCode == 429) {
            _error = t['errorTooMany']!;
          } else if (result.message?.contains('kadaluarsa') ?? false) {
            _error = t['errorExpired']!;
          } else {
            _error = t['errorOtp']!;
          }
        });
        if (mounted) setState(() => _loading = false);
        return;
      }
      if (result.token != null) {
        await StorageService.setItem('auth_token', result.token!);
      }
      await StorageService.deleteItem('pending_email');
      if (mounted) {
        setState(() => _loading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (_) {
      setState(() => _error = t['errorNetwork']!);
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthLogo(),
          const SizedBox(height: 20),
          Text(t['title']!,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: kPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.2)),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: '${t['subtitle']!} ',
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: kPurpleLight,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  height: 1.45),
              children: [
                TextSpan(
                  text: _maskEmail(_email),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Error / Info box
          AuthErrorBox(message: _error),
          AuthInfoBox(message: _info),

          const SizedBox(height: 22),

          // OTP boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Container(
                width: 48,
                height: 54,
                margin: EdgeInsets.only(left: i > 0 ? 12 : 0),
                child: KeyboardListener(
                  focusNode: FocusNode(),
                  onKeyEvent: (event) => _onKeyEvent(i, event),
                  child: TextField(
                    controller: _otpControllers[i],
                    focusNode: _focusNodes[i],
                    onChanged: (v) => _onOtpChanged(i, v),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF2A2A2A),
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                            color: Color(0xFF4A4A4A), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                            color: Color(0xFF4A4A4A), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide:
                            const BorderSide(color: kPurple, width: 1.2),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Resend button
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleResend,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurpleButton,
                disabledBackgroundColor: kPurpleButton.withOpacity(0.7),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                _loading ? t['processing']! : t['resend']!,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Verify button
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleVerify,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                disabledBackgroundColor:
                    const Color(0xFF4CAF50).withOpacity(0.7),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                t['verify']!,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),

          // Bottom bar
          AuthBottomBar(
            lang: _lang,
            onLangChanged: (code) => setState(() {
              _lang = code;
              _error = '';
              _info = '';
            }),
            helpLabel: t['help']!,
          ),
        ],
      ),
    );
  }
}
