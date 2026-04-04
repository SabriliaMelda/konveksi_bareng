import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_background.dart';
import 'login.dart';

const _strings = {
  'id': {
    'title': 'Buat Akun',
    'subtitle': 'Bergabung bersama kami hari ini',
    'errorFill': 'Harap isi semua kolom.',
    'errorPhone': 'Nomor telepon tidak valid.',
    'labelName': 'Nama Lengkap',
    'labelPhone': 'Nomor Telepon',
    'labelEmail': 'Alamat Email',
    'creating': 'Membuat akun...',
    'create': 'Berikutnya',
    'alreadyHave': 'Sudah punya akun? ',
    'signIn': 'Masuk',
    'help': 'Bantuan',
    'successTitle': 'Akun berhasil dibuat!',
    'successSubtitle': 'Akun Anda telah berhasil dibuat.',
    'goToLogin': 'Masuk ke Login',
    'errorServer': 'Tidak dapat terhubung ke server.',
  },
  'en': {
    'title': 'Create Account',
    'subtitle': 'Join us today',
    'errorFill': 'Please fill in all fields.',
    'errorPhone': 'Invalid phone number.',
    'labelName': 'Full name',
    'labelPhone': 'Phone number',
    'labelEmail': 'Email address',
    'creating': 'Creating account...',
    'create': 'Next',
    'alreadyHave': 'Already have an account? ',
    'signIn': 'Sign in',
    'help': 'Help',
    'successTitle': 'Account created!',
    'successSubtitle': 'Your account has been successfully created.',
    'goToLogin': 'Go to Login',
    'errorServer': 'Cannot connect to server.',
  },
};

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _lang = 'id';
  String _error = '';
  bool _loading = false;
  bool _success = false;

  Map<String, String> get t => _strings[_lang]!;

  Future<void> _handleSubmit() async {
    if (_nameCtrl.text.isEmpty ||
        _phoneCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty) {
      setState(() => _error = t['errorFill']!);
      return;
    }
    if (!RegExp(r'^[0-9]{8,15}$').hasMatch(_phoneCtrl.text)) {
      setState(() => _error = t['errorPhone']!);
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final result = await AuthService.register(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
      );
      if (!result.ok) {
        setState(() => _error = result.message ?? 'Gagal membuat akun');
      } else {
        setState(() => _success = true);
      }
    } catch (_) {
      setState(() => _error = t['errorServer']!);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_success) {
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
                child: Text('\u2713',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 20),
            Text(t['successTitle']!,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: kPurple)),
            const SizedBox(height: 4),
            Text(t['successSubtitle']!,
                style: const TextStyle(
                    fontSize: 12,
                    color: kPurpleLight)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurpleButton,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(t['goToLogin']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      );
    }

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
                  height: 1.2)),
          const SizedBox(height: 10),
          Text(t['subtitle']!,
              style: const TextStyle(
                  color: kPurpleLight,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  height: 1.4)),
          const SizedBox(height: 18),

          // Error
          AuthErrorBox(message: _error),

          // Name
          _buildField(t['labelName']!, _nameCtrl, 'Muhammad Fathan',
              TextInputType.name),
          const SizedBox(height: 12),

          // Phone
          _buildField(t['labelPhone']!, _phoneCtrl, '081234567890',
              TextInputType.phone,
              isPhone: true),
          const SizedBox(height: 12),

          // Email
          _buildField(t['labelEmail']!, _emailCtrl, 'you@example.com',
              TextInputType.emailAddress),
          const SizedBox(height: 16),

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
                _loading ? t['creating']! : t['create']!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Footer link
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: Text.rich(
                TextSpan(
                  text: t['alreadyHave']!,
                  style: const TextStyle(
                      color: kPurple,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                  children: [
                    TextSpan(
                      text: t['signIn']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
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

  Widget _buildField(
    String label,
    TextEditingController controller,
    String placeholder,
    TextInputType keyboardType, {
    bool isPhone = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: kPurple,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFBEB6C2), width: 1),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: isPhone ? 15 : null,
            onChanged: isPhone
                ? (v) {
                    final cleaned = v.replaceAll(RegExp(r'[^0-9]'), '');
                    if (cleaned != v) controller.text = cleaned;
                    setState(() => _error = '');
                  }
                : (_) => setState(() => _error = ''),
            style: const TextStyle(
                color: Color(0xFF2A2A2A),
                fontSize: 12,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: const TextStyle(
                  color: Color(0xFFB3B0B7),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
