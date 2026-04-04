// status_tagihan_upah.dart
import 'package:flutter/material.dart';

const kPurple = Color(0xFF6B257F);

class WageBillingStatusScreen extends StatefulWidget {
  const WageBillingStatusScreen({super.key});

  @override
  State<WageBillingStatusScreen> createState() =>
      _WageBillingStatusScreenState();
}

class _WageBillingStatusScreenState extends State<WageBillingStatusScreen> {
  final TextEditingController _searchC = TextEditingController();
  String _query = '';

  // contoh data sesuai bookmark: "Pek1 dst"
  final List<_TagihanItem> _items = [
    _TagihanItem(
      title: 'Pek1 dst',
      subtitle: 'Detail tagihan upah',
      icon: Icons.folder_outlined,
    ),
    // tambahkan item lain di sini
    // _TagihanItem(title: 'Pek2', subtitle: 'Detail tagihan upah', icon: Icons.folder_outlined),
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
      return e.title.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _TopHeader(title: 'Status tagihan upah'),
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
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final item = filtered[i];

                  return _BookmarkListTile(
                    title: item.title,
                    subtitle: item.subtitle,
                    icon: item.icon,
                    onTap: () {
                      // TODO: arahkan ke detail tagihan per pekerja / per proyek
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Buka: ${item.title}')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagihanItem {
  final String title;
  final String subtitle;
  final IconData icon;

  _TagihanItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

//
// ================== TOP HEADER (BACK + TITLE + HOME) ==================
//
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

//
// ================== SEARCH BOX ==================
//
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
                hintText: 'Cari tagihan...',
                hintStyle: TextStyle(
                  color: Color(0xFF8F9BB3),
                  fontSize: 14,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF111111),
                fontSize: 14,
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

//
// ================== LIST TILE STYLE "BOOKMARK" ==================
//
class _BookmarkListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _BookmarkListTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE8ECF4)),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: kPurple, size: 20),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8F9BB3),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
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
