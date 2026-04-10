import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

const Color kPurple = Color(0xFF6B257F);
const Color kBg = Color(0xFFF7F7FB);

// ── Payment options (same as checkout) ───────────────────────────────────────

class _PaymentOption {
  final String label;
  final String group;
  final IconData icon;
  final Color color;
  const _PaymentOption(
      {required this.label,
      required this.group,
      required this.icon,
      required this.color});
}

const _paymentOptions = [
  _PaymentOption(
      label: 'Visa',
      group: 'Kartu Kredit',
      icon: Icons.credit_card,
      color: Color(0xFF1A1F71)),
  _PaymentOption(
      label: 'Mastercard',
      group: 'Kartu Kredit',
      icon: Icons.credit_card,
      color: Color(0xFFEB001B)),
  _PaymentOption(
      label: 'GoPay',
      group: 'E-Wallet',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFF00AED6)),
  _PaymentOption(
      label: 'DANA',
      group: 'E-Wallet',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFF118EEA)),
  _PaymentOption(
      label: 'ShopeePay',
      group: 'E-Wallet',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFFEE4D2D)),
  _PaymentOption(
      label: 'QRIS',
      group: 'QRIS',
      icon: Icons.qr_code_2_rounded,
      color: Color(0xFF6B257F)),
];

// ── Helper ────────────────────────────────────────────────────────────────────

