import 'package:flutter/material.dart';
import '../../widgets/auth_background.dart';
import 'find_account.dart';
import 'verification.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data (will be replaced with provider/params later)
    const userName = 'BOMA IT BDN';
    const userEmail = 'bomaitbdn@gmail.com';

    return AuthBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: AuthLogo(),
          ),
          const SizedBox(height: 22),
          const Text(
            'Akun Ditemukan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kPurple,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),

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
          const SizedBox(height: 18),

          // User info
          const Text(
            userName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kPurple,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            userEmail,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kPurple,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FindAccountScreen()),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                          color: Color(0xFFD2D2D2), width: 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Salah',
                      style: TextStyle(
                        color: kPurple,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const VerificationScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurpleButton,
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.25),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Benar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 34),
          const Center(
            child: Text(
              '\u00a9 Copyrights BOMA | All Rights Reserved',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8F8F8F),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
