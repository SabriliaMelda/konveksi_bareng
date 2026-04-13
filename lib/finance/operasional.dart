// operasional.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/finance/electricity_screen.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

const Color kPurple = Color(0xFF6B257F);

class OperationalScreen extends StatefulWidget {
  const OperationalScreen({super.key});

  @override
  State<OperationalScreen> createState() => _OperationalScreenState();
}

class _OperationalScreenState extends State<OperationalScreen> {
  // submenu
  _OpTab _tab = _OpTab.input;

  // filter periode (dummy)
  _Period _period = _Period.bulanan;
  DateTimeRange? _customRange;

  final List<_OpTxn> _items = [
    _OpTxn(
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: 'BBM & Transport',
      note: 'Pengiriman bahan baku',
      amount: 175000,
      type: _OpType.pengeluaran,
    ),
    _OpTxn(
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Listrik & Internet',
      note: 'Tagihan bulanan',
      amount: 320000,
      type: _OpType.pengeluaran,
    ),
    _OpTxn(
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: 'ATK',
      note: 'Kertas, tinta, map',
      amount: 85000,
      type: _OpType.pengeluaran,
    ),
    _OpTxn(
      date: DateTime.now().subtract(const Duration(days: 5)),
      title: 'Perawatan Mesin',
      note: 'Service mesin jahit',
      amount: 250000,
      type: _OpType.pengeluaran,
    ),
    _OpTxn(
      date: DateTime.now().subtract(const Duration(days: 7)),
      title: 'Reimburse Driver',
      note: 'Parkir dan tol',
      amount: 60000,
      type: _OpType.pengeluaran,
    ),
  ];

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

  int get _totalExpense => _items
      .where((e) => e.type == _OpType.pengeluaran)
      .fold(0, (a, b) => a + b.amount);

