import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/auth_background.dart';

const _strings = {
  'id': {
    'title': 'Temukan Akun Anda',
    'subtitle':
        'Cari Akun Anda. Demi keamanan, silakan masukkan alamat email yang tertaut dengan akun ini.',
    'error': 'Harap isi alamat email.',
    'errorInvalid': 'Harap isi alamat email yang valid.',
    'placeholder': 'Alamat email',
    'searching': 'Mencari...',
    'next': 'Berikutnya',
    'help': 'Bantuan',
    'errorServer': 'Tidak dapat terhubung ke server.',
  },
  'en': {
    'title': 'Find Your Account',
    'subtitle':
        'Search for your account. For security, please enter the email address associated with this account.',
    'error': 'Please enter your email address.',
    'errorInvalid': 'Please enter a valid email address.',
    'placeholder': 'Email address',
    'searching': 'Searching...',
    'next': 'Next',
    'help': 'Help',
    'errorServer': 'Cannot connect to server.',
  },
};

final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

class FindAccountScreen extends StatefulWidget {
  const FindAccountScreen({super.key});

  @override
  State<FindAccountScreen> createState() => _FindAccountScreenState();
}

class _FindAccountScreenState extends State<FindAccountScreen> {
  final _controller = TextEditingController();
  String _lang = 'id';
  String _error = '';
  bool _loading = false;

  Map<String, String> get t => _strings[_lang]!;

  Future<void> _handleSubmit() async {
    final email = _controller.text.trim().toLowerCase();
    if (email.isEmpty) {
      setState(() => _error = t['error']!);
      return;
    }
    if (!_emailRegex.hasMatch(email)) {
      setState(() => _error = t['errorInvalid']!);
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final result = await AuthService.getSecurityQuestions(email);
      if (!result.ok) {
        setState(() => _error = result.message ?? 'Akun tidak ditemukan');
      } else {
        await StorageService.setItem('recovery_email', email);
        if (mounted) {
          context.push('/account');
        }
      }
    } catch (_) {
      setState(() => _error = t['errorServer']!);
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
          const SizedBox(height: 18),
          Text(t['title']!,
              style: const TextStyle(
                  color: kPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.22)),
          const SizedBox(height: 12),
          Text(t['subtitle']!,
              style: const TextStyle(
                  color: kPurpleLight,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  height: 1.45)),
          const SizedBox(height: 14),

          // Error
          AuthErrorBox(message: _error),

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
              textCapitalization: TextCapitalization.none,
              onChanged: (_) => setState(() => _error = ''),
              onSubmitted: (_) {
                if (!_loading) _handleSubmit();
              },
              style: const TextStyle(
                  color: Color(0xFF2A2A2A),
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: t['placeholder'],
                hintStyle: const TextStyle(
                    color: Color(0xFFAAA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Submit
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurpleButton,
                disabledBackgroundColor: kPurpleButton.withValues(alpha: 0.7),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                _loading ? t['searching']! : t['next']!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
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
            }),
            helpLabel: t['help']!,
          ),
        ],
      ),
    );
  }
}
