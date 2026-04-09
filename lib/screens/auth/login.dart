import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/auth_background.dart';

const _strings = {
  'id': {
    'subtitle':
        'Buat akun untuk akses promo eksklusif dan penawaran terbaik setiap hari.',
    'error': 'Harap isi email atau nomor telepon.',
    'placeholder': 'Email atau nomor telepon',
    'forgotEmail': 'Lupa email?',
    'createAccount': 'Buat Akun',
    'errorEmail': 'Masukkan alamat email yang valid.',
    'errorNotRegistered': 'Email belum terdaftar.',
    'registerPrompt': ' Buat akun di sini.',
    'errorNetwork': 'Gagal terhubung ke server. Coba lagi.',
    'processing': 'Memproses...',
    'next': 'Berikutnya',
    'help': 'Bantuan',
  },
  'en': {
    'subtitle':
        'Create an account to access exclusive promos and the best deals every day.',
    'error': 'Please enter your email or phone number.',
    'placeholder': 'Email or phone number',
    'forgotEmail': 'Forgot email?',
    'createAccount': 'Create Account',
    'errorEmail': 'Enter a valid email address.',
    'errorNotRegistered': 'Email is not registered.',
    'registerPrompt': ' Create an account here.',
    'errorNetwork': 'Failed to connect to server. Try again.',
    'processing': 'Processing...',
    'next': 'Next',
    'help': 'Help',
  },
};

final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = TextEditingController();
  String _lang = 'id';
  String _errorMsg = '';
  bool _notRegistered = false;
  bool _loading = false;

  Map<String, String> get t => _strings[_lang]!;

  String? _validate() {
    if (_controller.text.isEmpty) return t['error'];
    if (!_emailRegex.hasMatch(_controller.text)) return t['errorEmail'];
    return null;
  }

  Future<void> _handleSubmit() async {
    final err = _validate();
    if (err != null) {
      setState(() {
        _errorMsg = err;
        _notRegistered = false;
      });
      return;
    }

    setState(() => _loading = true);
    try {
      final result = await AuthService.requestOtp(_controller.text);
      if (!result.ok) {
        setState(() {
          _errorMsg = result.statusCode == 404
              ? t['errorNotRegistered']!
              : (result.message ?? t['errorNetwork']!);
          _notRegistered = result.statusCode == 404;
        });
      } else {
        await StorageService.setItem('pending_email', _controller.text);
        if (mounted) {
          context.go('/verification');
        }
      }
    } catch (_) {
      setState(() {
        _errorMsg = t['errorNetwork']!;
        _notRegistered = false;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthLogo(),
          const SizedBox(height: 15),
          const Text(
            'Login',
            style: TextStyle(
              color: kPurple,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            t['subtitle']!,
            style: const TextStyle(
              color: kPurpleLight,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),

          // Error box
          AuthErrorBox(
            message: _errorMsg,
            extra: _notRegistered
                ? [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => context.push('/register'),
                        child: Text(
                          t['registerPrompt']!,
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ]
                : null,
          ),

          // Input
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBEB6C2), width: 1),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => setState(() => _errorMsg = ''),
              onSubmitted: (_) {
                if (!_loading) _handleSubmit();
              },
              style: const TextStyle(
                color: Color(0xFF2A2A2A),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: t['placeholder'],
                hintStyle: const TextStyle(
                  color: Color(0xFFAAA3AF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Links row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push('/find-account'),
                  child: Text(
                    t['forgotEmail']!,
                    style: const TextStyle(
                      color: kPurple,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/register'),
                child: Text(
                  t['createAccount']!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: kPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurpleButton,
                disabledBackgroundColor: kPurpleButton.withOpacity(0.7),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                _loading ? t['processing']! : t['next']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Bottom bar
          AuthBottomBar(
            lang: _lang,
            onLangChanged: (code) => setState(() {
              _lang = code;
              _errorMsg = '';
            }),
            helpLabel: t['help']!,
          ),
        ],
      ),
    );
  }
}
