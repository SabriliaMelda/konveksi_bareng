import 'package:flutter/material.dart';
import 'package:konveksi_bareng/worker/pages/pekerja_detail.dart';

const kPurple = Color(0xFF6B257F);

class DaftarPekerjaScreen extends StatefulWidget {
  const DaftarPekerjaScreen({super.key});

  @override
  State<DaftarPekerjaScreen> createState() => _DaftarPekerjaScreenState();
}

class _DaftarPekerjaScreenState extends State<DaftarPekerjaScreen> {
  final TextEditingController _searchC = TextEditingController();
  String _query = '';

  final List<_PekerjaItem> _items = [
    _PekerjaItem(
      nama: 'Santy',
      role: 'Pekerja Jahit',
      avatarAsset: 'assets/images/pekerja/santy.jpg', // opsional
      projects: ['Project C', 'Project D', 'Project E'],
      isBookmark: false,
    ),
    _PekerjaItem(
      nama: 'Pekerja 2',
      role: 'Pekerja Obras',
      avatarAsset: 'assets/images/pekerja/pekerja2.jpg',
      projects: ['Project A', 'Project B'],
      isBookmark: true, // ★ contoh bookmark
    ),
  ];

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((e) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return e.nama.toLowerCase().contains(q) ||
          e.role.toLowerCase().contains(q);
    }).toList();

    final normal = filtered.where((e) => !e.isBookmark).toList();
    final bookmarked = filtered.where((e) => e.isBookmark).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _TopHeader(title: 'Daftar pekerja'),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: _SearchBox(
                controller: _searchC,
                onChanged: (v) => setState(() => _query = v),
                onClear: () {
                  _searchC.clear();
                  setState(() => _query = '');
                },
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                children: [
                  ...normal.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PekerjaTile(
                        nama: p.nama,
                        role: p.role,
                        projectsCount: p.projects.length,
                        avatarAsset: p.avatarAsset,
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF8F9BB3),
                        ),
                        onTap: () => _openDetail(context, p),
                      ),
                    ),
                  ),

                  if (bookmarked.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const _SectionLabel(text: '★ Bookmark'),
                    const SizedBox(height: 10),
                    ...bookmarked.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PekerjaTile(
                          nama: p.nama,
                          role: p.role,
                          projectsCount: p.projects.length,
                          avatarAsset: p.avatarAsset,
                          trailing: const Icon(
                            Icons.star,
                            size: 18,
                            color: kPurple,
                          ),
                          onTap: () => _openDetail(context, p),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, _PekerjaItem p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PekerjaDetailScreen(
          nama: p.nama,
          role: p.role,
          avatarAsset: p.avatarAsset,
          projects: p.projects,
        ),
      ),
    );
  }
}

class _PekerjaItem {
  final String nama;
  final String role;
  final String? avatarAsset;
  final List<String> projects;
  final bool isBookmark;

  _PekerjaItem({
    required this.nama,
    required this.role,
    required this.projects,
    this.avatarAsset,
    this.isBookmark = false,
  });
}

// ================== UI KOMPONEN ==================

class _TopHeader extends StatelessWidget {
  final String title;
  const _TopHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIcon(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF121111),
              fontSize: 16,
              fontFamily: 'Encode Sans',
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          _CircleIcon(
            icon: Icons.home_filled,
            iconColor: kPurple,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleIcon({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFDFDEDE)),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: iconColor ?? Colors.black87),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBox({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF8F9BB3)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari pekerja...',
                hintStyle: TextStyle(
                  color: Color(0xFF8F9BB3),
                  fontSize: 14,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close, size: 18, color: Color(0xFF8F9BB3)),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF6B7280),
        fontSize: 12,
        fontFamily: 'Work Sans',
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _PekerjaTile extends StatelessWidget {
  final String nama;
  final String role;
  final int projectsCount;
  final String? avatarAsset;
  final Widget trailing;
  final VoidCallback onTap;

  const _PekerjaTile({
    required this.nama,
    required this.role,
    required this.projectsCount,
    required this.trailing,
    required this.onTap,
    this.avatarAsset,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF4)),
        ),
        child: Row(
          children: [
            _Avatar(asset: avatarAsset, name: nama),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$role • $projectsCount proyek',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8F9BB3),
                      fontSize: 12,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
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
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          asset!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF3E4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'P',
        style: const TextStyle(color: kPurple, fontWeight: FontWeight.w900),
      ),
    );
  }
}
