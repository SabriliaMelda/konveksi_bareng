import 'dart:async';
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/main/home.dart';
import 'package:konveksi_bareng/services/payment_service.dart';

const Color kPurple = Color(0xFF6B257F);
const Color kBg = Color(0xFFF7F7FB);

// ── Helpers ───────────────────────────────────────────────────────────────────

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

String _fmtDate(DateTime d) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];
  final h = d.hour.toString().padLeft(2, '0');
  final m = d.minute.toString().padLeft(2, '0');
  return '${d.day} ${months[d.month - 1]} ${d.year} • $h:$m';
}

// ── Screen ────────────────────────────────────────────────────────────────────

class PaymentScreen extends StatefulWidget {
  /// Pass null to open in standalone/history mode (no active order).
  final OrderResult? order;

  const PaymentScreen({super.key, this.order});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late PaymentStatus _status;
  bool _isPolling = false;
  bool _isRetrying = false;

  // Countdown timer (24 h from order creation)
  Timer? _countdownTimer;
  Duration _remaining = Duration.zero;

  // History filter
  int _selectedFilter = 0;
  final List<String> _filters = const [
    'Semua',
    'Menunggu',
    'Berhasil',
    'Gagal'
  ];

  // Dummy history (would come from API in production)
  final List<_HistoryItem> _history = [
    _HistoryItem(
      orderId: 'INV-2026-001',
      nama: 'Kaos Oversize Basic',
      model: 'Basic Cotton 30s',
      seller: 'Konveksi Bareng',
      total: 1014000,
      date: '12 Mar 2026 • 10:15',
      method: 'Visa',
      status: PaymentStatus.pending,
    ),
    _HistoryItem(
      orderId: 'INV-2026-002',
      nama: 'Hoodie Premium Fleece',
      model: 'Premium Oversized',
      seller: 'Bareng Official',
      total: 459000,
      date: '10 Mar 2026 • 14:30',
      method: 'QRIS',
      status: PaymentStatus.success,
    ),
    _HistoryItem(
      orderId: 'INV-2026-003',
      nama: 'Jaket Windbreaker',
      model: 'Slim Fit Series',
      seller: 'Bareng Wear',
      total: 389000,
      date: '08 Mar 2026 • 09:05',
      method: 'GoPay',
      status: PaymentStatus.failed,
    ),
  ];

  OrderResult? get _order => widget.order;

