import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/config/app_colors.dart';

class SettingsDetailScaffold extends StatelessWidget {
  final String title;
  final IconData icon;
  final String summary;
  final List<String> items;

  const SettingsDetailScaffold({
    super.key,
    required this.title,
    required this.icon,
    required this.summary,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6B257F);

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          children: [
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/settings');
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).appColors.card,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Theme.of(context).appColors.border,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).appColors.ink,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).appColors.card,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Theme.of(context).appColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE9D5FF)),
                    ),
                    child: Icon(icon, color: purple, size: 26),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    summary,
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final item in items) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: purple,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: Theme.of(context).appColors.muted,
                              fontSize: 12.5,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
