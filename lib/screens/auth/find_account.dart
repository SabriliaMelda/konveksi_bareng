import 'package:flutter/material.dart';
import '../../widgets/auth_background.dart';
import 'account_screen.dart';
import 'login.dart';

const _strings = {
  'id': {
    'title': 'Temukan Akun Anda',
    'subtitle':
        'Cari Akun Anda. Demi keamanan, silakan masukkan alamat email atau nomor telepon yang tertaut dengan akun ini.',
    'error': 'Harap isi email atau nomor telepon.',
    'errorInvalid': 'Harap isi email atau nomor telepon yang valid.',
    'placeholder': 'Email atau nomor telepon',
    'searching': 'Mencari...',
    'next': 'Berikutnya',
    'help': 'Bantuan',
    'sentTitle': 'Cek email Anda',
    'sentSubtitle': 'Kami mengirimkan tautan verifikasi ke',
    'sentCheck': 'Cek inbox Anda dan ikuti instruksinya.',
    'sentNoReceive': 'Tidak menerima? ',
    'sentTryAgain': 'Coba lagi',
    'sentBack': 'Kembali ke Login',
  },
  'en': {
    'title': 'Find Your Account',
    'subtitle':
        'Search for your account. For security, please enter the email address or phone number associated with this account.',
    'error': 'Please enter your email or phone number.',
    'errorInvalid': 'Please enter a valid email or phone number.',
    'placeholder': 'Email or phone number',
    'searching': 'Searching...',
    'next': 'Next',
    'help': 'Help',
    'sentTitle': 'Check your email',
    'sentSubtitle': 'We sent a verification link to',
    'sentCheck': 'Check your inbox and follow the instructions.',
    'sentNoReceive': "Didn't receive it? ",
    'sentTryAgain': 'Try again',
    'sentBack': 'Back to Login',
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
  bool _sent = false;

  Map<String, String> get t => _strings[_lang]!;

  void _handleSubmit() {
    if (_controller.text.isEmpty) {
      setState(() => _error = t['error']!);
      return;
    }
    if (!_emailRegex.hasMatch(_controller.text)) {
      setState(() => _error = t['errorInvalid']!);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AccountScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sent confirmation state
    if (_sent) {
      return AuthBackground(
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('\u2709',
                    style: TextStyle(color: Colors.white, fontSize: 28)),
              ),
            ),
            const SizedBox(height: 20),
            Text(t['sentTitle']!,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: kPurple)),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: '${t['sentSubtitle']!} ',
                style: const TextStyle(
                    fontSize: 12,
                    color: kPurpleLight,
                    height: 1.45),
                children: [
                  TextSpan(
                    text: _controller.text,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: '.\n${t['sentCheck']!}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t['sentNoReceive']!,
                    style: const TextStyle(
                        fontSize: 12,
                        color: kPurple)),
                GestureDetector(
                  onTap: () => setState(() {
                    _sent = false;
                    _controller.clear();
                    _error = '';
                  }),
                  child: Text(t['sentTryAgain']!,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF667EEA),
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: const BorderSide(color: kPurple, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(t['sentBack']!,
                    style: const TextStyle(
                        color: kPurple,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      );
    }

    // Search form state
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
                disabledBackgroundColor: kPurpleButton.withOpacity(0.7),
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
