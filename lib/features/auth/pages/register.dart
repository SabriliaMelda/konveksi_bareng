import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:konveksi_bareng/features/auth/service/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // toggle: true = telepon, false = email
  bool _usePhone = true;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agree = false;

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_isLoading) return;

    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan setujui syarat dan ketentuan terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passController.text;
    final confirm = _confirmPassController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama wajib diisi')));
      return;
    }

    if (_usePhone && phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor telepon wajib diisi')),
      );
      return;
    }

    if (!_usePhone && email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email wajib diisi')));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 6 karakter')),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak sama')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = AuthService();

      final res = await auth.register(
        name: name,
        phone: _usePhone ? phone : null,
        email: _usePhone ? null : email,
        password: password,
        passwordConfirmation: confirm,
        agreeTerms: _agree,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Register berhasil')),
      );

      if (mounted) Navigator.pop(context); // balik ke login
    } on DioException catch (e) {
      String msg = 'Gagal register';

      final data = e.response?.data;

      // Laravel validation 422: { message, errors: {field: [msg]} }
      if (data is Map && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        if (errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final firstMsg = (errors[firstKey] as List).first.toString();
          msg = firstMsg;
        }
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Terjadi kesalahan server')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // ===== BACK BUTTON =====
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          child: Container(
                            width: 41,
                            height: 41,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xFFE8ECF4),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Color(0xFF1E232C),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ===== TITLE =====
                        const SizedBox(
                          width: 331,
                          child: Text(
                            'Hello! Register to get started',
                            style: TextStyle(
                              color: Color(0xFF1E232C),
                              fontSize: 30,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ===== NAMA LENGKAP =====
                        _inputField(
                          controller: _nameController,
                          hint: 'Nama Lengkap',
                        ),

                        const SizedBox(height: 16),

                        // ===== TELEPON / EMAIL (TOGGLE) =====
                        _usePhone
                            ? _phoneField(
                                controller: _phoneController,
                                hint: '081xxxxxxxx',
                              )
                            : _inputField(
                                controller: _emailController,
                                hint: 'johndoe@contoh.com',
                                keyboardType: TextInputType.emailAddress,
                              ),

                        const SizedBox(height: 6),

                        // ===== TOGGLE TEXT (CLICKABLE) =====
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () => setState(() => _usePhone = !_usePhone),
                          child: Text(
                            _usePhone
                                ? '*Gunakan Email Sebagai Gantinya'
                                : '*Gunakan Nomor Telepon Sebagai Gantinya',
                            style: const TextStyle(
                              color: Color(0xFF6B257F),
                              fontSize: 12,
                              fontFamily: 'Urbanist',
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== KATA SANDI =====
                        _inputField(
                          controller: _passController,
                          hint: 'Kata sandi',
                          isPassword: true,
                          obscure: _obscurePass,
                          onToggleObscure: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),

                        const SizedBox(height: 6),
                        const Text(
                          'Kata sandi harus mengandung setidaknya 6 digit',
                          style: TextStyle(
                            color: Color(0xFF6A707C),
                            fontSize: 12,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== KONFIRMASI KATA SANDI =====
                        _inputField(
                          controller: _confirmPassController,
                          hint: 'Konfirmasi Kata Sandi',
                          isPassword: true,
                          obscure: _obscureConfirm,
                          onToggleObscure: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== CHECKBOX TERMS =====
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _agree,
                              activeColor: const Color(0xFF6B257F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: _isLoading
                                  ? null
                                  : (val) =>
                                        setState(() => _agree = val ?? false),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Color(0xFF1E232C),
                                    fontSize: 13,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text:
                                          'Dengan mendaftar, Anda menyetujui ketentuan berikut: ',
                                    ),
                                    TextSpan(
                                      text: 'syarat dan Ketentuan',
                                      style: const TextStyle(
                                        color: Color(0xFF6B257F),
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // TODO: buka halaman S&K
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ===== BUTTON REGISTER =====
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C2580),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _isLoading ? null : _handleRegister,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ===== OR REGISTER WITH =====
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xFFE8ECF4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Or Register with',
                              style: TextStyle(
                                color: Color(0xFF6A707C),
                                fontSize: 14,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xFFE8ECF4),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ===== SOCIAL BUTTONS =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _socialButton('assets/images/facebook.png'),
                            _socialButton('assets/images/google.png'),
                            _socialButton('assets/images/instagram.png'),
                          ],
                        ),

                        // push bottom safely
                        const Expanded(child: SizedBox()),

                        // ===== BOTTOM TEXT: LOGIN NOW =====
                        Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(
                                    color: Color(0xFF1E232C),
                                    fontSize: 15,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Login Now',
                                  style: const TextStyle(
                                    color: Color(0xFF6B257F),
                                    fontSize: 15,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                    letterSpacing: 0.15,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (!_isLoading) Navigator.pop(context);
                                    },
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===== INPUT FIELD (DESAIN TETAP) =====
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: const Color(0xFFE8ECF4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: isPassword ? obscure : false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF8390A1),
                  fontSize: 15,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF1E232C),
                fontSize: 15,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isPassword)
            GestureDetector(
              onTap: onToggleObscure,
              child: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: const Color(0xFF6A707C),
              ),
            ),
        ],
      ),
    );
  }

  // ===== PHONE FIELD (ADA +62 & SEPARATOR, STYLE TETAP) =====
  Widget _phoneField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: const Color(0xFFE8ECF4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          const Text(
            '+62',
            style: TextStyle(
              color: Color(0xFF1E232C),
              fontSize: 15,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Container(width: 1, height: 22, color: const Color(0xFFE8ECF4)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF8390A1),
                  fontSize: 15,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF1E232C),
                fontSize: 15,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== TOMBOL SOSMED =====
  Widget _socialButton(String assetPath) {
    return Container(
      width: 105,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: const Color(0xFFE8ECF4)),
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: 26,
          height: 26,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
