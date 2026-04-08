import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:konveksi_bareng/screens/auth/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _phoneC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _nameC.dispose();
    _phoneC.dispose();
    _emailC.dispose();
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

  bool _isEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
  }

  bool _isPhone(String value) {
    final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
    return clean.length >= 9;
  }

  Future<void> _submit() async {
    final name = _nameC.text.trim();
    final phone = _phoneC.text.trim();
    final email = _emailC.text.trim();

    if (name.isEmpty) {
      _toast('Nama lengkap wajib diisi.');
      return;
    }

    if (phone.isEmpty) {
      _toast('Nomor telepon wajib diisi.');
      return;
    }

    if (!_isPhone(phone)) {
      _toast('Nomor telepon tidak valid.');
      return;
    }

    if (email.isEmpty) {
      _toast('Alamat email wajib diisi.');
      return;
    }

    if (!_isEmail(email)) {
      _toast('Format email tidak valid.');
      return;
    }

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    _toast('Pendaftaran berhasil.');

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final bottomInset = media.viewInsets.bottom;

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
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 70,
                      bottom: 20 + bottomInset,
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
                          const SizedBox(height: 18),
                          const Text(
                            'Buat Akun',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF6B257F),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Bergabung bersama kami hari ini',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF7B4E88),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const _FieldLabel(text: 'Nama Lengkap'),
                          const SizedBox(height: 6),
                          _buildInputField(
                            controller: _nameC,
                            hintText: 'Boma Digital',
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 12),
                          const _FieldLabel(text: 'Nomor Telepon'),
                          const SizedBox(height: 6),
                          _buildInputField(
                            controller: _phoneC,
                            hintText: '0879687546353',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 12),
                          const _FieldLabel(text: 'Alamat Email'),
                          const SizedBox(height: 6),
                          _buildInputField(
                            controller: _emailC,
                            hintText: 'bomadigital@gmail.com',
                            keyboardType: TextInputType.emailAddress,
                            onSubmitted: (_) {
                              if (!_loading) _submit();
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 38,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF742C92),
                                disabledBackgroundColor:
                                    const Color(0xFF742C92).withOpacity(0.7),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Berikutnya',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Login(),
                                  ),
                                );
                              },
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Sudah punya akun? ',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF6B257F),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Masuk',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF6B257F),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
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
                          const SizedBox(height: 52),
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
                ),
              ],
            ),
          ),
=======
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/auth_background.dart';
import 'login.dart';
import 'verification.dart';

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
        // Simpan email dan mode untuk verification screen
        await StorageService.setItem(
            'pending_email', _emailCtrl.text.toLowerCase().trim());
        await StorageService.setItem('pending_mode', 'register');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const VerificationScreen()),
          );
        }
        return;
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
>>>>>>> db0fead1bdd8415c3e0d6567f9ffcc9446bff833
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    ValueChanged<String>? onSubmitted,
  }) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFBEB6C2),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onSubmitted: onSubmitted,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF2A2A2A),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFFB3B0B7),
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
          isDense: true,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        color: Color(0xFF6B257F),
        fontSize: 12,
        fontWeight: FontWeight.w600,
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
=======
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
>>>>>>> db0fead1bdd8415c3e0d6567f9ffcc9446bff833
    );
  }
}
