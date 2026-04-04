import 'package:flutter/material.dart';
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

  Map<String, dynamic> get t => _strings[_lang]!;
  List<String> get questions => List<String>.from(t['questions'] as List);

  @override
  void dispose() {
    _answer1Ctrl.dispose();
    _answer2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(t['title'] as String,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: kPurple)),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(t['subtitle'] as String,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kPurpleLight)),
          ),
          const SizedBox(height: 24),

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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurpleButton,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(t['confirm'] as String,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ),
          ),

          // Bottom bar
          AuthBottomBar(
            lang: _lang,
            onLangChanged: (code) => setState(() {
              _lang = code;
              _question1Index = 0;
              _question2Index = 1;
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
              fontFamily: 'Poppins',
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
        style: const TextStyle(
            fontFamily: 'Poppins',
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
              fontFamily: 'Poppins',
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
