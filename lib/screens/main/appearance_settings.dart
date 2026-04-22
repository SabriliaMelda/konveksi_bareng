import 'package:flutter/material.dart';
import 'settings_detail_scaffold.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsDetailScaffold(
      title: 'Tema & Tampilan',
      icon: Icons.palette_outlined,
      summary: 'Atur tampilan aplikasi sesuai kebutuhan kerja.',
      items: [
        'Mode gelap bisa diatur dari Preferensi',
        'Warna utama aplikasi menggunakan identitas ungu',
        'Layout dioptimalkan untuk alur konveksi',
      ],
    );
  }
}
