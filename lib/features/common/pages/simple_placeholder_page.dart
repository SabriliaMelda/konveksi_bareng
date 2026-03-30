import 'package:flutter/material.dart';

class SimplePlaceholderPage extends StatelessWidget {
  final String title;

  const SimplePlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
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
