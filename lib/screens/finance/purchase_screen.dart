// lib/pages/pembelian.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const kPurple = Color(0xFF6B257F);

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final TextEditingController _searchC = TextEditingController();
  _OrderFilter _filter = _OrderFilter.semua;

  final List<_OrderItem> _orders = [
    _OrderItem(
      id: 'ORD-240101-001',
      title: 'Kaos Oversize Basic',
      store: 'Konveksi Bareng',
      status: _OrderStatus.diproses,
      total: 159000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      thumbUrl: 'https://picsum.photos/seed/kaos_pembelian/300/300',
    ),
    _OrderItem(
      id: 'ORD-240101-002',
      title: 'Hoodie Premium Fleece',
      store: 'Bareng Official',
      status: _OrderStatus.dikirim,
      total: 219000,
      date: DateTime.now().subtract(const Duration(days: 3)),
      thumbUrl: 'https://picsum.photos/seed/hoodie_pembelian/300/300',
    ),
    _OrderItem(
      id: 'ORD-240101-003',
      title: 'Kemeja Oxford',
      store: 'Konveksi Partner',
      status: _OrderStatus.selesai,
      total: 99000,
      date: DateTime.now().subtract(const Duration(days: 12)),
      thumbUrl: 'https://picsum.photos/seed/kemeja_pembelian/300/300',
    ),
    _OrderItem(
      id: 'ORD-240101-004',
      title: 'Topi Baseball',
      store: 'Bareng Official',
      status: _OrderStatus.dibatalkan,
      total: 39000,
      date: DateTime.now().subtract(const Duration(days: 20)),
      thumbUrl: 'https://picsum.photos/seed/topi_pembelian/300/300',
    ),
    _OrderItem(
      id: 'ORD-240101-005',
      title: 'Jaket Windbreaker',
      store: 'Bareng Wear',
      status: _OrderStatus.menungguBayar,
      total: 129000,
      date: DateTime.now().subtract(const Duration(hours: 6)),
      thumbUrl: 'https://picsum.photos/seed/jaket_pembelian/300/300',
    ),
  ];

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _searchC.text.trim().toLowerCase();

    final filtered = _orders.where((o) {
      final matchQuery =
          q.isEmpty ||
          o.title.toLowerCase().contains(q) ||
          o.store.toLowerCase().contains(q) ||
          o.id.toLowerCase().contains(q);

      final matchFilter = switch (_filter) {
        _OrderFilter.semua => true,
        _OrderFilter.menungguBayar => o.status == _OrderStatus.menungguBayar,
        _OrderFilter.diproses => o.status == _OrderStatus.diproses,
        _OrderFilter.dikirim => o.status == _OrderStatus.dikirim,
        _OrderFilter.selesai => o.status == _OrderStatus.selesai,
        _OrderFilter.dibatalkan => o.status == _OrderStatus.dibatalkan,
      };

      return matchQuery && matchFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ===== TOP ROW: BACK + SEARCH + HOME =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new,
                    iconColor: Colors.black87,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SearchPill(
                      controller: _searchC,
                      hint: 'Cari pesanan (ID / produk / toko)...',
                      onChanged: (_) => setState(() {}),
                      onClear: () {
                        _searchC.clear();
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  _CircleIconButton(
                    icon: Icons.home_outlined,
                    iconColor: kPurple,
                    onTap: () {
                      context.go('/home');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ===== TITLE + ACTION =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Pembelian',
                      style: TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Riwayat & Ringkasan (dummy)'),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 18,
                            color: kPurple,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Riwayat',
                            style: TextStyle(
                              color: kPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ===== FILTER CHIPS =====
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _OrderFilter.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final f = _OrderFilter.values[i];
                  final active = f == _filter;
                  return _FilterChipItem(
                    text: f.label,
                    active: active,
                    onTap: () => setState(() => _filter = f),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ===== LIST =====
            Expanded(
              child: filtered.isEmpty
                  ? _EmptyState(
                      query: _searchC.text.trim(),
                      onReset: () {
                        _searchC.clear();
                        setState(() => _filter = _OrderFilter.semua);
                      },
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final o = filtered[i];
                        return _OrderCard(
                          item: o,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Buka detail: ${o.id}')),
                            );
                          },
                          onPrimary: () {
                            final label = o.primaryActionLabel;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$label: ${o.id} (dummy)'),
                              ),
                            );
                          },
                          onSecondary: () {
                            final label = o.secondaryActionLabel;
                            if (label == null) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$label: ${o.id} (dummy)'),
                              ),
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

//
// ===================== MODELS =====================
//
enum _OrderStatus { menungguBayar, diproses, dikirim, selesai, dibatalkan }

enum _OrderFilter {
  semua,
  menungguBayar,
  diproses,
  dikirim,
  selesai,
  dibatalkan,
}

extension on _OrderFilter {
  String get label => switch (this) {
    _OrderFilter.semua => 'Semua',
    _OrderFilter.menungguBayar => 'Menunggu Bayar',
    _OrderFilter.diproses => 'Diproses',
    _OrderFilter.dikirim => 'Dikirim',
    _OrderFilter.selesai => 'Selesai',
    _OrderFilter.dibatalkan => 'Dibatalkan',
  };
}

class _OrderItem {
  final String id;
  final String title;
  final String store;
  final _OrderStatus status;
  final int total;
  final DateTime date;
  final String thumbUrl;

  _OrderItem({
    required this.id,
    required this.title,
    required this.store,
    required this.status,
    required this.total,
    required this.date,
    required this.thumbUrl,
  });

  String get statusText => switch (status) {
    _OrderStatus.menungguBayar => 'Menunggu Bayar',
    _OrderStatus.diproses => 'Diproses',
    _OrderStatus.dikirim => 'Dikirim',
    _OrderStatus.selesai => 'Selesai',
    _OrderStatus.dibatalkan => 'Dibatalkan',
  };

  Color get statusColor => switch (status) {
    _OrderStatus.menungguBayar => const Color(0xFFFF8A00),
    _OrderStatus.diproses => const Color(0xFF3641B7),
    _OrderStatus.dikirim => const Color(0xFF00A3FF),
    _OrderStatus.selesai => const Color(0xFF00BE49),
    _OrderStatus.dibatalkan => const Color(0xFFB00020),
  };

  String get primaryActionLabel => switch (status) {
    _OrderStatus.menungguBayar => 'Bayar',
    _OrderStatus.diproses => 'Lihat Detail',
    _OrderStatus.dikirim => 'Lacak',
    _OrderStatus.selesai => 'Beli Lagi',
    _OrderStatus.dibatalkan => 'Lihat Detail',
  };

  String? get secondaryActionLabel => switch (status) {
    _OrderStatus.menungguBayar => 'Batalkan',
    _OrderStatus.diproses => null,
    _OrderStatus.dikirim => 'Lihat Detail',
    _OrderStatus.selesai => 'Beri Ulasan',
    _OrderStatus.dibatalkan => null,
  };
}

//
// ===================== UI COMPONENTS =====================
//
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchPill({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF010101)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF6A707C),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF010101),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close, size: 18, color: Color(0xFF777777)),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? kPurple : const Color(0xFFF6F7F8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? kPurple : const Color(0xFFE8ECF4)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF1E232C),
            fontSize: 12,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _OrderItem item;
  final VoidCallback onTap;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const _OrderCard({
    required this.item,
    required this.onTap,
    required this.onPrimary,
    required this.onSecondary,
  });

  String _rupiah(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write('.');
    }
    return 'Rp $buf';
  }

  String _dateText(DateTime d) {
    // format sederhana: dd/MM/yyyy
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd/$mm/$yy';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8ECF4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0CB3B3B3),
              blurRadius: 40,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.thumbUrl,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF1E232C),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: item.statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: item.statusColor.withOpacity(0.35),
                              ),
                            ),
                            child: Text(
                              item.statusText,
                              style: TextStyle(
                                color: item.statusColor,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.store,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF6A707C),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            _rupiah(item.total),
                            style: const TextStyle(
                              color: kPurple,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _dateText(item.date),
                            style: const TextStyle(
                              color: Color(0xFF6A707C),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ActionBtn(
                    label: item.primaryActionLabel,
                    filled: true,
                    onTap: onPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionBtn(
                    label: item.secondaryActionLabel ?? '—',
                    filled: false,
                    disabled: item.secondaryActionLabel == null,
                    onTap: onSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final bool filled;
  final bool disabled;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.filled,
    this.disabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = filled ? kPurple : Colors.white;
    final fg = filled ? Colors.white : kPurple;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: disabled ? null : onTap,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: disabled ? const Color(0xFFF3F4F6) : bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: disabled ? const Color(0xFFE8ECF4) : kPurple,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: disabled ? const Color(0xFF9AA3AF) : fg,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  final VoidCallback onReset;

  const _EmptyState({required this.query, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final msg = query.isEmpty
        ? 'Belum ada pembelian.\nMulai belanja di Marketplace.'
        : 'Tidak ada hasil untuk "$query".';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: kPurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: kPurple,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6A707C),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onReset,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8ECF4)),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: kPurple,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
