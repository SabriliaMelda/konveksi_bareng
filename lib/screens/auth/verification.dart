<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/pages/home.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _otp1C = TextEditingController();
  final TextEditingController _otp2C = TextEditingController();
  final TextEditingController _otp3C = TextEditingController();
  final TextEditingController _otp4C = TextEditingController();

  final FocusNode _otp1F = FocusNode();
  final FocusNode _otp2F = FocusNode();
  final FocusNode _otp3F = FocusNode();
  final FocusNode _otp4F = FocusNode();

  @override
  void dispose() {
    _otp1C.dispose();
    _otp2C.dispose();
    _otp3C.dispose();
    _otp4C.dispose();

    _otp1F.dispose();
    _otp2F.dispose();
    _otp3F.dispose();
    _otp4F.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  void _onOtpChanged({
    required String value,
    required FocusNode currentFocus,
    FocusNode? nextFocus,
    FocusNode? previousFocus,
  }) {
    if (value.isNotEmpty) {
      currentFocus.unfocus();
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
      }
    } else {
      if (previousFocus != null) {
        FocusScope.of(context).requestFocus(previousFocus);
      }
    }
  }

  void _resendCode() {
    _toast('Kode verifikasi berhasil dikirim ulang.');
  }

  Future<void> _verify() async {
    final code = _otp1C.text + _otp2C.text + _otp3C.text + _otp4C.text;

    if (code.length < 4) {
      _toast('Masukkan kode verifikasi 4 digit.');
      return;
    }

    // Simulate verification delay
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 400));

    _toast('Verifikasi berhasil.');

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
=======
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/auth_background.dart';
import '../main/home.dart';
import 'login.dart';
import 'security_screen.dart';

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
  String _mode = 'login'; // 'login' or 'register'
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
    _loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  Future<void> _loadData() async {
    final email = await StorageService.getItem('pending_email');
    final mode = await StorageService.getItem('pending_mode');
    if (email == null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }
    setState(() {
      _email = email ?? '';
      _mode = mode ?? 'login';
    });
  }

  Future<Map<String, dynamic>?> _getDeviceInfo() async {
    if (kIsWeb) return null;
    final plugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      return {
        'deviceName': '${info.brand} ${info.model}',
        'deviceType': info.isPhysicalDevice ? 'Phone' : 'Emulator',
        'osName': 'Android',
        'osVersion': info.version.release,
      };
    } else if (Platform.isIOS) {
      final info = await plugin.iosInfo;
      return {
        'deviceName': info.name,
        'deviceType': info.isPhysicalDevice ? 'Phone' : 'Simulator',
        'osName': 'iOS',
        'osVersion': info.systemVersion,
      };
    }
    return null;
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
      if (_mode == 'register') {
        final result = await AuthService.resendRegisterOtp(_email);
        setState(() {
          if (!result.ok) {
            _error = result.statusCode == 429
                ? t['resendWait']!
                : (result.message ?? t['errorNetwork']!);
          } else {
            _info = t['resendInfo']!;
          }
        });
      } else {
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
      }
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
      if (_mode == 'register') {
        final result = await AuthService.verifyRegisterOtp(
            email: _email, otp: _code);
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
        // Simpan email untuk security screen
        await StorageService.setItem('security_email', _email);
        await StorageService.deleteItem('pending_email');
        await StorageService.deleteItem('pending_mode');
        if (mounted) {
          setState(() => _loading = false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SecurityScreen()),
          );
        }
      } else {
        final deviceInfo = await _getDeviceInfo();
        final result =
            await AuthService.verifyOtp(email: _email, otp: _code, deviceInfo: deviceInfo);
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
        await StorageService.deleteItem('pending_mode');
        if (mounted) {
          setState(() => _loading = false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
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
>>>>>>> db0fead1bdd8415c3e0d6567f9ffcc9446bff833
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final media = MediaQuery.of(context);
    final size = media.size;

    final cardWidth = size.width < 380 ? size.width * 0.85 : 340.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F8),
      body: Stack(
        children: [
          const Positioned.fill(
            child: _PatternBackground(),
          ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: 18,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF3B3B3B),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 70,
                      bottom: 20,
                    ),
                    child: Container(
                      width: cardWidth,
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFDFD),
                        border: Border.all(
                          color: const Color(0xFFD7D7D7),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _LogoHeader(),
                          const SizedBox(height: 20),
                          const Text(
                            'Kode Verifikasi',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF6B257F),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Email yang berisi kode verifikasi baru saja\n'
                            'dikirim ke alamat@gmail.com',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF7B4E88),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _OtpBox(
                                  controller: _otp1C,
                                  focusNode: _otp1F,
                                  onChanged: (value) => _onOtpChanged(
                                    value: value,
                                    currentFocus: _otp1F,
                                    nextFocus: _otp2F,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _OtpBox(
                                  controller: _otp2C,
                                  focusNode: _otp2F,
                                  onChanged: (value) => _onOtpChanged(
                                    value: value,
                                    currentFocus: _otp2F,
                                    nextFocus: _otp3F,
                                    previousFocus: _otp1F,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _OtpBox(
                                  controller: _otp3C,
                                  focusNode: _otp3F,
                                  onChanged: (value) => _onOtpChanged(
                                    value: value,
                                    currentFocus: _otp3F,
                                    nextFocus: _otp4F,
                                    previousFocus: _otp2F,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _OtpBox(
                                  controller: _otp4C,
                                  focusNode: _otp4F,
                                  onChanged: (value) => _onOtpChanged(
                                    value: value,
                                    currentFocus: _otp4F,
                                    previousFocus: _otp3F,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: _resendCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF742C92),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Resend Code',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: _verify,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Verifikasi',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: const [
                              _CountryChip(),
                              Spacer(),
                              _FooterLink(text: 'Bantuan'),
                            ],
                          ),
                          const SizedBox(height: 62),
                          const Center(
                            child: Text(
                              '© Copyrights BOMA | All Rights Reserved',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF8F8F8F),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
=======
    return AuthBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthLogo(),
          const SizedBox(height: 20),
          Text(t['title']!,
              style: const TextStyle(
                  color: kPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.2)),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: '${t['subtitle']!} ',
              style: const TextStyle(
                  color: kPurpleLight,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  height: 1.45),
              children: [
                TextSpan(
                  text: _maskEmail(_email),
                  style: const TextStyle(fontWeight: FontWeight.w700),
>>>>>>> db0fead1bdd8415c3e0d6567f9ffcc9446bff833
                ),
              ],
            ),
          ),
<<<<<<< HEAD
=======
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
>>>>>>> db0fead1bdd8415c3e0d6567f9ffcc9446bff833
        ],
      ),
    );
  }
}
<<<<<<< HEAD

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 54,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF2A2A2A),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: Color(0xFF4A4A4A),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: Color(0xFF4A4A4A),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: Color(0xFF6B257F),
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo1.png',
      width: 120,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.accessibility_new_rounded,
              color: Color(0xFF6B257F),
              size: 34,
            ),
            SizedBox(width: 8),
            Text(
              'KONVEKSI\nBARENG',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF6B257F),
                fontSize: 13,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CountryChip extends StatefulWidget {
  const _CountryChip();

  @override
  State<_CountryChip> createState() => _CountryChipState();
}

class _CountryChipState extends State<_CountryChip> {
  String _selected = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (v) => setState(() => _selected = v),
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (_) => const [
        PopupMenuItem(
            value: 'Indonesia',
            child: Text('Indonesia', style: TextStyle(fontFamily: 'Poppins'))),
        PopupMenuItem(
            value: 'English',
            child: Text('English', style: TextStyle(fontFamily: 'Poppins'))),
      ],
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFB88BC5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selected,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF6B257F),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: Color(0xFF6B257F),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;

  const _FooterLink({required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF6B257F),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PatternBackground extends StatelessWidget {
  const _PatternBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F3F8),
      child: Opacity(
        opacity: 0.16,
        child: Image.asset(
          'assets/images/bg.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
=======
>>>>>>> db0fead1bdd8415c3e0d6567f9ffcc9446bff833
