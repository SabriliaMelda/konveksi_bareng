// pengeluaran.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:konveksi_bareng/screens/main/home.dart';
import 'package:konveksi_bareng/widgets/app_bottom_nav.dart';

const Color kPurple = Color(0xFF6B257F);

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  _OutTab _tab = _OutTab.input;

  // filter periode (dummy)
  _Period _period = _Period.bulanan;
  DateTimeRange? _customRange;

  // dummy data
  final List<_ExpenseTxn> _inputItems = [
    _ExpenseTxn(
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: 'BBM & Transport',
      note: 'Pengiriman bahan baku',
      amount: 175000,
      category: _ExpenseCategory.operasional,
    ),
    _ExpenseTxn(
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Listrik & Internet',
      note: 'Tagihan bulanan',
      amount: 320000,
      category: _ExpenseCategory.operasional,
    ),
    _ExpenseTxn(
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: 'ATK',
      note: 'Kertas, tinta, map',
      amount: 85000,
      category: _ExpenseCategory.operasional,
    ),
  ];

  final List<_ExpenseTxn> _bahanBakuItems = [
    _ExpenseTxn(
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: 'Kain Cotton Combed',
      note: '30 kg',
      amount: 2100000,
      category: _ExpenseCategory.bahanBaku,
    ),
    _ExpenseTxn(
      date: DateTime.now().subtract(const Duration(days: 4)),
      title: 'Benang Jahit',
      note: '20 gulung',
      amount: 350000,
      category: _ExpenseCategory.bahanBaku,
    ),
    _ExpenseTxn(
      date: DateTime.now().subtract(const Duration(days: 6)),
      title: 'Plastik Packing',
      note: '100 pcs',
      amount: 120000,
      category: _ExpenseCategory.bahanBaku,
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

  int get _totalExpense {
    final list = _tab == _OutTab.bahanBaku ? _bahanBakuItems : _inputItems;
    return list.fold(0, (a, b) => a + b.amount);
  }

  // ================== ADD (PLUS) SHEET ==================
  void _openAddSheet() {
    final titleC = TextEditingController();
    final noteC = TextEditingController();
    final amountC = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).appColors.card,
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
              Text(
                _tab == _OutTab.bahanBaku
                    ? 'Tambah Bahan Baku'
                    : 'Tambah Pengeluaran',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),

              _InputField(
                controller: titleC,
                label: 'Judul',
                hint: _tab == _OutTab.bahanBaku
                    ? 'Contoh: Kain / Benang / Aksesoris'
                    : 'Contoh: Transport / ATK / Listrik',
              ),
              const SizedBox(height: 10),
              _InputField(
                controller: noteC,
                label: 'Catatan',
                hint: 'Contoh: 30 kg / Pengiriman / Tagihan',
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

                        final txn = _ExpenseTxn(
                          date: DateTime.now(),
                          title: title,
                          note: note.isEmpty ? '-' : note,
                          amount: amt,
                          category: _tab == _OutTab.bahanBaku
                              ? _ExpenseCategory.bahanBaku
                              : _ExpenseCategory.operasional,
                        );

                        setState(() {
                          if (_tab == _OutTab.bahanBaku) {
                            _bahanBakuItems.insert(0, txn);
                          } else {
                            _inputItems.insert(0, txn);
                          }
                        });

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Data ditambahkan (dummy)'),
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
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            color: Theme.of(context).appColors.card,
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

  // ================== EDIT SHEET (for bahan baku & list items) ==================
  void _openEditSheet(_ExpenseTxn e) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).appColors.card,
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
                label: 'Edit (dummy)',
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
                label: 'Hapus (dummy)',
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

  Widget _buildSubMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _TabPill(
              label: 'Bahan baku',
              active: _tab == _OutTab.bahanBaku,
              onTap: () => setState(() => _tab = _OutTab.bahanBaku),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _TabPill(
              label: 'Input pengeluaran',
              active: _tab == _OutTab.input,
              onTap: () => setState(() => _tab = _OutTab.input),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColors.card,

      // ✅ PLUS kanan bawah (muncul untuk input & bahan baku)
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        foregroundColor: Theme.of(context).appColors.card,
        elevation: 3,
        onPressed: _openAddSheet,
        child: Icon(Icons.add_rounded, size: 26),
      ),
      bottomNavigationBar: AppBottomNav(activeIndex: -1),

      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Theme.of(context).appColors.border),
                        color: Theme.of(context).appColors.card,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Theme.of(context).appColors.ink,
                      ),
                    ),
                  ),
                  Text(
                    'Pengeluaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).appColors.ink,
                      height: 1.4,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Theme.of(context).appColors.border),
                        color: Theme.of(context).appColors.card,
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

            // ===== CONTENT =====
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 180),
                child: _tab == _OutTab.bahanBaku
                    ? _buildBahanBakuMode()
                    : _buildInputMode(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).appColors.border),
          boxShadow: [
            BoxShadow(
              color: Color(0x0CB3B3B3),
              blurRadius: 40,
              offset: Offset(0, 16),
            ),
          ],
          color: Theme.of(context).appColors.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).appColors.muted,
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
                              start: now.subtract(Duration(days: 7)),
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
              SizedBox(height: 10),
              Text(
                '${_fmtDate(_customRange!.start)} - ${_fmtDate(_customRange!.end)}',
                style: TextStyle(
                  color: Theme.of(context).appColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================== INPUT MODE ==================
  Widget _buildInputMode() {
    return Column(
      key: ValueKey('input_mode_expense'),
      children: [
        _buildSummaryCard('Total Pengeluaran'),
        SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
            itemCount: _inputItems.length,
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemBuilder: (context, i) {
              final e = _inputItems[i];
              return Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).appColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).appColors.border),
                  boxShadow: [
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
                        color: Theme.of(context).appColors.iconSurface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        color: Color(0xFFD32F2F),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).appColors.ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            e.note,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).appColors.muted,
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

  // ================== BAHAN BAKU MODE ==================
  Widget _buildBahanBakuMode() {
    return Column(
      key: ValueKey('bahan_baku_mode_expense'),
      children: [
        _buildSummaryCard('Total Bahan Baku'),
        SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
            itemCount: _bahanBakuItems.length,
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemBuilder: (context, i) {
              final e = _bahanBakuItems[i];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _openEditSheet(e),
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).appColors.border),
                    boxShadow: [
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
                          color: Theme.of(context).appColors.iconSurface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: kPurple,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).appColors.ink,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              e.note,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).appColors.muted,
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
          color: Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).appColors.border),
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).appColors.border),
          color: Theme.of(context).appColors.card,
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
          style: TextStyle(
            color: Theme.of(context).appColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Color(0xFF9AA4B2),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: Theme.of(context).appColors.iconSurface,
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
enum _Period { harian, mingguan, bulanan, custom }

enum _OutTab { bahanBaku, input }

enum _ExpenseCategory { bahanBaku, operasional }

class _ExpenseTxn {
  final DateTime date;
  final String title;
  final String note;
  final int amount;
  final _ExpenseCategory category;

  _ExpenseTxn({
    required this.date,
    required this.title,
    required this.note,
    required this.amount,
    required this.category,
  });
}
