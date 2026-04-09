import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color kPurple = Color(0xFF6B257F);
const Color kBg = Color(0xFFF7F7FB);

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  int _selectedSource = 0;

  final List<String> _sources = const [
    'Semua',
    'Marketplace',
    'Offline',
  ];

  final List<_SaleItem> _sales = const [
    _SaleItem(
      invoice: 'INV-MP-001',
      customer: 'Toko Sinar Jaya',
      product: 'Kaos Polos 100 pcs',
      amount: 'Rp 2.500.000',
      date: '12 Mar 2026',
      source: 'Marketplace',
      status: 'Selesai',
      qty: '100 pcs',
    ),
    _SaleItem(
      invoice: 'INV-OF-002',
      customer: 'Andi Pratama',
      product: 'Jaket Custom 12 pcs',
      amount: 'Rp 1.800.000',
      date: '13 Mar 2026',
      source: 'Offline',
      status: 'DP',
      qty: '12 pcs',
    ),
    _SaleItem(
      invoice: 'INV-MP-003',
      customer: 'CV Maju Bersama',
      product: 'Hoodie Bordir 50 pcs',
      amount: 'Rp 4.750.000',
      date: '14 Mar 2026',
      source: 'Marketplace',
      status: 'Diproses',
      qty: '50 pcs',
    ),
    _SaleItem(
      invoice: 'INV-OF-004',
      customer: 'Budi Santoso',
      product: 'Seragam Lapangan 20 pcs',
      amount: 'Rp 3.200.000',
      date: '15 Mar 2026',
      source: 'Offline',
      status: 'Selesai',
      qty: '20 pcs',
    ),
  ];

  List<_SaleItem> get _filteredSales {
    final selected = _sources[_selectedSource];
    if (selected == 'Semua') return _sales;
    return _sales.where((e) => e.source == selected).toList();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              onHomeTap: () {
                context.go('/home');
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ChannelSummary(),
                    const SizedBox(height: 18),
                    const _SectionTitle(title: 'Sumber Penjualan'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _sources.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final active = _selectedSource == index;
                          return InkWell(
                            borderRadius: BorderRadius.circular(999),
                            onTap: () =>
                                setState(() => _selectedSource = index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: active ? kPurple : Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: active
                                      ? kPurple
                                      : const Color(0xFFE8ECF4),
                                ),
                              ),
                              child: Text(
                                _sources[index],
                                style: TextStyle(
                                  color: active
                                      ? Colors.white
                                      : const Color(0xFF6B7280),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _SectionTitle(title: 'Penjualan Hari Ini'),
                    const SizedBox(height: 10),
                    const _TodaySalesCard(),
                    const SizedBox(height: 18),
                    const _SectionTitle(title: 'Daftar Transaksi Penjualan'),
                    const SizedBox(height: 12),
                    ..._filteredSales.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SaleCard(item: item),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomActionBar(
        onTambahOffline: () => _showMessage('Tambah penjualan offline'),
        onSinkronMarketplace: () =>
            _showMessage('Sinkron penjualan dari marketplace'),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onHomeTap;

  const _Header({required this.onHomeTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: kPurple,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _HeaderIcon(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => context.pop(),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Penjualan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _HeaderIcon(
                icon: Icons.home_filled,
                onTap: onHomeTap,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.white70, size: 20),
                SizedBox(width: 10),
                Text(
                  'Cari invoice, pelanggan, produk...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ChannelSummary extends StatelessWidget {
  const _ChannelSummary();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _SummaryCard(
            title: 'Marketplace',
            value: 'Rp 7.250.000',
            subtitle: '2 transaksi',
            icon: Icons.storefront_outlined,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Offline',
            value: 'Rp 5.000.000',
            subtitle: '2 transaksi',
            icon: Icons.store_mall_directory_outlined,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E4FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: kPurple),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF24252C),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodaySalesCard extends StatelessWidget {
  const _TodaySalesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0x0FE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Rekap Hari Ini',
            style: TextStyle(
              color: Color(0xFF24252C),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12),
          _InfoRow(label: 'Total Order', value: '4 transaksi'),
          _InfoRow(label: 'Marketplace', value: '2 transaksi'),
          _InfoRow(label: 'Offline', value: '2 transaksi'),
          _InfoRow(
              label: 'Nilai Penjualan', value: 'Rp 12.250.000', strong: true),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;

  const _InfoRow({
    required this.label,
    required this.value,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color(0xFF24252C),
                fontSize: strong ? 13 : 11.5,
                fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF24252C),
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _SaleCard extends StatelessWidget {
  final _SaleItem item;

  const _SaleCard({required this.item});

  Color get statusColor {
    switch (item.status) {
      case 'Selesai':
        return const Color(0xFF16A34A);
      case 'DP':
        return const Color(0xFFF59E0B);
      case 'Diproses':
        return kPurple;
      default:
        return kPurple;
    }
  }

  Color get statusBg {
    switch (item.status) {
      case 'Selesai':
        return const Color(0xFFEAF8EE);
      case 'DP':
        return const Color(0xFFFFF4D8);
      case 'Diproses':
        return const Color(0xFFF3E4FF);
      default:
        return const Color(0xFFF3E4FF);
    }
  }

  Color get sourceColor {
    return item.source == 'Marketplace'
        ? const Color(0xFF2563EB)
        : const Color(0xFFEA580C);
  }

  Color get sourceBg {
    return item.source == 'Marketplace'
        ? const Color(0xFFEAF2FF)
        : const Color(0xFFFFEFE5);
  }

  IconData get sourceIcon {
    return item.source == 'Marketplace'
        ? Icons.storefront_outlined
        : Icons.store_mall_directory_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0x0FE8ECF4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: sourceBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(sourceIcon, color: sourceColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product,
                  style: const TextStyle(
                    color: Color(0xFF24252C),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.customer,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.amount,
                        style: const TextStyle(
                          color: Color(0xFF24252C),
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Text(
                      item.invoice,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.date,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.qty,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: sourceBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.source,
                    style: TextStyle(
                      color: sourceColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final VoidCallback onTambahOffline;
  final VoidCallback onSinkronMarketplace;

  const _BottomActionBar({
    required this.onTambahOffline,
    required this.onSinkronMarketplace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onSinkronMarketplace,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size.fromHeight(46),
                ),
                child: const Text(
                  'Sinkron Marketplace',
                  style: TextStyle(
                    color: kPurple,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onTambahOffline,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size.fromHeight(46),
                ),
                child: const Text(
                  'Tambah Offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
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

class _SaleItem {
  final String invoice;
  final String customer;
  final String product;
  final String amount;
  final String date;
  final String source;
  final String status;
  final String qty;

  const _SaleItem({
    required this.invoice,
    required this.customer,
    required this.product,
    required this.amount,
    required this.date,
    required this.source,
    required this.status,
    required this.qty,
  });
}