  @override
  void initState() {
    super.initState();
    _status = _order?.status ?? PaymentStatus.pending;
    if (_order != null) {
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    final deadline = _order!.createdAt.add(const Duration(hours: 24));
    _updateRemaining(deadline);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _updateRemaining(deadline);
    });
  }

  void _updateRemaining(DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
  }

  String get _countdownText {
    if (_remaining == Duration.zero) return '00:00:00';
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<void> _checkStatus() async {
    if (_isPolling || _order == null) return;
    setState(() => _isPolling = true);
    try {
      final newStatus = await PaymentService.checkStatus(_order!.orderId);
      if (!mounted) return;
      setState(() {
        _status = newStatus;
        _order!.status = newStatus;
      });
      _showSnack(_statusMessage(newStatus));
    } catch (_) {
      if (mounted) _showSnack('Gagal mengambil status. Coba lagi.');
    } finally {
      if (mounted) setState(() => _isPolling = false);
    }
  }

  Future<void> _retryPayment() async {
    if (_isRetrying || _order == null) return;
    setState(() => _isRetrying = true);
    try {
      await PaymentService.retryPayment(_order!.orderId);
      if (!mounted) return;
      setState(() {
        _status = PaymentStatus.pending;
        _order!.status = PaymentStatus.pending;
      });
      _showSnack('Permintaan pembayaran ulang dikirim.');
    } catch (_) {
      if (mounted) _showSnack('Gagal. Coba lagi.');
    } finally {
      if (mounted) setState(() => _isRetrying = false);
    }
  }

  String _statusMessage(PaymentStatus s) {
    switch (s) {
      case PaymentStatus.pending:
        return 'Menunggu pembayaran...';
      case PaymentStatus.verifying:
        return 'Sedang diverifikasi...';
      case PaymentStatus.success:
        return 'Pembayaran berhasil!';
      case PaymentStatus.failed:
        return 'Pembayaran gagal.';
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  List<_HistoryItem> get _filteredHistory {
    final label = _filters[_selectedFilter];
    if (label == 'Semua') return _history;
    final map = {
      'Menunggu': PaymentStatus.pending,
      'Berhasil': PaymentStatus.success,
      'Gagal': PaymentStatus.failed,
    };
    return _history.where((e) => e.status == map[label]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              onHomeTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (r) => false,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Only show active order cards when an order is passed in
                    if (_order != null) ...[
                      _StatusCard(
                        status: _status,
                        countdown: _countdownText,
                        showCountdown: _status == PaymentStatus.pending,
                      ),
                      const SizedBox(height: 16),
                      _OrderInfoCard(order: _order!),
                      const SizedBox(height: 16),
                      _PaymentMethodCard(method: _order!.paymentMethod),
                      const SizedBox(height: 16),
                      _TimelineCard(status: _status, order: _order!),
                      const SizedBox(height: 24),
                    ],

                    // History section
                    const _SectionTitle(title: 'Riwayat Pembayaran'),
                    const SizedBox(height: 10),
                    _FilterChips(
                      filters: _filters,
                      selected: _selectedFilter,
                      onSelect: (i) => setState(() => _selectedFilter = i),
                    ),
                    const SizedBox(height: 12),
                    if (_filteredHistory.isEmpty)
                      const _EmptyHistory()
                    else
                      for (final item in _filteredHistory)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _HistoryCard(item: item),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        status: _status,
        hasOrder: _order != null,
        isPolling: _isPolling,
        isRetrying: _isRetrying,
        onCheckStatus: _checkStatus,
        onRetry: _retryPayment,
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

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
      child: Row(
        children: [
          _HeaderIcon(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Status Pembayaran',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900)),
          ),
          _HeaderIcon(icon: Icons.home_filled, onTap: onHomeTap),
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
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ── Status card ───────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final PaymentStatus status;
  final String countdown;
  final bool showCountdown;
  const _StatusCard(
      {required this.status,
      required this.countdown,
      required this.showCountdown});

  @override
  Widget build(BuildContext context) {
    final cfg = _statusConfig(status);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8))
        ],
        border: Border.all(color: cfg.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: cfg.iconBg, borderRadius: BorderRadius.circular(14)),
            child: Icon(cfg.icon, color: cfg.iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cfg.title,
                    style: TextStyle(
                        color: cfg.iconColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(cfg.subtitle,
                    style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        height: 1.45)),
                if (showCountdown) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4D8),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_outlined,
                                size: 14, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 4),
                            Text('Batas: $countdown',
                                style: const TextStyle(
                                    color: Color(0xFFF59E0B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  _StatusCfg _statusConfig(PaymentStatus s) {
    switch (s) {
      case PaymentStatus.pending:
        return _StatusCfg(
          icon: Icons.schedule_rounded,
          iconColor: const Color(0xFFF59E0B),
          iconBg: const Color(0xFFFFF4D8),
          borderColor: const Color(0xFFFFE4A0),
          title: 'Menunggu Pembayaran',
          subtitle:
              'Pesanan kamu sudah dibuat. Selesaikan pembayaran sebelum batas waktu.',
        );
      case PaymentStatus.verifying:
        return _StatusCfg(
          icon: Icons.sync_rounded,
          iconColor: const Color(0xFF2563EB),
          iconBg: const Color(0xFFEFF6FF),
          borderColor: const Color(0xFFBFDBFE),
          title: 'Sedang Diverifikasi',
          subtitle: 'Pembayaran kamu sedang diproses oleh sistem.',
        );
      case PaymentStatus.success:
        return _StatusCfg(
          icon: Icons.check_circle_rounded,
          iconColor: const Color(0xFF16A34A),
          iconBg: const Color(0xFFEAF8EE),
          borderColor: const Color(0xFFBBF7D0),
          title: 'Pembayaran Berhasil',
          subtitle: 'Terima kasih! Pesanan kamu sedang diproses.',
        );
      case PaymentStatus.failed:
        return _StatusCfg(
          icon: Icons.cancel_rounded,
          iconColor: const Color(0xFFDC2626),
          iconBg: const Color(0xFFFFE9E9),
          borderColor: const Color(0xFFFECACA),
          title: 'Pembayaran Gagal',
          subtitle:
              'Pembayaran tidak berhasil. Silakan coba lagi atau gunakan metode lain.',
        );
    }
  }
}

class _StatusCfg {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color borderColor;
  final String title;
  final String subtitle;
  const _StatusCfg(
      {required this.icon,
      required this.iconColor,
      required this.iconBg,
      required this.borderColor,
      required this.title,
      required this.subtitle});
}

// ── Order info card ───────────────────────────────────────────────────────────

class _OrderInfoCard extends StatelessWidget {
  final OrderResult order;
  const _OrderInfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final totalItems = order.items.fold(0, (s, i) => s + i.qty);
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Detail Pesanan'),
          const SizedBox(height: 12),
          _InfoRow(label: 'Order ID', value: order.orderId),
          _InfoRow(label: 'Tanggal', value: _fmtDate(order.createdAt)),
          _InfoRow(label: 'Jumlah Item', value: '$totalItems item'),
          const Divider(color: Color(0xFFEEEEEE), height: 20),
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.nama,
                            style: const TextStyle(
                                color: Color(0xFF24252C),
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                        Text('${item.model} • ${item.seller}',
                            style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Text('${item.qty}x ${_rupiah(item.harga)}',
                      style: const TextStyle(
                          color: kPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          const Divider(color: Color(0xFFEEEEEE), height: 20),
          _InfoRow(
              label: 'Total',
              value: _rupiah(order.totalAmount),
              isStrong: true),
        ],
      ),
    );
  }
}

// ── Payment method card ───────────────────────────────────────────────────────

class _PaymentMethodCard extends StatelessWidget {
  final String method;
  const _PaymentMethodCard({required this.method});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.payment_rounded, color: kPurple, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Metode Pembayaran',
                    style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(method,
                    style: const TextStyle(
                        color: Color(0xFF24252C),
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Timeline card ─────────────────────────────────────────────────────────────

class _TimelineCard extends StatelessWidget {
  final PaymentStatus status;
  final OrderResult order;
  const _TimelineCard({required this.status, required this.order});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _TimelineStep(
        title: 'Pesanan dibuat',
        subtitle: _fmtDate(order.createdAt),
        state: _StepState.done,
      ),
      _TimelineStep(
        title: 'Menunggu pembayaran',
        subtitle: status == PaymentStatus.pending
            ? 'Sedang menunggu...'
            : _fmtDate(order.createdAt.add(const Duration(seconds: 5))),
        state: status == PaymentStatus.pending
            ? _StepState.active
            : _StepState.done,
      ),
      _TimelineStep(
        title: 'Verifikasi pembayaran',
        subtitle: status == PaymentStatus.verifying
            ? 'Sedang diverifikasi...'
            : status == PaymentStatus.success || status == PaymentStatus.failed
                ? 'Selesai diverifikasi'
                : 'Menunggu konfirmasi',
        state: status == PaymentStatus.verifying
            ? _StepState.active
            : (status == PaymentStatus.success ||
                    status == PaymentStatus.failed)
                ? _StepState.done
                : _StepState.pending,
      ),
      _TimelineStep(
        title: status == PaymentStatus.failed
            ? 'Pembayaran gagal'
            : 'Pembayaran berhasil',
        subtitle: status == PaymentStatus.success
            ? 'Pesanan sedang diproses'
            : status == PaymentStatus.failed
                ? 'Silakan coba lagi'
                : 'Akan aktif setelah verifikasi',
        state: status == PaymentStatus.success
            ? _StepState.done
            : status == PaymentStatus.failed
                ? _StepState.failed
                : _StepState.pending,
        isLast: true,
      ),
    ];

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Progress Pembayaran'),
          const SizedBox(height: 12),
          for (final step in steps) _TimelineItem(step: step),
        ],
      ),
    );
  }
}

enum _StepState { done, active, pending, failed }

class _TimelineStep {
  final String title;
  final String subtitle;
  final _StepState state;
  final bool isLast;
  const _TimelineStep(
      {required this.title,
      required this.subtitle,
      required this.state,
      this.isLast = false});
}

class _TimelineItem extends StatelessWidget {
  final _TimelineStep step;
  const _TimelineItem({required this.step});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    Widget dotChild;
    switch (step.state) {
      case _StepState.done:
        dotColor = kPurple;
        dotChild = const Icon(Icons.check, size: 11, color: Colors.white);
        break;
      case _StepState.active:
        dotColor = const Color(0xFFF59E0B);
        dotChild = const Icon(Icons.more_horiz, size: 11, color: Colors.white);
        break;
      case _StepState.failed:
        dotColor = const Color(0xFFDC2626);
        dotChild = const Icon(Icons.close, size: 11, color: Colors.white);
        break;
      case _StepState.pending:
        dotColor = const Color(0xFFD1D5DB);
        dotChild = const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration:
                  BoxDecoration(color: dotColor, shape: BoxShape.circle),
              child: Center(child: dotChild),
            ),
            if (!step.isLast)
              Container(width: 2, height: 32, color: const Color(0xFFE5E7EB)),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title,
                    style: TextStyle(
                        color: step.state == _StepState.active
                            ? const Color(0xFFF59E0B)
                            : step.state == _StepState.failed
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF24252C),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(step.subtitle,
                    style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── History ───────────────────────────────────────────────────────────────────

class _HistoryItem {
  final String orderId;
  final String nama;
  final String model;
  final String seller;
  final int total;
  final String date;
  final String method;
  final PaymentStatus status;

  const _HistoryItem({
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

class _HistoryCard extends StatelessWidget {
  final _HistoryItem item;
  const _HistoryCard({required this.item});

  Color get _statusColor {
    switch (item.status) {
      case PaymentStatus.success:
        return const Color(0xFF16A34A);
      case PaymentStatus.pending:
      case PaymentStatus.verifying:
        return const Color(0xFFF59E0B);
      case PaymentStatus.failed:
        return const Color(0xFFDC2626);
    }
  }

  Color get _statusBg {
    switch (item.status) {
      case PaymentStatus.success:
        return const Color(0xFFEAF8EE);
      case PaymentStatus.pending:
      case PaymentStatus.verifying:
        return const Color(0xFFFFF4D8);
      case PaymentStatus.failed:
        return const Color(0xFFFFE9E9);
    }
  }

  String get _statusLabel {
    switch (item.status) {
      case PaymentStatus.success:
        return 'Berhasil';
      case PaymentStatus.pending:
        return 'Menunggu';
      case PaymentStatus.verifying:
        return 'Verifikasi';
      case PaymentStatus.failed:
        return 'Gagal';
    }
  }

  IconData get _statusIcon {
    switch (item.status) {
      case PaymentStatus.success:
        return Icons.check_circle_rounded;
      case PaymentStatus.pending:
      case PaymentStatus.verifying:
        return Icons.schedule_rounded;
      case PaymentStatus.failed:
        return Icons.cancel_rounded;
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
              color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8))
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
                color: _statusBg, borderRadius: BorderRadius.circular(14)),
            child: Icon(_statusIcon, color: _statusColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nama,
                    style: const TextStyle(
                        color: Color(0xFF24252C),
                        fontSize: 13,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text('${item.model} • ${item.seller}',
                    style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(item.orderId,
                    style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(_rupiah(item.total),
                          style: const TextStyle(
                              color: kPurple,
                              fontSize: 13,
                              fontWeight: FontWeight.w900)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: _statusBg,
                          borderRadius: BorderRadius.circular(999)),
                      child: Text(_statusLabel,
                          style: TextStyle(
                              color: _statusColor,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${item.date} • ${item.method}',
                    style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Color(0xFFD1D5DB)),
          SizedBox(height: 12),
          Text('Tidak ada riwayat',
              style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final PaymentStatus status;
  final bool hasOrder;
  final bool isPolling;
  final bool isRetrying;
  final VoidCallback onCheckStatus;
  final VoidCallback onRetry;

  const _BottomBar({
    required this.status,
    required this.hasOrder,
    required this.isPolling,
    required this.isRetrying,
    required this.onCheckStatus,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasOrder) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x12000000), blurRadius: 18, offset: Offset(0, -6))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Cek Status
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isPolling ? null : onCheckStatus,
                icon: isPolling
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: kPurple))
                    : const Icon(Icons.refresh_rounded, size: 16),
                label: Text(isPolling ? 'Mengecek...' : 'Cek Status'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPurple,
                  side: const BorderSide(color: kPurple),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size.fromHeight(46),
                  textStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Bayar Lagi / Selesai
            Expanded(
              child: status == PaymentStatus.success
                  ? ElevatedButton.icon(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (r) => false,
                      ),
                      icon: const Icon(Icons.home_rounded, size: 16),
                      label: const Text('Selesai'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        minimumSize: const Size.fromHeight(46),
                        textStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: isRetrying ? null : onRetry,
                      icon: isRetrying
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.replay_rounded, size: 16),
                      label: Text(isRetrying ? 'Memproses...' : 'Bayar Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        minimumSize: const Size.fromHeight(46),
                        textStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared small widgets ──────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8))
        ],
        border: Border.all(color: const Color(0x0FE8ECF4)),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
            color: Color(0xFF24252C),
            fontSize: 15,
            fontWeight: FontWeight.w900));
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStrong;
  const _InfoRow(
      {required this.label, required this.value, this.isStrong = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    color: isStrong ? kPurple : const Color(0xFF24252C),
                    fontSize: isStrong ? 13 : 11.5,
                    fontWeight: isStrong ? FontWeight.w900 : FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final List<String> filters;
  final int selected;
  final ValueChanged<int> onSelect;
  const _FilterChips(
      {required this.filters, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final active = selected == i;
          return InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active ? kPurple : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                    color: active ? kPurple : const Color(0xFFE8ECF4)),
              ),
              child: Text(filters[i],
                  style: TextStyle(
                      color: active ? Colors.white : const Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w800)),
            ),
          );
        },
      ),
    );
  }
}
