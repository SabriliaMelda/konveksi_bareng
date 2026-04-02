// listrik.dart
import 'package:flutter/material.dart';

const Color kPurple = Color(0xFF6B257F);

class ListrikScreen extends StatefulWidget {
  const ListrikScreen({super.key});

  @override
  State<ListrikScreen> createState() => _ListrikScreenState();
}

class _ListrikScreenState extends State<ListrikScreen> {
  // ===== Dummy data =====
  final DateTime _deadline = DateTime.now().add(const Duration(days: 5));

  final _BillNow _currentBill = _BillNow(
    periodLabel: 'Periode Jan 2026',
    amount: 975000,
    status: _BillStatus.belumBayar,
    kwh: 1210,
  );

  // 12 bulan terakhir (dummy)
  late final List<_MonthlyPay> _last12 = _buildLast12();

  List<_MonthlyPay> _buildLast12() {
    final now = DateTime.now();
    // dari bulan sekarang mundur 11
    final list = <_MonthlyPay>[];
    final amounts = <int>[
      910000,
      945000,
      980000,
      875000,
      920000,
      890000,
      930000,
      960000,
      905000,
      940000,
      970000,
      975000,
    ];
    for (int i = 0; i < 12; i++) {
      final d = DateTime(now.year, now.month - (11 - i), 1);
      list.add(
        _MonthlyPay(
          month: d,
          amount: amounts[i],
          paidAt: DateTime(d.year, d.month, 18),
        ),
      );
    }
    return list;
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
      'Des',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _fmtMonth(DateTime d) {
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
      'Des',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

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

  int get _avg12 {
    if (_last12.isEmpty) return 0;
    final sum = _last12.fold<int>(0, (a, b) => a + b.amount);
    return (sum / _last12.length).round();
  }

  int get _max12 => _last12.isEmpty
      ? 0
      : _last12.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  int get _min12 => _last12.isEmpty
      ? 0
      : _last12.map((e) => e.amount).reduce((a, b) => a < b ? a : b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0xFFDFDEDE)),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Text(
                    'Listrik',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Encode Sans',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF121111),
                      height: 1.4,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0xFFDFDEDE)),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.home_filled,
                        size: 20,
                        color: kPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  // ===== TANGGAL DEADLINE =====
                  _InfoCard(
                    title: 'Tanggal deadline',
                    icon: Icons.event_available_rounded,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _fmtDate(_deadline),
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        _Chip(
                          text: _daysLeftText(_deadline),
                          bg: const Color(0xFFEFE7F3),
                          fg: kPurple,
                          border: kPurple.withOpacity(.25),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== TAGIHAN (CURRENT) =====
                  _InfoCard(
                    title: 'Tagihan',
                    icon: Icons.receipt_long_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _currentBill.periodLabel,
                                style: const TextStyle(
                                  color: Color(0xFF6A707C),
                                  fontSize: 12,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            _Chip(
                              text: _currentBill.status == _BillStatus.lunas
                                  ? 'Lunas'
                                  : 'Belum bayar',
                              bg: _currentBill.status == _BillStatus.lunas
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFEBEE),
                              fg: _currentBill.status == _BillStatus.lunas
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFD32F2F),
                              border: _currentBill.status == _BillStatus.lunas
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFD32F2F),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _rupiah(_currentBill.amount),
                          style: const TextStyle(
                            color: kPurple,
                            fontSize: 22,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _MiniStat(
                                label: 'kWh',
                                value: '${_currentBill.kwh}',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _MiniStat(
                                label: 'Rata-rata 12 bln',
                                value: _rupiah(_avg12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _GhostButton(
                                icon: Icons.picture_as_pdf_outlined,
                                text: 'Export PDF',
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Export PDF listrik (dummy)',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _GhostButton(
                                icon: Icons.payment_rounded,
                                text: 'Bayar',
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bayar listrik (dummy)'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== PEMBAYARAN 12 BULAN TERAKHIR =====
                  _InfoCard(
                    title: 'Pembayaran 12 bulan terakhir',
                    icon: Icons.history_rounded,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _MiniStat(
                                label: 'Tertinggi',
                                value: _rupiah(_max12),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _MiniStat(
                                label: 'Terendah',
                                value: _rupiah(_min12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ..._last12.map((m) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _RowItem(
                              left: _fmtMonth(m.month),
                              mid: 'Dibayar: ${_fmtDate(m.paidAt)}',
                              right: _rupiah(m.amount),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== GRAFIK PENGELUARAN LISTRIK =====
                  _InfoCard(
                    title: 'Grafik pengeluaran listrik',
                    icon: Icons.bar_chart_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: _BarChart12Months(
                            values: _last12.map((e) => e.amount).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Catatan: grafik masih dummy (tanpa API).',
                          style: TextStyle(
                            color: Color(0xFF6A707C),
                            fontSize: 11.5,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _daysLeftText(DateTime deadline) {
    final today = DateTime.now();
    final a = DateTime(today.year, today.month, today.day);
    final b = DateTime(deadline.year, deadline.month, deadline.day);
    final diff = b.difference(a).inDays;
    if (diff < 0) return 'Terlambat';
    if (diff == 0) return 'Hari ini';
    return '$diff hari lagi';
  }
}

//
// ================== UI COMPONENTS ==================
//
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0CB3B3B3),
            blurRadius: 40,
            offset: Offset(0, 16),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kPurple, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF6A707C),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _GhostButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: kPurple),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: kPurple,
                fontSize: 12.5,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6A707C),
              fontSize: 11.5,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 12.5,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String left;
  final String mid;
  final String right;

  const _RowItem({required this.left, required this.mid, required this.right});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 32,
            child: Text(
              left,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 12.5,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            flex: 42,
            child: Text(
              mid,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF6A707C),
                fontSize: 11.5,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 26,
            child: Text(
              right,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 12.5,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final Color border;

  const _Chip({
    required this.text,
    required this.bg,
    required this.fg,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

//
// ================== SIMPLE BAR CHART (12 months) ==================
//
class _BarChart12Months extends StatelessWidget {
  final List<int> values;

  const _BarChart12Months({required this.values});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarChartPainter(values),
      child: const SizedBox.expand(),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<int> values;

  _BarChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxV = values.reduce((a, b) => a > b ? a : b).toDouble();
    final minV = values.reduce((a, b) => a < b ? a : b).toDouble();

    final pad = 10.0;
    final w = size.width - pad * 2;
    final h = size.height - pad * 2;

    final barCount = values.length;
    final gap = 6.0;
    final barW = (w - gap * (barCount - 1)) / barCount;

    // background grid (very subtle)
    final gridPaint = Paint()
      ..color = const Color(0xFFE8ECF4)
      ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      final y = pad + (h * (i / 4));
      canvas.drawLine(Offset(pad, y), Offset(pad + w, y), gridPaint);
    }

    // bar paint (purple)
    final barPaint = Paint()..color = kPurple.withOpacity(0.85);

    // min->max normalize
    double norm(int v) {
      if (maxV == 0) return 0;
      final vv = v.toDouble();
      // kalau min==max, tampilkan setengah tinggi
      if ((maxV - minV).abs() < 0.0001) return 0.6;
      return (vv - minV) / (maxV - minV);
    }

    for (int i = 0; i < barCount; i++) {
      final n = norm(values[i]).clamp(0.05, 1.0);
      final bh = h * n;
      final x = pad + i * (barW + gap);
      final y = pad + (h - bh);

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barW, bh),
        const Radius.circular(6),
      );
      canvas.drawRRect(rrect, barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    if (oldDelegate.values.length != values.length) return true;
    for (int i = 0; i < values.length; i++) {
      if (oldDelegate.values[i] != values[i]) return true;
    }
    return false;
  }
}

//
// ================== MODELS ==================
//
enum _BillStatus { lunas, belumBayar }

class _BillNow {
  final String periodLabel;
  final int amount;
  final _BillStatus status;
  final int kwh;

  const _BillNow({
    required this.periodLabel,
    required this.amount,
    required this.status,
    required this.kwh,
  });
}

class _MonthlyPay {
  final DateTime month;
  final int amount;
  final DateTime paidAt;

  const _MonthlyPay({
    required this.month,
    required this.amount,
    required this.paidAt,
  });
}
