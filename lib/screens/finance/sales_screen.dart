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
  final FocusNode _searchFocus = FocusNode();
  bool _isSearching = false;

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
      final matchesQuery = query.isEmpty ||
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
    _searchFocus.dispose();
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
              isSearching: _isSearching,
              searchController: _searchC,
              searchFocusNode: _searchFocus,
              onSearchChanged: (_) => setState(() {}),
              onOpenSearch: () {
                setState(() => _isSearching = true);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _searchFocus.requestFocus();
                });
              },
              onCloseSearch: () {
                _searchC.clear();
                _searchFocus.unfocus();
                setState(() => _isSearching = false);
              },
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
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
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
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String? prevRoute;
  final bool isSearching;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onOpenSearch;
  final VoidCallback onCloseSearch;
  final VoidCallback onClearSearch;

  const _Header({
    this.prevRoute,
    required this.isSearching,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
    required this.onOpenSearch,
    required this.onCloseSearch,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
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
              if (isSearching)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _HeaderSearchField(
                          controller: searchController,
                          focusNode: searchFocusNode,
                          onChanged: onSearchChanged,
                          onClear: onClearSearch,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _HeaderIcon(
                        icon: Icons.close_rounded,
                        onTap: onCloseSearch,
                      ),
                    ],
                  ),
                )
              else ...[
                _HeaderIcon(
                  icon: Icons.arrow_back_ios_new_rounded,
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
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Penjualan',
                    style: TextStyle(
                      color: Theme.of(context).appColors.card,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _HeaderIcon(
                  icon: Icons.search_rounded,
                  onTap: onOpenSearch,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _HeaderSearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).appColors.card.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari invoice, pelanggan, produk...',
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).appColors.card,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, color: Colors.white70, size: 18),
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
          color: Theme.of(context).appColors.card.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Theme.of(context).appColors.card.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Theme.of(context).appColors.card, size: 20),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
    final stepX = widget.values.length == 1
        ? 0.0
        : usableWidth / (widget.values.length - 1);

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
          final bubbleLeft = (point.dx - (bubbleWidth / 2))
              .clamp(0.0, size.width - bubbleWidth);
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
        : Color(0xFFEA580C);
  }

  Color get sourceBg {
    return item.source == 'Marketplace' ? Color(0xFFEAF2FF) : Color(0xFFFFEFE5);
  }

  IconData get sourceIcon {
    return item.source == 'Marketplace'
        ? Icons.storefront_outlined
        : Icons.store_mall_directory_outlined;
  }

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
