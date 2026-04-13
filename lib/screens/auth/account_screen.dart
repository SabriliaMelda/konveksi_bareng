import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/auth_background.dart';

const _strings = {
  'id': {
    'title': 'Akun Ditemukan',
    'securityTitle': 'Jawab Pertanyaan Keamanan',
    'securitySubtitle': 'Buktikan bahwa ini akun Anda',
    'wrong': 'Bukan akun saya',
    'answer': 'Jawaban:',
    'verify': 'Verifikasi',
    'verifying': 'Memverifikasi...',
    'errorFill': 'Harap isi semua jawaban.',
    'errorServer': 'Tidak dapat terhubung ke server.',
    'help': 'Bantuan',
  },
  'en': {
    'title': 'Account Found',
    'securityTitle': 'Answer Security Questions',
    'securitySubtitle': 'Prove that this is your account',
    'wrong': 'Not my account',
    'answer': 'Answer:',
    'verify': 'Verify',
    'verifying': 'Verifying...',
    'errorFill': 'Please fill in all answers.',
    'errorServer': 'Cannot connect to server.',
    'help': 'Help',
  },
};

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _lang = 'id';
  String _error = '';
  bool _loading = false;
  bool _dataLoading = true;

  String _email = '';
  String _userName = '';
  String _userEmail = '';
  List<Map<String, dynamic>> _questions = [];

  final _answer1Ctrl = TextEditingController();
  final _answer2Ctrl = TextEditingController();

  Map<String, String> get t => _strings[_lang]!;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final email = await StorageService.getItem('recovery_email');
    if (email == null && mounted) {
      context.go('/find-account');
      return;
    }
    _email = email!;

    try {
      final result = await AuthService.getSecurityQuestions(_email);
      if (!result.ok) {
        if (mounted) {
          context.go('/find-account');
        }
        return;
      }
      setState(() {
        _userName = result.user?['name'] as String? ?? '';
        _userEmail = result.user?['email'] as String? ?? _email;
        _questions = result.questions;
        _dataLoading = false;
      });
    } catch (_) {
      if (mounted) {
        context.go('/find-account');
      }
    }
  }

  Future<void> _handleVerify() async {
    if (_answer1Ctrl.text.trim().isEmpty || _answer2Ctrl.text.trim().isEmpty) {
      setState(() => _error = t['errorFill']!);
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final verifyResult = await AuthService.verifySecurityAnswers(
        email: _email,
        answer1: _answer1Ctrl.text.trim(),
        answer2: _answer2Ctrl.text.trim(),
      );

      if (!verifyResult.ok) {
        setState(() => _error = verifyResult.message ?? 'Jawaban salah');
        if (mounted) setState(() => _loading = false);
        return;
      }

      // Jawaban benar → kirim OTP login
      final otpResult = await AuthService.requestOtp(_email);
      if (!otpResult.ok) {
        setState(() => _error = otpResult.message ?? 'Gagal kirim OTP');
        if (mounted) setState(() => _loading = false);
        return;
      }

      // Simpan email untuk verification screen dan bersihkan recovery data
      await StorageService.setItem('pending_email', _email);
      await StorageService.deleteItem('pending_mode');
      await StorageService.deleteItem('recovery_email');

      if (mounted) {
        setState(() => _loading = false);
        context.go('/verification');
      }
    } catch (_) {
      setState(() => _error = t['errorServer']!);
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _answer1Ctrl.dispose();
    _answer2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_dataLoading) {
      return const AuthBackground(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AuthBackground(
      child: Column(
        children: [
          // Logo
          const Align(
            alignment: Alignment.centerLeft,
            child: AuthLogo(),
          ),
          const SizedBox(height: 14),

          // Title
          Text(t['title']!,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: kPurple)),
          const SizedBox(height: 18),

          // Avatar
          Container(
            width: 82,
            height: 82,
            decoration: const BoxDecoration(
              color: kPurpleButton,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          // User info (dari API)
          Text(_userName,
              style: const TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w700, color: kPurple)),
          const SizedBox(height: 2),
          Text(_userEmail,
              style: const TextStyle(
                  fontSize: 12, color: kPurpleLight)),
          const SizedBox(height: 20),

          // Security questions section
          Text(t['securityTitle']!,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: kPurple)),
          const SizedBox(height: 4),
          Text(t['securitySubtitle']!,
              style: const TextStyle(
                  fontSize: 12, color: kPurpleLight)),
          const SizedBox(height: 16),

          // Error
          if (_error.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                border: Border.all(color: const Color(0xFFFECACA)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_error,
                  style: const TextStyle(
                      color: Color(0xFFB91C1C), fontSize: 13)),
            ),

          // Question 1
          if (_questions.isNotEmpty) ...[
            _buildQuestionBlock(
              _questions[0]['question'] as String? ?? '',
              _answer1Ctrl,
            ),
            const SizedBox(height: 12),
          ],

          // Question 2
          if (_questions.length > 1) ...[
            _buildQuestionBlock(
              _questions[1]['question'] as String? ?? '',
              _answer2Ctrl,
            ),
            const SizedBox(height: 20),
          ],

          // Verify button
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleVerify,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurpleButton,
                disabledBackgroundColor: kPurpleButton.withValues(alpha: 0.7),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                _loading ? t['verifying']! : t['verify']!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Wrong account button
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton(
              onPressed: _loading
                  ? null
                  : () {
                      StorageService.deleteItem('recovery_email');
                      context.go('/find-account');
                    },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: const BorderSide(color: Color(0xFFBEB6C2), width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(t['wrong']!,
                  style: const TextStyle(
                      color: kPurple,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
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

  Widget _buildQuestionBlock(String question, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: kPurple)),
        const SizedBox(height: 6),
        Text(t['answer']!,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: kPurpleLight)),
        const SizedBox(height: 4),
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
            controller: controller,
            onChanged: (_) => setState(() => _error = ''),
            style: const TextStyle(
                color: Color(0xFF2A2A2A),
                fontSize: 13,
                fontWeight: FontWeight.w500),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
