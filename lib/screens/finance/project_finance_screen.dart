// lib/pages/keuanganproyek.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const kPurple = Color(0xFF6B257F);

class ProjectFinanceScreen extends StatefulWidget {
  const ProjectFinanceScreen({super.key});

  @override
  State<ProjectFinanceScreen> createState() => _ProjectFinanceScreenState();
}

class _ProjectFinanceScreenState extends State<ProjectFinanceScreen> {
  _FinanceMenu _active = _FinanceMenu.keuanganPerproyek;
  String _activeProject = 'Keuangan Proyek 1 dst';

  final List<String> _projects = const [
    'Keuangan Proyek 1 dst',
    'Keuangan Proyek 2',
    'Keuangan Proyek 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ===== TOP BAR (mirip bookmark bar) =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Keuangan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
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

            const SizedBox(height: 10),

            // ===== "BOOKMARK" MENU ROW =====
            SizedBox(
              height: 46,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _BookmarkFolder(
                    label: 'Keuangan Perproyek',
                    active: _active == _FinanceMenu.keuanganPerproyek,
                    items: _projects,
                    onSelected: (v) {
                      setState(() {
                        _active = _FinanceMenu.keuanganPerproyek;
                        _activeProject = v;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _BookmarkFolder(
                    label: 'Operasional kantor',
                    active: _active == _FinanceMenu.operasional,
                    items: const ['Biaya listrik', 'Sewa', 'ATK', 'Internet'],
                    onSelected: (_) =>
                        setState(() => _active = _FinanceMenu.operasional),
                  ),
                  const SizedBox(width: 10),
                  _BookmarkFolder(
                    label: 'Pemasukan',
                    active: _active == _FinanceMenu.pemasukan,
                    items: const ['Invoice masuk', 'DP', 'Pelunasan'],
                    onSelected: (_) =>
                        setState(() => _active = _FinanceMenu.pemasukan),
                  ),
                  const SizedBox(width: 10),
                  _BookmarkFolder(
                    label: 'Pengeluaran',
                    active: _active == _FinanceMenu.pengeluaran,
                    items: const ['Material', 'Subkon', 'Transport', 'Lainnya'],
                    onSelected: (_) =>
                        setState(() => _active = _FinanceMenu.pengeluaran),
                  ),
                  const SizedBox(width: 10),
                  _BookmarkFolder(
                    label: 'Promosi',
                    active: _active == _FinanceMenu.promosi,
                    items: const ['Iklan', 'Konten', 'Event'],
                    onSelected: (_) =>
                        setState(() => _active = _FinanceMenu.promosi),
                  ),
                  const SizedBox(width: 10),
                  _BookmarkFolder(
                    label: 'Rencana Belanja',
                    active: _active == _FinanceMenu.rencanaBelanja,
                    items: const ['Draft pembelian', 'Disetujui', 'Ditolak'],
                    onSelected: (_) =>
                        setState(() => _active = _FinanceMenu.rencanaBelanja),
                  ),
                  const SizedBox(width: 10),
                  _BookmarkFolder(
                    label: 'Rugi Laba',
                    active: _active == _FinanceMenu.rugiLaba,
                    items: const ['Bulanan', 'Per Proyek', 'Tahunan'],
                    onSelected: (_) =>
                        setState(() => _active = _FinanceMenu.rugiLaba),
                  ),
                  const SizedBox(width: 10),
                  _BookmarkFolder(
                    label: 'Upah',
                    active: _active == _FinanceMenu.upah,
                    items: const ['Harian', 'Mingguan', 'Borongan'],
                    onSelected: (_) =>
                        setState(() => _active = _FinanceMenu.upah),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BreadCrumb(
                      left: 'Keuangan',
                      right: _active == _FinanceMenu.keuanganPerproyek
                          ? _activeProject
                          : _active.label,
                    ),
                    const SizedBox(height: 12),

                    // Summary cards
                    Row(
                      children: const [
                        Expanded(
                          child: _StatCard(
                            title: 'Saldo',
                            value: 'Rp 12.450.000',
                            subtitle: 'Update hari ini',
                            icon: Icons.account_balance_wallet_outlined,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Cashflow',
                            value: '+ Rp 2.150.000',
                            subtitle: '7 hari terakhir',
                            icon: Icons.trending_up_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Expanded(
                          child: _StatCard(
                            title: 'Pemasukan',
                            value: 'Rp 18.900.000',
                            subtitle: 'Bulan ini',
                            icon: Icons.arrow_downward_rounded,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Pengeluaran',
                            value: 'Rp 6.450.000',
                            subtitle: 'Bulan ini',
                            icon: Icons.arrow_upward_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Section title
                    Text(
                      _active == _FinanceMenu.keuanganPerproyek
                          ? _activeProject
                          : _active.label,
                      style: const TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // List dummy transaksi / data
                    _SectionCard(
                      title: 'Aktivitas Terbaru',
                      child: Column(
                        children: const [
                          _TxnRow(
                            title: 'Pembelian bahan baku',
                            subtitle: 'Material • INV-0021',
                            amount: '- Rp 1.250.000',
                            time: '10:12',
                          ),
                          _DividerSoft(),
                          _TxnRow(
                            title: 'DP dari klien',
                            subtitle: 'Pemasukan • PRO-01',
                            amount: '+ Rp 5.000.000',
                            time: '09:40',
                          ),
                          _DividerSoft(),
                          _TxnRow(
                            title: 'Upah harian',
                            subtitle: 'Upah • Minggu 2',
                            amount: '- Rp 450.000',
                            time: 'Kemarin',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    _SectionCard(
                      title: 'Aksi Cepat',
                      child: Row(
                        children: [
                          Expanded(
                            child: _QuickAction(
                              icon: Icons.add_circle_outline,
                              label: 'Tambah\nTransaksi',
                              onTap: () =>
                                  _toast(context, 'Tambah transaksi (dummy)'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _QuickAction(
                              icon: Icons.picture_as_pdf_outlined,
                              label: 'Export\nPDF',
                              onTap: () =>
                                  _toast(context, 'Export PDF (dummy)'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _QuickAction(
                              icon: Icons.grid_on_outlined,
                              label: 'Export\nExcel',
                              onTap: () =>
                                  _toast(context, 'Export Excel (dummy)'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

//
// ===================== ENUMS =====================
//
enum _FinanceMenu {
  keuanganPerproyek,
  operasional,
  pemasukan,
  pengeluaran,
  promosi,
  rencanaBelanja,
  rugiLaba,
  upah,
}

extension on _FinanceMenu {
  String get label => switch (this) {
    _FinanceMenu.keuanganPerproyek => 'Keuangan Perproyek',
    _FinanceMenu.operasional => 'Operasional kantor',
    _FinanceMenu.pemasukan => 'Pemasukan',
    _FinanceMenu.pengeluaran => 'Pengeluaran',
    _FinanceMenu.promosi => 'Promosi',
    _FinanceMenu.rencanaBelanja => 'Rencana Belanja',
    _FinanceMenu.rugiLaba => 'Rugi Laba',
    _FinanceMenu.upah => 'Upah',
  };
}

//
// ===================== UI WIDGETS =====================
//
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = const Color(0xFF1E232C),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF4)),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}

class _BookmarkFolder extends StatelessWidget {
  final String label;
  final bool active;
  final List<String> items;
  final ValueChanged<String> onSelected;

  const _BookmarkFolder({
    required this.label,
    required this.active,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bg = active ? kPurple.withOpacity(0.10) : Colors.white;
    final br = active ? kPurple.withOpacity(0.40) : const Color(0xFFE8ECF4);
    final txt = active ? kPurple : const Color(0xFF1E232C);

    return PopupMenuButton<String>(
      tooltip: label,
      onSelected: onSelected,
      offset: const Offset(0, 46),
      itemBuilder: (context) {
        return items
            .map(
              (e) => PopupMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ),
            )
            .toList();
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: br),
        ),
        child: Row(
          children: [
            Icon(Icons.folder_outlined, size: 18, color: txt),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: txt,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, size: 18, color: txt),
          ],
        ),
      ),
    );
  }
}

class _BreadCrumb extends StatelessWidget {
  final String left;
  final String right;

  const _BreadCrumb({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          left,
          style: const TextStyle(
            color: Color(0xFF6A707C),
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(
          Icons.chevron_right_rounded,
          size: 18,
          color: Color(0xFF6A707C),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1E232C),
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
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
            color: Color(0x0A000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: kPurple.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: kPurple, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF6A707C),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1E232C),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6A707C),
                    fontSize: 11.5,
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1E232C),
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _TxnRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String time;

  const _TxnRow({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final isPlus = amount.trim().startsWith('+');
    final amtColor = isPlus ? const Color(0xFF00BE49) : const Color(0xFFE53935);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: kPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.receipt_long_outlined,
            color: kPurple,
            size: 20,
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
                  fontSize: 12.5,
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
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: TextStyle(
                color: amtColor,
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                color: Color(0xFF6A707C),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DividerSoft extends StatelessWidget {
  const _DividerSoft();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFE8ECF4)),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7F8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF4)),
        ),
        child: Column(
          children: [
            Icon(icon, color: kPurple, size: 22),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1E232C),
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