  void _openEditSheet(_OpTxn e) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E7EE),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                e.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              _SheetAction(
                icon: Icons.edit_outlined,
                label: 'Edit transaksi (dummy)',
                color: kPurple,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Edit (dummy)')));
                },
              ),
              const SizedBox(height: 10),
              _SheetAction(
                icon: Icons.delete_outline_rounded,
                label: 'Hapus transaksi (dummy)',
                color: const Color(0xFFD32F2F),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hapus (dummy)')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================== ADD (PLUS) SHEET ==================
  void _openAddSheet() {
    final titleC = TextEditingController();
    final noteC = TextEditingController();
    final amountC = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E7EE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tambah Pengeluaran',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),

              _InputField(
                controller: titleC,
                label: 'Judul',
                hint: 'Contoh: BBM / ATK / Perawatan',
              ),
              const SizedBox(height: 10),
              _InputField(
                controller: noteC,
                label: 'Catatan',
                hint: 'Contoh: Pengiriman bahan baku',
              ),
              const SizedBox(height: 10),
              _InputField(
                controller: amountC,
                label: 'Nominal',
                hint: 'Contoh: 175000',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _GhostButton(
                      icon: Icons.close_rounded,
                      text: 'Batal',
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        final title = titleC.text.trim();
                        final note = noteC.text.trim();
                        final amt =
                            int.tryParse(amountC.text.replaceAll('.', '')) ?? 0;

                        if (title.isEmpty || amt <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Judul & nominal wajib diisi'),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _items.insert(
                            0,
                            _OpTxn(
                              date: DateTime.now(),
                              title: title,
                              note: note.isEmpty ? '-' : note,
                              amount: amt,
                              type: _OpType.pengeluaran,
                            ),
                          );
                        });

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pengeluaran ditambahkan (dummy)'),
                          ),
                        );
                      },
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: kPurple,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kPurple),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _TabPill(
              label: 'Input pengeluaran',
              active: _tab == _OpTab.input,
              onTap: () => setState(() => _tab = _OpTab.input),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TabPill(
              label: 'Edit',
              active: _tab == _OpTab.edit,
              onTap: () => setState(() => _tab = _OpTab.edit),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TabPill(
              label: 'Listrik',
              active: _tab == _OpTab.listrik,
              onTap: () async {
                setState(() => _tab = _OpTab.listrik);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ElectricityScreen()),
                );
                if (mounted) setState(() => _tab = _OpTab.input);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ ICON PLUS DI KANAN BAWAH
      floatingActionButton: _tab == _OpTab.input
          ? FloatingActionButton(
              backgroundColor: kPurple,
              foregroundColor: Colors.white,
              elevation: 3,
              onPressed: _openAddSheet,
              child: const Icon(Icons.add_rounded, size: 26),
            )
          : null,

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
                    'Operasional',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF121111),
                      height: 1.4,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
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

            const SizedBox(height: 8),

            // ===== SUB MENU =====
            _buildSubMenu(),

            const SizedBox(height: 12),

            // ===== CONTENT SWITCH =====
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _tab == _OpTab.edit
                    ? _buildEditMode()
                    : _buildInputMode(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== INPUT MODE ==================
  Widget _buildInputMode() {
    return Column(
      key: const ValueKey('input_mode'),
      children: [
        // ===== SUMMARY CARD =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
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
                const Text(
                  'Total Operasional',
                  style: TextStyle(
                    color: Color(0xFF6A707C),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _rupiah(_totalExpense),
                  style: const TextStyle(
                    color: kPurple,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _PeriodPill(
                        active: _period == _Period.harian,
                        label: 'Harian',
                        onTap: () => setState(() => _period = _Period.harian),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PeriodPill(
                        active: _period == _Period.mingguan,
                        label: 'Mingguan',
                        onTap: () => setState(() => _period = _Period.mingguan),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PeriodPill(
                        active: _period == _Period.bulanan,
                        label: 'Bulanan',
                        onTap: () => setState(() => _period = _Period.bulanan),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PeriodPill(
                        active: _period == _Period.custom,
                        label: 'Custom',
                        onTap: () async {
                          final now = DateTime.now();
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(now.year - 2),
                            lastDate: DateTime(now.year + 2),
                            initialDateRange:
                                _customRange ??
                                DateTimeRange(
                                  start: now.subtract(const Duration(days: 7)),
                                  end: now,
                                ),
                          );
                          if (picked != null) {
                            setState(() {
                              _period = _Period.custom;
                              _customRange = picked;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                if (_period == _Period.custom && _customRange != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    '${_fmtDate(_customRange!.start)} - ${_fmtDate(_customRange!.end)}',
                    style: const TextStyle(
                      color: Color(0xFF1E232C),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ===== ACTION ROW (EXPORT) =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _GhostButton(
                  icon: Icons.picture_as_pdf_outlined,
                  text: 'Export PDF',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export PDF (dummy)')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GhostButton(
                  icon: Icons.table_chart_outlined,
                  text: 'Export Excel',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export Excel (dummy)')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ===== LIST =====
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final e = _items[i];
              final isOut = e.type == _OpType.pengeluaran;
              return Container(
                padding: const EdgeInsets.all(14),
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7F8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        isOut
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        color: isOut
                            ? const Color(0xFFD32F2F)
                            : const Color(0xFF2E7D32),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF1E232C),
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            e.note,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF6A707C),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _fmtDate(e.date),
                            style: const TextStyle(
                              color: Color(0xFF9AA4B2),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '- ${_rupiah(e.amount)}',
                      style: const TextStyle(
                        color: Color(0xFFD32F2F),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================== EDIT MODE ==================
  Widget _buildEditMode() {
    return Column(
      key: const ValueKey('edit_mode'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
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
            child: const Text(
              'Mode Edit aktif. Tap item untuk opsi edit/hapus.',
              style: TextStyle(
                color: Color(0xFF6A707C),
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final e = _items[i];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _openEditSheet(e),
                child: Container(
                  padding: const EdgeInsets.all(14),
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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F7F8),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.edit_outlined,
                          color: kPurple,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF1E232C),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              e.note,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF6A707C),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _fmtDate(e.date),
                              style: const TextStyle(
                                color: Color(0xFF9AA4B2),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.more_vert_rounded,
                        color: Color(0xFF9AA4B2),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

//
// ================== COMPONENTS ==================
//
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
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodPill extends StatelessWidget {
  final bool active;
  final String label;
  final VoidCallback onTap;

  const _PeriodPill({
    required this.active,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? kPurple : const Color(0xFFF6F7F8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? kPurple : const Color(0xFFE8ECF4)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF1E232C),
            fontSize: 11,
            fontWeight: active ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: active ? kPurple : const Color(0xFFF6F7F8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? kPurple : const Color(0xFFE8ECF4)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF1E232C),
            fontSize: 11.5,
            fontWeight: active ? FontWeight.w900 : FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SheetAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF4)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9AA4B2),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6A707C),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9AA4B2),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: const Color(0xFFF6F7F8),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kPurple),
            ),
          ),
        ),
      ],
    );
  }
}

//
// ================== MODELS ==================
//
enum _OpType { pemasukan, pengeluaran }

enum _Period { harian, mingguan, bulanan, custom }

enum _OpTab { input, edit, listrik }

class _OpTxn {
  final DateTime date;
  final String title;
  final String note;
  final int amount;
  final _OpType type;

  _OpTxn({
    required this.date,
    required this.title,
    required this.note,
    required this.amount,
    required this.type,
  });
}
