import 'package:flutter/material.dart';

const kPurple = Color(0xFF6B257F);

/// Formatter untuk judul menu:
/// - Title Case (Jadwal Mulai)
/// - Akronim tertentu FULL CAPS (SPK, RAP, QC, dll)
/// - Perbaikan khusus: "spk nmr" -> "SPK Nomor", "No" -> "Nomor"
String formatBookmarkTitle(String raw) {
  final s = raw.trim();
  if (s.isEmpty) return s;

  // Kata yang harus FULL CAPS
  const acronyms = {'spk', 'rap', 'qc', 'ppn', 'pbb', 'k3', 'cctv'};

  // Kata kecil yang biasanya tetap kecil (kecuali kata pertama)
  const smallWords = {
    'dan',
    'atau',
    'di',
    'ke',
    'dari',
    'untuk',
    'pada',
    'yang',
  };

  final parts = s.split(RegExp(r'\s+'));
  final out = <String>[];

  for (int i = 0; i < parts.length; i++) {
    var w = parts[i];
    if (w.isEmpty) continue;

    final lower = w.toLowerCase();

    // Akronim
    if (acronyms.contains(lower)) {
      out.add(lower.toUpperCase());
      continue;
    }

    // Small words (bukan kata pertama)
    if (i != 0 && smallWords.contains(lower)) {
      out.add(lower);
      continue;
    }

    // Title Case
    out.add(lower[0].toUpperCase() + lower.substring(1));
  }

  var result = out.join(' ');

  // Perbaikan "Nmr" / "No" -> "Nomor"
  result = result
      .replaceAll(RegExp(r'\bNmr\b', caseSensitive: false), 'Nomor')
      .replaceAll(RegExp(r'\bNo\b', caseSensitive: false), 'Nomor');

  // Pastikan SPK tetap caps (kalau kebetulan jadi "Spk")
  result = result.replaceAll(RegExp(r'\bSpk\b'), 'SPK');

  return result;
}

class BookmarkMenuScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<BookmarkItem> items;

  const BookmarkMenuScreen({
    super.key,
    required this.title,
    required this.items,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _TopHeader(
              title: formatBookmarkTitle(title),
              subtitle: subtitle,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _BookmarkTile(item: items[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================= MODEL =========================
class BookmarkItem {
  final String title;
  final IconData icon;
  final Widget? page;
  final List<BookmarkItem>? children;

  const BookmarkItem._({
    required this.title,
    required this.icon,
    this.page,
    this.children,
  });

  factory BookmarkItem.action({
    required String title,
    required IconData icon,
    required Widget page,
  }) {
    return BookmarkItem._(title: title, icon: icon, page: page);
  }

  factory BookmarkItem.folder({
    required String title,
    required IconData icon,
    required List<BookmarkItem> children,
  }) {
    return BookmarkItem._(title: title, icon: icon, children: children);
  }

  bool get isFolder => children != null && children!.isNotEmpty;
}

// ========================= UI =========================
class _TopHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onBack;

  const _TopHeader({required this.title, required this.onBack, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8ECF4))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _HeaderIcon(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: onBack,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF121111),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ),
              _HeaderIcon(
                icon: Icons.more_horiz_rounded,
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Menu Proyek')));
                },
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            _HeaderInfoCard(subtitle: subtitle!),
          ],
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF4)),
        ),
        child: Icon(icon, color: const Color(0xFF111111), size: 20),
      ),
    );
  }
}

class _HeaderInfoCard extends StatelessWidget {
  final String subtitle;
  const _HeaderInfoCard({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kPurple.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kPurple.withValues(alpha: 0.15)),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.folder_open_rounded,
              color: kPurple,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const _Chip(text: 'Aktif'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kPurple.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: kPurple.withValues(alpha: 0.18)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: kPurple,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  final BookmarkItem item;
  const _BookmarkTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isFolder = item.isFolder;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (isFolder) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookmarkMenuScreen(
                title: formatBookmarkTitle(item.title),
                subtitle: 'Submenu',
                items: item.children!,
              ),
            ),
          );
          return;
        }
        if (item.page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item.page!),
          );
        }
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8ECF4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Strip kiri ungu
            Container(
              width: 6,
              height: double.infinity,
              decoration: BoxDecoration(
                color: kPurple.withValues(alpha: isFolder ? 0.95 : 0.70),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Icon container
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: kPurple.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kPurple.withValues(alpha: 0.14)),
              ),
              alignment: Alignment.center,
              child: Icon(item.icon, size: 20, color: kPurple),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                formatBookmarkTitle(item.title),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF121111),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(width: 8),
            Icon(
              isFolder
                  ? Icons.chevron_right_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: isFolder ? 22 : 16,
              color: const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
