import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/auth/find_account.dart';
import 'package:konveksi_bareng/screens/auth/register.dart';
import 'package:konveksi_bareng/screens/auth/verification.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _loginC = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _loginC.dispose();
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

  Future<void> _doLogin() async {
    final value = _loginC.text.trim();

    if (value.isEmpty) {
      _toast('Email atau nomor telepon wajib diisi.');
      return;
    }

    if (!_isEmail(value) && !_isPhone(value)) {
      _toast('Masukkan email atau nomor telepon yang valid.');
      return;
    }

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const VerificationPage()),
    );

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final bottomInset = media.viewInsets.bottom;

    // Make the login card wider: use 85% of the screen on small devices,
    // and a 340px fixed width on larger screens for better readability.
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
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
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
                          const SizedBox(height: 15),
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF6B257F),
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Buat akun untuk akses promo eksklusif\n'
                            'dan penawaran terbaik setiap hari.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF7B4E88),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            height: 46,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFBEB6C2),
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _loginC,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF2A2A2A),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email atau nomor telepon',
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFAAA3AF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                isDense: true,
                              ),
                              onSubmitted: (_) {
                                if (!_loading) _doLogin();
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const FindAccountPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Lupa email?',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF6B257F),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Buat Akun',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF6B257F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _doLogin,
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
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Berikutnya',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: const [
                              _CountryChip(),
                              Spacer(),
                              _FooterLink(text: 'Bantuan'),
                            ],
                          ),
                          const SizedBox(height: 54),
                          const Center(
                            child: Text(
                              '© Copyrights BOMA | All Rights Reserved',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF8F8F8F),
                                fontSize: 10.5,
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
        ],
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader();

  @override
  Widget build(BuildContext context) {
    // Shift the logo slightly left so it visually lines up with the "Login" text
    // below the logo.
    return Transform.translate(
      offset: const Offset(-10, 0),
      child: Image.asset(
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
                size: 10,
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
      ),
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
          color: Color(0xFF6B257F),
          fontSize: 12,
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
