import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/widgets/app_bottom_nav.dart';

const Color kPurple = Color(0xFF6B257F);
const Color kBg = Color(0xFFF7F7FB);
const List<double> _marketplaceWeekValues = [
  0.49,
  0.58,
  0.61,
  0.57,
  0.68,
  0.72,
  0.94,
];
const List<double> _offlineWeekValues = [
  0.53,
  0.58,
  0.55,
  0.63,
  0.68,
  0.74,
  0.84,
];
const List<String> _weekChartLabels = [
  '12 Apr',
  '13 Apr',
  '14 Apr',
  '15 Apr',
  '16 Apr',
  '17 Apr',
  '18 Apr',
];

class SalesScreen extends StatefulWidget {
  final String? prevRoute;

  const SalesScreen({super.key, this.prevRoute});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController _searchC = TextEditingController();

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
    final query = _searchC.text.trim().toLowerCase();
    return _sales.where((e) {
      final matchesQuery =
          query.isEmpty ||
          e.source.toLowerCase().contains(query) ||
          e.invoice.toLowerCase().contains(query) ||
          e.customer.toLowerCase().contains(query) ||
          e.product.toLowerCase().contains(query);
      return matchesQuery;
    }).toList();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              prevRoute: widget.prevRoute,
              searchController: _searchC,
              onSearchChanged: (_) => setState(() {}),
              onClearSearch: () {
                _searchC.clear();
                setState(() {});
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _TotalSalesCard(),
                    const SizedBox(height: 18),
                    _ChannelSummary(query: _searchC.text),
                    const SizedBox(height: 18),
                    const _SectionTitle(title: 'Daftar Transaksi Penjualan'),
                    const SizedBox(height: 12),
                    ..._filteredSales.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SaleCard(
                          item: item,
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                                pageBuilder: (_, __, ___) =>
                                    _SalesDetailScreen(
                                  item: item,
                                  prevRoute: widget.prevRoute,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BottomActionBar(
            onTambahOffline: () => _showMessage('Tambah penjualan offline'),
            onSinkronMarketplace: () =>
                _showMessage('Sinkron penjualan dari marketplace'),
          ),
          const AppBottomNav(activeIndex: -1),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String? prevRoute;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const _Header({
    this.prevRoute,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CircleIconButton(
                icon: Icons.arrow_back_ios_new,
                iconColor: Colors.black87,
                onTap: () {
                  if (prevRoute != null && prevRoute!.isNotEmpty) {
                    context.go(prevRoute!);
                  } else if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SearchPill(
                  controller: searchController,
                  hint: 'Cari invoice, pelanggan, produk...',
                  onChanged: onSearchChanged,
                  onClear: onClearSearch,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Penjualan',
            style: TextStyle(
              color: Theme.of(context).appColors.ink,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

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
                hintStyle: TextStyle(
                  color: Theme.of(context).appColors.muted,
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

class _ChannelSummary extends StatelessWidget {
  final String query;

  const _ChannelSummary({required this.query});

  @override
  Widget build(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final showMarketplace =
        normalized.isEmpty || 'marketplace'.contains(normalized);
    final showOffline = normalized.isEmpty || 'offline'.contains(normalized);

    final cards = <Widget>[
      if (showMarketplace)
        const Expanded(
          child: _SummaryCard(
            title: 'Marketplace',
            value: 'Rp 7.250.000',
            subtitle: '2 transaksi',
            icon: Icons.storefront_outlined,
            chartValues: _marketplaceWeekValues,
            chartColor: Color(0xFF2563EB),
            chartLabels: _weekChartLabels,
          ),
        ),
      if (showMarketplace && showOffline) const SizedBox(width: 12),
      if (showOffline)
        const Expanded(
          child: _SummaryCard(
            title: 'Offline',
            value: 'Rp 5.000.000',
            subtitle: '2 transaksi',
            icon: Icons.store_mall_directory_outlined,
            chartValues: _offlineWeekValues,
            chartColor: Color(0xFFEA580C),
            chartLabels: _weekChartLabels,
          ),
        ),
    ];

    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(children: cards);
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final List<double> chartValues;
  final Color chartColor;
  final List<String> chartLabels;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.chartValues,
    required this.chartColor,
    required this.chartLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: chartColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: chartColor),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Theme.of(context).appColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 72,
                  child: _MiniLineChart(
                    values: chartValues,
                    color: chartColor,
                    labels: chartLabels,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(context).appColors.ink,
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

class _TotalSalesCard extends StatelessWidget {
  const _TotalSalesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B257F), Color(0xFF8E44AD)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Total Penjualan',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '18 April 2026',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Rp 12.250.000',
            style: TextStyle(
              color: Theme.of(context).appColors.card,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '4 transaksi masuk hari ini',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniLineChart extends StatefulWidget {
  final List<double> values;
  final Color color;
  final List<String> labels;

  const _MiniLineChart({
    required this.values,
    required this.color,
    required this.labels,
  });

  @override
  State<_MiniLineChart> createState() => _MiniLineChartState();
}

class _MiniLineChartState extends State<_MiniLineChart> {
  int? _selectedIndex;

  void _selectPoint(Offset localPosition, double width) {
    if (widget.values.isEmpty) return;
    const horizontalPadding = 4.0;
    final usableWidth = width - (horizontalPadding * 2);
    final stepX =
        widget.values.length == 1 ? 0.0 : usableWidth / (widget.values.length - 1);

    var bestIndex = 0;
    var bestDistance = double.infinity;
    for (var i = 0; i < widget.values.length; i++) {
      final pointX = horizontalPadding + (stepX * i);
      final distance = (localPosition.dx - pointX).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        bestIndex = i;
      }
    }
    setState(() => _selectedIndex = bestIndex);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) =>
              _selectPoint(details.localPosition, constraints.maxWidth),
          onHorizontalDragStart: (details) =>
              _selectPoint(details.localPosition, constraints.maxWidth),
          onHorizontalDragUpdate: (details) =>
              _selectPoint(details.localPosition, constraints.maxWidth),
          child: CustomPaint(
            size: const Size(double.infinity, 72),
            painter: _MiniLineChartPainter(
              values: widget.values,
              color: widget.color,
              labels: widget.labels,
              selectedIndex: _selectedIndex,
            ),
          ),
        );
      },
    );
  }
}

class _MiniLineChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final List<String> labels;
  final int? selectedIndex;

  const _MiniLineChartPainter({
    required this.values,
    required this.color,
    required this.labels,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    const horizontalPadding = 4.0;
    const verticalPadding = 6.0;
    const tooltipHeight = 22.0;
    final usableWidth = size.width - (horizontalPadding * 2);
    final usableHeight = size.height - (verticalPadding * 2) - tooltipHeight;
    final stepX = values.length == 1 ? 0.0 : usableWidth / (values.length - 1);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.20),
          color.withValues(alpha: 0.02),
        ],
      ).createShader(Offset.zero & size);

    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    for (var i = 1; i <= 2; i++) {
      final y = verticalPadding + (usableHeight / 3) * i;
      canvas.drawLine(
        Offset(horizontalPadding, y),
        Offset(size.width - horizontalPadding, y),
        gridPaint,
      );
    }

    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = horizontalPadding + (stepX * i);
      final y =
          verticalPadding + ((1 - values[i].clamp(0.0, 1.0)) * usableHeight);
      points.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height - verticalPadding)
      ..lineTo(points.first.dx, size.height - verticalPadding)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()..color = color;
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final isSelected = selectedIndex == i;
      canvas.drawCircle(point, isSelected ? 4 : 2.8, dotPaint);

      if (isSelected) {
        final guidePaint = Paint()
          ..color = color.withValues(alpha: 0.32)
          ..strokeWidth = 1.2;
        canvas.drawLine(
          Offset(point.dx, verticalPadding),
          Offset(point.dx, size.height - verticalPadding),
          guidePaint,
        );
        canvas.drawCircle(
          point,
          8,
          Paint()..color = color.withValues(alpha: 0.12),
        );

        if (i < labels.length) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: labels[i],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
            textDirection: TextDirection.ltr,
            maxLines: 1,
          )..layout();

          final bubbleWidth = textPainter.width + 14;
          final bubbleLeft =
              (point.dx - (bubbleWidth / 2)).clamp(0.0, size.width - bubbleWidth);
          final bubbleRect = RRect.fromRectAndRadius(
            Rect.fromLTWH(bubbleLeft, 0, bubbleWidth, 20),
            const Radius.circular(999),
          );

          canvas.drawRRect(bubbleRect, Paint()..color = color);
          textPainter.paint(
            canvas,
            Offset(
              bubbleLeft + ((bubbleWidth - textPainter.width) / 2),
              (20 - textPainter.height) / 2,
            ),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MiniLineChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.color != color ||
        oldDelegate.labels != labels ||
        oldDelegate.selectedIndex != selectedIndex;
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
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).appColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).appColors.ink,
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
      style: TextStyle(
        color: Theme.of(context).appColors.ink,
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

Color _saleStatusColor(String status) {
  switch (status) {
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

Color _saleStatusBg(String status) {
  switch (status) {
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

Color _saleSourceColor(String source) {
  return source == 'Marketplace'
      ? const Color(0xFF2563EB)
      : const Color(0xFFEA580C);
}

Color _saleSourceBg(String source) {
  return source == 'Marketplace'
      ? const Color(0xFFEAF2FF)
      : const Color(0xFFFFEFE5);
}

IconData _saleSourceIcon(String source) {
  return source == 'Marketplace'
      ? Icons.storefront_outlined
      : Icons.store_mall_directory_outlined;
}

class _SaleCard extends StatelessWidget {
  final _SaleItem item;
  final VoidCallback onTap;

  const _SaleCard({
    required this.item,
    required this.onTap,
  });

  Color get statusColor {
    return _saleStatusColor(item.status);
  }

  Color get statusBg {
    return _saleStatusBg(item.status);
  }

  Color get sourceColor {
    return _saleSourceColor(item.source);
  }

  Color get sourceBg {
    return _saleSourceBg(item.source);
  }

  IconData get sourceIcon {
    return _saleSourceIcon(item.source);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
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
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product,
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.customer,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.amount,
                          style: TextStyle(
                            color: Theme.of(context).appColors.ink,
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
      ),
    );
  }
}

class _SalesDetailScreen extends StatelessWidget {
  final _SaleItem item;
  final String? prevRoute;

  const _SalesDetailScreen({
    required this.item,
    this.prevRoute,
  });

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else if (prevRoute != null && prevRoute!.isNotEmpty) {
      context.go('/sales?prev=${Uri.encodeComponent(prevRoute!)}');
    } else {
      context.go('/sales');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColors.card,
      bottomNavigationBar: const AppBottomNav(activeIndex: -1),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new,
                    iconColor: Theme.of(context).appColors.ink,
                    onTap: () => _handleBack(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Detail Penjualan',
                      style: TextStyle(
                        color: Theme.of(context).appColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SaleDetailHero(item: item),
                    const SizedBox(height: 16),
                    _SaleDetailInfoCard(item: item),
                    const SizedBox(height: 16),
                    _SalePaymentStatusCard(item: item),
                    const SizedBox(height: 16),
                    _SaleTimelineCard(item: item),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleDetailCard extends StatelessWidget {
  final Widget child;

  const _SaleDetailCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).appColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0CB3B3B3),
            blurRadius: 40,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SaleDetailHero extends StatelessWidget {
  final _SaleItem item;

  const _SaleDetailHero({required this.item});

  @override
  Widget build(BuildContext context) {
    final sourceColor = _saleSourceColor(item.source);
    final sourceBg = _saleSourceBg(item.source);
    final statusColor = _saleStatusColor(item.status);
    final statusBg = _saleStatusBg(item.status);

    return _SaleDetailCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: sourceBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _saleSourceIcon(item.source),
              color: sourceColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).appColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.customer,
                  style: TextStyle(
                    color: Theme.of(context).appColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _DetailChip(
                      text: item.status,
                      color: statusColor,
                      background: statusBg,
                    ),
                    _DetailChip(
                      text: item.source,
                      color: sourceColor,
                      background: sourceBg,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleDetailInfoCard extends StatelessWidget {
  final _SaleItem item;

  const _SaleDetailInfoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _SaleDetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Informasi Transaksi'),
          const SizedBox(height: 12),
          _InfoRow(label: 'Invoice', value: item.invoice),
          _InfoRow(label: 'Tanggal', value: item.date),
          _InfoRow(label: 'Pelanggan', value: item.customer),
          _InfoRow(label: 'Produk', value: item.product),
          _InfoRow(label: 'Jumlah', value: item.qty),
          _InfoRow(label: 'Total', value: item.amount, strong: true),
        ],
      ),
    );
  }
}

class _SalePaymentStatusCard extends StatelessWidget {
  final _SaleItem item;

  const _SalePaymentStatusCard({required this.item});

  String get _title {
    switch (item.status) {
      case 'Selesai':
        return 'Pembayaran lunas';
      case 'DP':
        return 'Down payment diterima';
      case 'Diproses':
        return 'Menunggu penyelesaian';
      default:
        return 'Status pembayaran';
    }
  }

  String get _subtitle {
    switch (item.status) {
      case 'Selesai':
        return 'Transaksi sudah selesai dan masuk laporan penjualan.';
      case 'DP':
        return 'Transaksi masih menunggu pelunasan dari pelanggan.';
      case 'Diproses':
        return 'Pesanan sedang diproses sebelum transaksi ditutup.';
      default:
        return 'Pantau status transaksi secara berkala.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _saleStatusColor(item.status);

    return _SaleDetailCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.receipt_long_outlined, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: TextStyle(
                    color: Theme.of(context).appColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _subtitle,
                  style: TextStyle(
                    color: Theme.of(context).appColors.muted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
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

class _SaleTimelineCard extends StatelessWidget {
  final _SaleItem item;

  const _SaleTimelineCard({required this.item});

  List<_SaleTimelineStep> get _steps {
    if (item.status == 'Selesai') {
      return const [
        _SaleTimelineStep('Invoice dibuat', 'Transaksi dicatat ke sistem', true),
        _SaleTimelineStep('Pembayaran diterima', 'Dana penjualan masuk', true),
        _SaleTimelineStep('Transaksi selesai', 'Order sudah ditutup', true),
      ];
    }

    if (item.status == 'DP') {
      return const [
        _SaleTimelineStep('Invoice dibuat', 'Transaksi dicatat ke sistem', true),
        _SaleTimelineStep('DP diterima', 'Menunggu sisa pembayaran', true),
        _SaleTimelineStep('Pelunasan', 'Belum selesai', false),
      ];
    }

    return const [
      _SaleTimelineStep('Invoice dibuat', 'Transaksi dicatat ke sistem', true),
      _SaleTimelineStep('Pesanan diproses', 'Tim sedang menyiapkan order', true),
      _SaleTimelineStep('Transaksi selesai', 'Belum selesai', false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps;

    return _SaleDetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Riwayat Penjualan'),
          const SizedBox(height: 12),
          ...steps.map(
            (step) => _SaleTimelineRow(
              step: step,
              isLast: step == steps.last,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleTimelineStep {
  final String title;
  final String subtitle;
  final bool done;

  const _SaleTimelineStep(this.title, this.subtitle, this.done);
}

class _SaleTimelineRow extends StatelessWidget {
  final _SaleTimelineStep step;
  final bool isLast;

  const _SaleTimelineRow({
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = step.done ? kPurple : Theme.of(context).appColors.border;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 3),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 42,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).appColors.border,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    color: Theme.of(context).appColors.ink,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.subtitle,
                  style: TextStyle(
                    color: Theme.of(context).appColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

class _DetailChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color background;

  const _DetailChip({
    required this.text,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
        ),
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
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card,
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
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onTambahOffline,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: Size.fromHeight(46),
                ),
                child: Text(
                  'Tambah Offline',
                  style: TextStyle(
                    color: Theme.of(context).appColors.card,
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
