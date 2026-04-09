import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/auth_background.dart';

const _strings = {
  'id': {
    'help': 'Bantuan',
    'title': 'Pertanyaan Keamanan',
    'subtitle': 'Pengaturan Pemulihan Akun',
    'label1': 'Pertanyaan keamanan 1:',
    'answer1': 'Jawaban keamanan 1:',
    'label2': 'Pertanyaan keamanan 2:',
    'answer2': 'Jawaban keamanan 2:',
    'confirm': 'Konfirmasi',
    'saving': 'Menyimpan...',
    'errorFill': 'Harap isi semua jawaban.',
    'errorSame': 'Pertanyaan keamanan tidak boleh sama.',
    'errorServer': 'Tidak dapat terhubung ke server.',
    'successTitle': 'Akun berhasil dibuat!',
    'successSubtitle':
        'Akun Anda telah berhasil dibuat dan pertanyaan keamanan tersimpan.',
    'goToLogin': 'Masuk ke Login',
    'questions': [
      'Apa nama tengah ayah/ibu Anda?',
      'Apa nama panggilan masa kecil Anda?',
      'Apa makanan favorit masa kecil Anda?',
      'Apa nama hewan peliharaan pertama Anda?',
      'Di kota mana Anda lahir?',
      'Apa nama sekolah dasar Anda?',
    ],
  },
  'en': {
    'help': 'Help',
    'title': 'Security Question',
    'subtitle': 'Account Recovery Settings',
    'label1': 'Security question 1:',
    'answer1': 'Security answer 1:',
    'label2': 'Security question 2:',
    'answer2': 'Security answer 2:',
    'confirm': 'Confirm',
    'saving': 'Saving...',
    'errorFill': 'Please fill in all answers.',
    'errorSame': 'Security questions must be different.',
    'errorServer': 'Cannot connect to server.',
    'successTitle': 'Account created!',
    'successSubtitle':
        'Your account has been created and security questions saved.',
    'goToLogin': 'Go to Login',
    'questions': [
      "What is your father/mother's middle name?",
      'What was your childhood nickname?',
      'What was your favorite childhood food?',
      'What was the name of your first pet?',
      'What city were you born in?',
      'What is the name of your elementary school?',
    ],
  },
};

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  String _lang = 'id';
  int _question1Index = 0;
  int _question2Index = 1;
  final _answer1Ctrl = TextEditingController();
  final _answer2Ctrl = TextEditingController();

  String _error = '';
  bool _loading = false;
  bool _success = false;
  String _email = '';

  Map<String, dynamic> get t => _strings[_lang]!;
  List<String> get questions => List<String>.from(t['questions'] as List);

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final email = await StorageService.getItem('security_email');
    if (email == null && mounted) {
      context.go('/login');
      return;
    }
    setState(() => _email = email ?? '');
  }

  Future<void> _handleSubmit() async {
    if (_answer1Ctrl.text.trim().isEmpty || _answer2Ctrl.text.trim().isEmpty) {
      setState(() => _error = t['errorFill'] as String);
      return;
    }
    if (_question1Index == _question2Index) {
      setState(() => _error = t['errorSame'] as String);
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final result = await AuthService.saveSecurityQuestions(
        email: _email,
        question1: questions[_question1Index],
        answer1: _answer1Ctrl.text.trim(),
        question2: questions[_question2Index],
        answer2: _answer2Ctrl.text.trim(),
      );
      if (!result.ok) {
        setState(() => _error = result.message ?? 'Gagal menyimpan');
      } else {
        await StorageService.deleteItem('security_email');
        setState(() => _success = true);
      }
    } catch (_) {
      setState(() => _error = t['errorServer'] as String);
    } finally {
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
            Text(t['successTitle'] as String,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: kPurple)),
            const SizedBox(height: 4),
            Text(t['successSubtitle'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: kPurpleLight)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurpleButton,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(t['goToLogin'] as String,
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
          Center(
            child: Text(t['title'] as String,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: kPurple)),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(t['subtitle'] as String,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kPurpleLight)),
          ),
          const SizedBox(height: 24),

          // Error
          AuthErrorBox(message: _error),

          // Question 1
          _buildLabel(t['label1'] as String),
          _buildDropdown(
            value: _question1Index,
            onChanged: (v) => setState(() => _question1Index = v),
          ),
          const SizedBox(height: 6),
          _buildLabel(t['answer1'] as String),
          _buildInput(_answer1Ctrl),
          const SizedBox(height: 14),

          // Question 2
          _buildLabel(t['label2'] as String),
          _buildDropdown(
            value: _question2Index,
            onChanged: (v) => setState(() => _question2Index = v),
          ),
          const SizedBox(height: 6),
          _buildLabel(t['answer2'] as String),
          _buildInput(_answer2Ctrl),
          const SizedBox(height: 20),

          // Confirm
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
                _loading
                    ? t['saving'] as String
                    : t['confirm'] as String,
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
              _question1Index = 0;
              _question2Index = 1;
              _error = '';
            }),
            helpLabel: t['help'] as String,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 14),
      child: Text(text,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kPurple)),
    );
  }

  Widget _buildInput(TextEditingController controller) {
    return Container(
      height: 42,
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
    );
  }

  Widget _buildDropdown({
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBEB6C2), width: 1),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF2A2A2A)),
          items: List.generate(
            questions.length,
            (i) => DropdownMenuItem(value: i, child: Text(questions[i])),
          ),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
