import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:konveksi_bareng/screens/project/project_detail_screen.dart';

const kPurple = Color(0xFF6B257F);

class WorkerDetailScreen extends StatelessWidget {
  final String nama;
  final String role;
  final String? avatarAsset;
  final List<String> projects;

  WorkerDetailScreen({
    super.key,
    required this.nama,
    required this.role,
    required this.projects,
    this.avatarAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColors.bg,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appColors.card,
        foregroundColor: Colors.black87,
        elevation: 0.6,
        title: Text(nama),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 18),
        children: [
          _ProfileCard(nama: nama, role: role, avatarAsset: avatarAsset),
          SizedBox(height: 14),

          Text(
            'Sedang mengerjakan',
            style: TextStyle(
              color: Theme.of(context).appColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),

          ...projects.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ProjectTile(
                title: p,
                subtitle: 'Status: On going',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProjectDetailScreen(projectName: p, workerName: nama),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String nama;
  final String role;
  final String? avatarAsset;

  const _ProfileCard({
    required this.nama,
    required this.role,
    this.avatarAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).appColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _Avatar(asset: avatarAsset, name: nama),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).appColors.ink,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).appColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E4FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Aktif',
              style: TextStyle(
                color: kPurple,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProjectTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).appColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFF3E4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.folder_outlined, color: kPurple),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).appColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8F9BB3),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF8F9BB3)),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? asset;
  final String name;
  const _Avatar({required this.asset, required this.name});

  @override
  Widget build(BuildContext context) {
    if (asset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          asset!,
          width: 46,
          height: 46,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF3E4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'P',
        style: const TextStyle(
          color: kPurple,
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
      ),
    );
  }
}
