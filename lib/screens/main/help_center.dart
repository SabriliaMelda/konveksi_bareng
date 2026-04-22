import 'package:flutter/material.dart';
import 'settings_detail_scaffold.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsDetailScaffold(
      title: 'Pusat Bantuan',
      icon: Icons.help_outline_rounded,
      summary: 'Panduan cepat untuk fitur utama Konveksi Bareng.',
      items: [
        'Kelola Proyek untuk memantau order dan pekerjaan',
        'Bahan Baku untuk stok, supplier, dan kebutuhan belanja',
        'Keuangan untuk pencatatan cashflow dan transaksi',
        'Marketplace untuk mencari produk dan kebutuhan produksi',
      ],
    );
  }
}
