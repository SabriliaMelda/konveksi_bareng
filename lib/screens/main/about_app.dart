import 'package:flutter/material.dart';
import 'settings_detail_scaffold.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsDetailScaffold(
      title: 'Tentang Aplikasi',
      icon: Icons.info_outline_rounded,
      summary:
          'Konveksi Bareng membantu mengelola produksi, stok, marketplace, dan keuangan.',
      items: [
        'Versi: 1.0.0',
        'Build: Development',
        'Lisensi: Internal project',
      ],
    );
  }
}
