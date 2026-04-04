import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

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
  }

  @override
  Widget build(BuildContext context) {
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
