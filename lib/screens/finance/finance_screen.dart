// keuangan.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/widgets/app_bottom_nav.dart';

// ✅ sesuaikan path sesuai struktur kamu

const kPurple = Color(0xFF6B257F);

class FinanceScreen extends StatelessWidget {
  FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // dummy angka (nanti bisa dari API)
    const totalBalance = 'Rp 7.783.000';
    const totalIncome = 'Rp 3.200.000';
    const totalExpense = 'Rp 1.187.400';

    // dummy target
    const target = 'Rp 20.000.000';
    const progressValue = 0.30; // 30%

    // ✅ dummy hutang piutang
    const totalHutang = 'Rp 2.450.000';
    const totalPiutang = 'Rp 5.120.000';

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.bg,
      bottomNavigationBar: AppBottomNav(activeIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              decoration: const BoxDecoration(
                color: kPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // top bar
                  Row(
                    children: [
                      _HeaderIcon(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => context.pop(),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Keuangan',
                          style: TextStyle(
                            color: Theme.of(context).appColors.card,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      _HeaderIcon(
                        icon: Icons.home_filled,
                        onTap: () => context.go('/home'),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // balance card (di dalam header)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .appColors
                          .card
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: Theme.of(context)
                              .appColors
                              .card
                              .withValues(alpha: 0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          totalBalance,
                          style: TextStyle(
                            color: Theme.of(context).appColors.card,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: const [
                            Expanded(
                              child: _MiniStat(
                                label: 'Pemasukan',
                                value: totalIncome,
                                icon: Icons.trending_up_rounded,
                                valueColor: Color(0xFFF1FFF3),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _MiniStat(
                                label: 'Pengeluaran',
                                value: totalExpense,
                                icon: Icons.trending_down_rounded,
                                valueColor: Color(0xFFFFC2D1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14),

                  // target progress + hutang/piutang
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .appColors
                          .card
                          .withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: Theme.of(context)
                              .appColors
                              .card
                              .withValues(alpha: 0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Target Bulanan',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            Text(
                              target,
                              style: TextStyle(
                                color: Theme.of(context).appColors.card,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        // progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: progressValue,
                            minHeight: 10,
                            backgroundColor: Theme.of(context)
                                .appColors
                                .card
                                .withValues(alpha: 0.18),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFF1FFF3),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        Text(
                          '${(progressValue * 100).round()}% dari target, lanjutkan.',
                          style: TextStyle(
                            color: Theme.of(context).appColors.card,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ✅ JEJERAN HUTANG & PIUTANG
                        Row(
                          children: const [
                            Expanded(
                              child: _MiniStat(
                                label: 'Hutang',
                                value: totalHutang,
                                icon: Icons.credit_card_rounded,
                                valueColor: Color(0xFFFFC2D1),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _MiniStat(
                                label: 'Piutang',
                                value: totalPiutang,
                                icon: Icons.account_balance_wallet_rounded,
                                valueColor: Color(0xFFF1FFF3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= BODY =================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu Keuangan',
                      style: TextStyle(
                        color: Theme.of(context).appColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 12),
                    _MenuGridKeuangan(),
                    SizedBox(height: 18),
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

// ================= HEADER ICON =================
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

// ================= MINI STAT =================
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context).appColors.card.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).appColors.card.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Icon(icon, color: Theme.of(context).appColors.card, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
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

// ===== MODEL MENU =====
class _FinanceMenu {
  final String label;
  final String desc;
  final IconData icon;

  const _FinanceMenu({
    required this.label,
    required this.desc,
    required this.icon,
  });
}

// ===== GRID MENU (2 KOLOM CARD) =====
class _MenuGridKeuangan extends StatelessWidget {
  const _MenuGridKeuangan({super.key});

  static const menus = [
    _FinanceMenu(
      label: 'Keuangan Proyek',
      desc: 'Cashflow per project',
      icon: Icons.savings_rounded,
    ),
    _FinanceMenu(
      label: 'Operasional',
      desc: 'BBM, logistik, dll',
      icon: Icons.local_shipping_rounded,
    ),
    _FinanceMenu(
      label: 'Pemasukan',
      desc: 'Invoice & pembayaran',
      icon: Icons.trending_up_rounded,
    ),
    _FinanceMenu(
      label: 'Pengeluaran',
      desc: 'Pembelian & biaya',
      icon: Icons.trending_down_rounded,
    ),
    _FinanceMenu(
      label: 'Promosi',
      desc: 'Iklan & campaign',
      icon: Icons.percent_rounded,
    ),
    _FinanceMenu(
      label: 'Rencana Belanja',
      desc: 'Plan kebutuhan',
      icon: Icons.shopping_bag_outlined,
    ),
    _FinanceMenu(
      label: 'Rugi Laba',
      desc: 'Laporan profit',
      icon: Icons.bar_chart_rounded,
    ),
    _FinanceMenu(
      label: 'Upah',
      desc: 'Gaji & borongan',
      icon: Icons.work_outline_rounded,
    ),
  ];

  void _handleTap(BuildContext context, String label) {
    if (label == 'Keuangan Proyek') {
      context.push('/project-finance');
      return;
    }
    if (label == 'Operasional') {
      context.push('/operational');
      return;
    }
    if (label == 'Pemasukan') {
      context.push('/income');
      return;
    }
    if (label == 'Pengeluaran') {
      context.push('/expense');
      return;
    }
    if (label == 'Promosi') {
      context.push('/promotion');
      return;
    }
    if (label == 'Rencana Belanja') {
      context.push('/shopping-plan');
      return;
    }
    if (label == 'Rugi Laba') {
      context.push('/profit-loss');
      return;
    }
    if (label == 'Upah') {
      context.push('/wage');
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label (belum dibuat)')));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final item = menus[index];
        return _FinanceCard(
          item: item,
          onTap: () => _handleTap(context, item.label),
        );
      },
    );
  }
}

class _FinanceCard extends StatelessWidget {
  final _FinanceMenu item;
  final VoidCallback onTap;

  const _FinanceCard({required this.item, required this.onTap});

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
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(0xFFF3E4FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item.icon, color: kPurple, size: 22),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: kPurple, size: 18),
          ],
        ),
      ),
    );
  }
}
