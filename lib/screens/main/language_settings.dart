import 'package:flutter/material.dart';
import 'settings_detail_scaffold.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsDetailScaffold(
      title: 'Bahasa',
      icon: Icons.language_rounded,
      summary: 'Pengaturan bahasa dan format lokal aplikasi.',
      items: [
        'Bahasa aktif: Indonesia',
        'Format tanggal mengikuti lokal Indonesia',
        'Mata uang ditampilkan dalam Rupiah',
      ],
    );
  }
}
