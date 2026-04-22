import 'package:flutter/material.dart';
import 'settings_detail_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsDetailScaffold(
      title: 'Kebijakan Privasi',
      icon: Icons.privacy_tip_outlined,
      summary: 'Ringkasan penggunaan data di aplikasi.',
      items: [
        'Data akun digunakan untuk identifikasi pengguna',
        'Data proyek dan transaksi digunakan untuk operasional bisnis',
        'Pengaturan keamanan membantu menjaga akses akun',
      ],
    );
  }
}
