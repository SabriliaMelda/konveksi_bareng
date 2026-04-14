import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';

class SimplePlaceholderPage extends StatelessWidget {
  final String title;

  SimplePlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColors.bg,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).appColors.card,
        foregroundColor: Colors.black87,
        elevation: 0.6,
      ),
      body: const Center(
        child: Text(
          'Halaman ini masih placeholder.\nNanti ganti ke halaman real kamu.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