String _rupiah(int n) {
  final s = n.toString();
  final buf = StringBuffer('Rp ');
  for (int i = 0; i < s.length; i++) {
    final fromEnd = s.length - i;
    buf.write(s[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write('.');
  }
  return buf.toString();
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedFilter = 0;
  _PaymentOption? _selectedPayment;

  final List<String> _filters = const [
    'Semua',
    'Menunggu',
    'Berhasil',
    'Gagal',
  ];

  final List<_PaymentHistoryItem> _history = [
    _PaymentHistoryItem(
      orderId: 'INV-2026-001',
      nama: 'Kaos Oversize Basic',
      model: 'Basic Cotton 30s',
      seller: 'Konveksi Bareng',
      total: 1014000,
      date: '12 Mar 2026',
      method: 'Visa',
      status: 'Menunggu',
    ),
    _PaymentHistoryItem(
      orderId: 'INV-2026-002',
      nama: 'Hoodie Premium Fleece',
      model: 'Premium Oversized',
      seller: 'Bareng Official',
      total: 459000,
      date: '10 Mar 2026',
      method: 'QRIS',
      status: 'Berhasil',
    ),
    _PaymentHistoryItem(
      orderId: 'INV-2026-003',
      nama: 'Jaket Windbreaker',
      model: 'Slim Fit Series',
      seller: 'Bareng Wear',
      total: 389000,
      date: '08 Mar 2026',
      method: 'GoPay',
      status: 'Gagal',
    ),
  ];

  List<_PaymentHistoryItem> get _filteredHistory {
    final selected = _filters[_selectedFilter];
    if (selected == 'Semua') return _history;
    return _history.where((e) => e.status == selected).toList();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _showPaymentPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollController) => _PaymentPickerSheet(
          selected: _selectedPayment,
          scrollController: scrollController,
          onSelect: (opt) {
            setState(() => _selectedPayment = opt);
            Navigator.pop(context);
          },
        ),
      ),
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CurrentStatusCard(),
                    const SizedBox(height: 16),
                    const _OrderInfoCard(),
                    const SizedBox(height: 16),
                    _PaymentMethodCard(
                      selected: _selectedPayment,
                      onTap: _showPaymentPicker,
                    ),
                    const SizedBox(height: 16),
                    const _TimelineSection(),
                    const SizedBox(height: 18),
                    const _SectionTitle(title: 'Riwayat Status Pembayaran'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final active = _selectedFilter == index;
                          return InkWell(
                            borderRadius: BorderRadius.circular(999),
                            onTap: () =>
                                setState(() => _selectedFilter = index),
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
                                _filters[index],
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
                    const SizedBox(height: 12),
                    ..._filteredHistory.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _HistoryCard(item: item),
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
        onPayNow: () => _showMessage('Lanjut ke pembayaran pesanan'),
        onCheckStatus: () => _showMessage('Status pembayaran diperbarui'),
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
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Status Pembayaran',
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
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: const [
                Icon(Icons.receipt_long_rounded,
                    color: Colors.white70, size: 20),
                SizedBox(width: 10),
                Text(
                  'Lihat status, metode, dan detail pembayaran...',
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
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _CurrentStatusCard extends StatelessWidget {
  const _CurrentStatusCard();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4D8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: Color(0xFFF59E0B),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menunggu Pembayaran',
                  style: TextStyle(
                    color: Color(0xFF24252C),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pesanan kamu sudah dibuat. Silakan selesaikan pembayaran agar proses produksi atau pengiriman bisa dilanjutkan.',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4D8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Batas pembayaran: 24 jam',
                    style: TextStyle(
                      color: Color(0xFFF59E0B),
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

class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard();

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
          _SectionTitle(title: 'Detail Pesanan'),
          SizedBox(height: 12),
          _InfoRow(label: 'Order ID', value: 'INV-2026-001'),
          _InfoRow(label: 'Nama', value: 'Kaos Oversize Basic'),
          _InfoRow(label: 'Model', value: 'Basic Cotton 30s'),
          _InfoRow(label: 'Seller', value: 'Konveksi Bareng'),
          _InfoRow(label: 'Jumlah Item', value: '9 item'),
          _InfoRow(label: 'Subtotal', value: 'Rp 1.014.000', isStrong: true),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final _PaymentOption? selected;
  final VoidCallback onTap;

  const _PaymentMethodCard({required this.selected, required this.onTap});

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
        border: Border.all(
          color: selected != null ? kPurple : const Color(0x0FE8ECF4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Metode Pembayaran'),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected != null ? kPurple : const Color(0xFFDFDEDE),
                ),
              ),
              child: Row(
                children: [
                  if (selected != null) ...[
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: selected!.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(selected!.icon,
                          color: selected!.color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(selected!.label,
                              style: const TextStyle(
                                  color: Color(0xFF121111),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                          Text(selected!.group,
                              style: const TextStyle(
                                  color: Color(0xFF787676),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ] else ...[
                    const Icon(Icons.payment_outlined,
                        color: Color(0xFF9E9E9E), size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('Pilih metode pembayaran',
                          style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                  const Icon(Icons.keyboard_arrow_down,
                      color: Color(0xFF292526)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection();

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
          _SectionTitle(title: 'Progress Pembayaran'),
          SizedBox(height: 12),
          _TimelineItem(
            title: 'Pesanan dibuat',
            subtitle: '12 Mar 2026 • 10:15',
            done: true,
          ),
          _TimelineItem(
            title: 'Menunggu pembayaran',
            subtitle: '12 Mar 2026 • 10:16',
            done: true,
            highlighted: true,
          ),
          _TimelineItem(
            title: 'Verifikasi pembayaran',
            subtitle: 'Menunggu konfirmasi',
            done: false,
          ),
          _TimelineItem(
            title: 'Pembayaran berhasil',
            subtitle: 'Akan aktif setelah verifikasi',
            done: false,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool done;
  final bool highlighted;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.subtitle,
    required this.done,
    this.highlighted = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = done
        ? (highlighted ? const Color(0xFFF59E0B) : kPurple)
        : const Color(0xFFD1D5DB);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
              child: done
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: const Color(0xFFE5E7EB),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: highlighted
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF24252C),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStrong;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 92,
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
                fontSize: isStrong ? 13 : 11.5,
                fontWeight: isStrong ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final _PaymentHistoryItem item;

  const _HistoryCard({required this.item});

  Color get statusColor {
    switch (item.status) {
      case 'Berhasil':
        return const Color(0xFF16A34A);
      case 'Menunggu':
        return const Color(0xFFF59E0B);
      case 'Gagal':
        return const Color(0xFFDC2626);
      default:
        return kPurple;
    }
  }

  Color get statusBg {
    switch (item.status) {
      case 'Berhasil':
        return const Color(0xFFEAF8EE);
      case 'Menunggu':
        return const Color(0xFFFFF4D8);
      case 'Gagal':
        return const Color(0xFFFFE9E9);
      default:
        return const Color(0xFFF3E4FF);
    }
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
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              item.status == 'Berhasil'
                  ? Icons.check_circle_rounded
                  : item.status == 'Menunggu'
                      ? Icons.schedule_rounded
                      : Icons.cancel_rounded,
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(
                    color: Color(0xFF24252C),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.model,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.orderId,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _rupiah(item.total),
                        style: const TextStyle(
                          color: kPurple,
                          fontSize: 13,
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
                Text(
                  '${item.date} • ${item.method} • ${item.seller}',
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

class _BottomActionBar extends StatelessWidget {
  final VoidCallback onPayNow;
  final VoidCallback onCheckStatus;

  const _BottomActionBar({
    required this.onPayNow,
    required this.onCheckStatus,
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
                onPressed: onCheckStatus,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size.fromHeight(46),
                ),
                child: const Text(
                  'Cek Status',
                  style: TextStyle(
                    color: kPurple,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onPayNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size.fromHeight(46),
                ),
                child: const Text(
                  'Bayar Lagi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
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

class _PaymentHistoryItem {
  final String orderId;
  final String nama;
  final String model;
  final String seller;
  final int total;
  final String date;
  final String method;
  final String status;

  const _PaymentHistoryItem({
    required this.orderId,
    required this.nama,
    required this.model,
    required this.seller,
    required this.total,
    required this.date,
    required this.method,
    required this.status,
  });
}

// ── Payment picker sheet ──────────────────────────────────────────────────────

class _PaymentPickerSheet extends StatelessWidget {
  final _PaymentOption? selected;
  final ValueChanged<_PaymentOption> onSelect;
  final ScrollController scrollController;

  const _PaymentPickerSheet({
    required this.selected,
    required this.onSelect,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<_PaymentOption>>{};
    for (final opt in _paymentOptions) {
      groups.putIfAbsent(opt.group, () => []).add(opt);
    }
    return Column(
      children: [
        // Fixed handle + title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(
                    color: Color(0xFF121111),
                    fontSize: 15,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
        // Scrollable options
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              for (final entry in groups.entries) ...[
                Text(entry.key,
                    style: const TextStyle(
                        color: Color(0xFF787676),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                for (final opt in entry.value)
                  _PaymentTile(
                    option: opt,
                    isSelected: selected?.label == opt.label,
                    onTap: () => onSelect(opt),
                  ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final _PaymentOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E4FF) : const Color(0xFFF7F7FB),
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: isSelected ? kPurple : const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: option.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(option.icon, color: option.color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.label,
                style: TextStyle(
                    color: isSelected ? kPurple : const Color(0xFF121111),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: kPurple, size: 20),
          ],
        ),
      ),
    );
  }
}
