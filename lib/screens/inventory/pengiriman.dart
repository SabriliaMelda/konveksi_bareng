// lib/pages/pengiriman.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

const kPurple = Color(0xFF6B257F);

class PengirimanScreen extends StatefulWidget {
  const PengirimanScreen({super.key});

  @override
  State<PengirimanScreen> createState() => _PengirimanScreenState();
}

class _PengirimanScreenState extends State<PengirimanScreen> {
  final TextEditingController _searchC = TextEditingController();
  _ShipFilter _filter = _ShipFilter.semua;

  final List<_ShipmentItem> _items = [
    _ShipmentItem(
      orderId: 'ORD-240101-002',
      title: 'Hoodie Premium Fleece',
      store: 'Bareng Official',
      courier: 'JNE',
      service: 'REG',
      resi: 'JNE1234567890',
      status: _ShipStatus.dikirim,
      etaText: 'Estimasi tiba 1-2 hari',
      thumbUrl: 'https://picsum.photos/seed/ship_hoodie/300/300',
      timeline: [
        _TrackEvent('Paket keluar gudang', 'Bandung', '09:12'),
        _TrackEvent('Paket masuk hub', 'Jakarta', '13:40'),
        _TrackEvent('Dalam perjalanan ke alamat', 'Jakarta', '08:05'),
      ],
    ),
    _ShipmentItem(
      orderId: 'ORD-240101-001',
      title: 'Kaos Oversize Basic',
      store: 'Konveksi Bareng',
      courier: 'SiCepat',
      service: 'BEST',
      resi: 'SICEPAT99887766',
      status: _ShipStatus.diproses,
      etaText: 'Menunggu pickup kurir',
      thumbUrl: 'https://picsum.photos/seed/ship_kaos/300/300',
      timeline: [
        _TrackEvent('Pesanan diproses', 'Konveksi Bareng', '10:21'),
        _TrackEvent('Packing selesai', 'Konveksi Bareng', '14:03'),
      ],
    ),
    _ShipmentItem(
      orderId: 'ORD-240101-006',
      title: 'Kemeja Oxford',
      store: 'Konveksi Partner',
      courier: 'AnterAja',
      service: 'Same Day',
      resi: 'ANTERAJA11223344',
      status: _ShipStatus.sampai,
      etaText: 'Tiba',
      thumbUrl: 'https://picsum.photos/seed/ship_kemeja/300/300',
      timeline: [
        _TrackEvent('Paket diterima', 'Alamat penerima', '15:30'),
        _TrackEvent('Kurir mengantar', 'Jakarta', '13:10'),
        _TrackEvent('Paket masuk hub', 'Jakarta', '11:50'),
      ],
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

    final filtered = _items.where((s) {
      final matchQuery =
          q.isEmpty ||
          s.title.toLowerCase().contains(q) ||
          s.store.toLowerCase().contains(q) ||
          s.orderId.toLowerCase().contains(q) ||
          s.resi.toLowerCase().contains(q);

      final matchFilter = switch (_filter) {
        _ShipFilter.semua => true,
        _ShipFilter.diproses => s.status == _ShipStatus.diproses,
        _ShipFilter.dikirim => s.status == _ShipStatus.dikirim,
        _ShipFilter.sampai => s.status == _ShipStatus.sampai,
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
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SearchPill(
                      controller: _searchC,
                      hint: 'Cari resi / order / produk...',
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ===== TITLE =====
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pengiriman',
                  style: TextStyle(
                    color: Color(0xFF1E232C),
                    fontSize: 22,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ===== FILTER CHIPS =====
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _ShipFilter.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final f = _ShipFilter.values[i];
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
                        setState(() => _filter = _ShipFilter.semua);
                      },
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final s = filtered[i];
                        return _ShipmentCard(
                          item: s,
                          onTap: () => _openTrackingSheet(context, s),
                          onCopyResi: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Resi disalin: ${s.resi} (dummy)',
                                ),
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

  void _openTrackingSheet(BuildContext context, _ShipmentItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TrackingSheet(item: item),
    );
  }
}

//
// ===================== MODELS =====================
//
enum _ShipStatus { diproses, dikirim, sampai }

enum _ShipFilter { semua, diproses, dikirim, sampai }

extension on _ShipFilter {
  String get label => switch (this) {
    _ShipFilter.semua => 'Semua',
    _ShipFilter.diproses => 'Diproses',
    _ShipFilter.dikirim => 'Dikirim',
    _ShipFilter.sampai => 'Sampai',
  };
}

class _TrackEvent {
  final String title;
  final String location;
  final String time; // sederhana
  const _TrackEvent(this.title, this.location, this.time);
}

class _ShipmentItem {
  final String orderId;
  final String title;
  final String store;
  final String courier;
  final String service;
  final String resi;
  final _ShipStatus status;
  final String etaText;
  final String thumbUrl;
  final List<_TrackEvent> timeline;

  const _ShipmentItem({
    required this.orderId,
    required this.title,
    required this.store,
    required this.courier,
    required this.service,
    required this.resi,
    required this.status,
    required this.etaText,
    required this.thumbUrl,
    required this.timeline,
  });

  String get statusText => switch (status) {
    _ShipStatus.diproses => 'Diproses',
    _ShipStatus.dikirim => 'Dikirim',
    _ShipStatus.sampai => 'Sampai',
  };

  Color get statusColor => switch (status) {
    _ShipStatus.diproses => const Color(0xFF3641B7),
    _ShipStatus.dikirim => const Color(0xFF00A3FF),
    _ShipStatus.sampai => const Color(0xFF00BE49),
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
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF010101),
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
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
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ShipmentCard extends StatelessWidget {
  final _ShipmentItem item;
  final VoidCallback onTap;
  final VoidCallback onCopyResi;

  const _ShipmentCard({
    required this.item,
    required this.onTap,
    required this.onCopyResi,
  });

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
                                fontFamily: 'Plus Jakarta Sans',
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
                                fontFamily: 'Plus Jakarta Sans',
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
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.etaText,
                        style: const TextStyle(
                          color: Color(0xFF6A707C),
                          fontSize: 11.5,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Resi row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8ECF4)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    size: 18,
                    color: kPurple,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${item.courier} ${item.service} • ${item.resi}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 12,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: onCopyResi,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE8ECF4)),
                      ),
                      child: const Text(
                        'Salin',
                        style: TextStyle(
                          color: kPurple,
                          fontSize: 12,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: const [
                Icon(Icons.info_outline, size: 16, color: Color(0xFF6A707C)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Ketuk kartu untuk melihat tracking.',
                    style: TextStyle(
                      color: Color(0xFF6A707C),
                      fontSize: 11.5,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
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

class _TrackingSheet extends StatelessWidget {
  final _ShipmentItem item;
  const _TrackingSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tracking',
                        style: const TextStyle(
                          color: Color(0xFF1E232C),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE8ECF4)),
                        ),
                        child: const Icon(Icons.close, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _InfoTile(
                  title: item.title,
                  subtitle: '${item.courier} ${item.service} • ${item.resi}',
                  statusText: item.statusText,
                  statusColor: item.statusColor,
                ),

                const SizedBox(height: 14),

                const Text(
                  'Riwayat Pengiriman',
                  style: TextStyle(
                    color: Color(0xFF1E232C),
                    fontSize: 13.5,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),

                _Timeline(events: item.timeline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String statusText;
  final Color statusColor;

  const _InfoTile({
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: kPurple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.local_shipping_outlined,
              color: kPurple,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1E232C),
                    fontSize: 13.5,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF6A707C),
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: statusColor.withOpacity(0.35)),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 10.5,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final List<_TrackEvent> events;
  const _Timeline({required this.events});

  @override
  Widget build(BuildContext context) {
    // tampilkan newest di atas
    final list = events.toList();

    return Column(
      children: List.generate(list.length, (i) {
        final e = list[i];
        final isFirst = i == 0;
        final isLast = i == list.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              child: Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: isFirst ? kPurple : const Color(0xFFCBD5E1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 44,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8ECF4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8ECF4)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.title,
                            style: const TextStyle(
                              color: Color(0xFF1E232C),
                              fontSize: 12.5,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            e.location,
                            style: const TextStyle(
                              color: Color(0xFF6A707C),
                              fontSize: 12,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      e.time,
                      style: const TextStyle(
                        color: Color(0xFF6A707C),
                        fontSize: 12,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
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
        ? 'Belum ada pengiriman.\nPesanan yang dikirim akan muncul di sini.'
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
                Icons.local_shipping_outlined,
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
                fontFamily: 'Plus Jakarta Sans',
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
                    fontFamily: 'Plus Jakarta Sans',
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
