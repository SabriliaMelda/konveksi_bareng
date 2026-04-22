import 'package:flutter/material.dart';
import 'settings_detail_scaffold.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsDetailScaffold(
      title: 'Keamanan',
      icon: Icons.lock_outline_rounded,
      summary: 'Kelola keamanan akun, PIN, dan perangkat yang terhubung.',
      items: [
        'Atur PIN untuk membuka aplikasi',
        'Pantau perangkat yang pernah login',
        'Gunakan biometrik dari halaman Preferensi',
        'Jaga akses akun tetap aman saat berpindah perangkat',
      ],
    );
  }
}
