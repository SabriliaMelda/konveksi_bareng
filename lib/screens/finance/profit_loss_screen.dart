// rugi_laba.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

const Color kPurple = Color(0xFF6B257F);

class ProfitLossScreen extends StatefulWidget {
  const ProfitLossScreen({super.key});

  @override
  State<ProfitLossScreen> createState() => _ProfitLossScreenState();
}

class _ProfitLossScreenState extends State<ProfitLossScreen> {
  _RlTab _tab = _RlTab.proyek1;

  // =========================
  // DUMMY DATA (FASHION)
  // =========================
  final List<_RlTxn> _p1 = [
    _RlTxn(
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Penjualan Dress Midi (Marketplace)',
      note: 'Order #FM-10021',
      amount: 1250000,
      type: _RlType.pemasukan,
    ),
    _RlTxn(
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Bahan Kain Satin',
      note: 'Pembelian 3 roll',
      amount: 780000,
      type: _RlType.pengeluaran,
    ),
    _RlTxn(
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: 'Upah Jahit',
      note: '10 pcs',
      amount: 250000,
      type: _RlType.pengeluaran,
    ),
  ];

  final List<_RlTxn> _p2 = [
    _RlTxn(
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: 'Penjualan Kaos Oversize (TikTok Shop)',
      note: 'Batch A',
      amount: 980000,
      type: _RlType.pemasukan,
    ),
    _RlTxn(
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: 'Sablon DTF',
      note: '20 pcs',
      amount: 420000,
      type: _RlType.pengeluaran,
    ),
    _RlTxn(
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Packaging (poly mailer + sticker)',
      note: 'Untuk pengiriman',
      amount: 120000,
      type: _RlType.pengeluaran,
    ),
  ];

  final List<_RlTxn> _p3 = [
    _RlTxn(
      date: DateTime.now().subtract(const Duration(days: 6)),
      title: 'Penjualan Outer (Instagram)',
      note: 'Transfer manual',
      amount: 600000,
      type: _RlType.pemasukan,
    ),
    _RlTxn(
      date: DateTime.now().subtract(const Duration(days: 6)),
      title: 'Biaya Foto Produk',
      note: 'Studio mini',
      amount: 200000,
      type: _RlType.pengeluaran,
    ),
  ];

  // =========================
  // HELPERS
  // =========================
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

  List<_RlTxn> get _activeList {
    switch (_tab) {
      case _RlTab.proyek1:
        return _p1;
      case _RlTab.proyek2:
        return _p2;
      case _RlTab.proyek3:
        return _p3;
      case _RlTab.total:
        return [..._p1, ..._p2, ..._p3];
    }
  }

  int get _totalIncome => _activeList
      .where((e) => e.type == _RlType.pemasukan)
      .fold(0, (a, b) => a + b.amount);

  int get _totalExpense => _activeList
      .where((e) => e.type == _RlType.pengeluaran)
      .fold(0, (a, b) => a + b.amount);

  int get _profit => _totalIncome - _totalExpense;

  String get _scopeLabel {
    switch (_tab) {
      case _RlTab.proyek1:
        return 'Proyek 1';
      case _RlTab.proyek2:
        return 'Proyek 2';
      case _RlTab.proyek3:
        return 'Proyek 3';
      case _RlTab.total:
        return 'Total (Semua Proyek)';
    }
  }

  void _openAddSheet() {
    final titleC = TextEditingController();
    final noteC = TextEditingController();
    final amountC = TextEditingController();
    _RlType type = _RlType.pemasukan;

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
          child: StatefulBuilder(
            builder: (ctx, setLocal) {
              return Column(
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
                    'Tambah Transaksi (dummy)',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InputField(
                    controller: titleC,
                    label: 'Judul transaksi',
                    hint: 'Contoh: Penjualan Outer / Beli kain / Upah jahit',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: noteC,
                    label: 'Catatan',
                    hint: 'Contoh: order #, vendor, batch',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: amountC,
                    label: 'Nominal',
                    hint: 'Contoh: 250000',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Jenis',
                    style: TextStyle(
                      color: Color(0xFF6A707C),
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoicePill(
                          label: 'Pemasukan',
                          active: type == _RlType.pemasukan,
                          onTap: () => setLocal(() => type = _RlType.pemasukan),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ChoicePill(
                          label: 'Pengeluaran',
                          active: type == _RlType.pengeluaran,
                          onTap: () =>
                              setLocal(() => type = _RlType.pengeluaran),
                        ),
                      ),
                    ],
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
                            if (title.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Judul wajib diisi'),
                                ),
                              );
                              return;
                            }
                            final amount =
                                int.tryParse(amountC.text.trim()) ?? 0;

                            final newItem = _RlTxn(
                              date: DateTime.now(),
                              title: title,
                              note: noteC.text.trim().isEmpty
                                  ? '-'
                                  : noteC.text.trim(),
                              amount: amount < 0 ? 0 : amount,
                              type: type,
                            );

                            setState(() {
                              // masukkan ke list sesuai tab yang sedang dibuka
                              if (_tab == _RlTab.proyek1)
                                _p1.insert(0, newItem);
                              if (_tab == _RlTab.proyek2)
                                _p2.insert(0, newItem);
                              if (_tab == _RlTab.proyek3)
                                _p3.insert(0, newItem);
                              if (_tab == _RlTab.total)
                                _p1.insert(0, newItem); // default
                            });

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Transaksi ditambahkan (dummy)'),
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
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _openItemSheet(_RlTxn e) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        final isIn = e.type == _RlType.pemasukan;
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
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${_fmtDate(e.date)} • ${isIn ? "Pemasukan" : "Pengeluaran"}',
                style: const TextStyle(
                  color: Color(0xFF6A707C),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _TabPill(
              label: 'info r/l proyek 1',
              active: _tab == _RlTab.proyek1,
              onTap: () => setState(() => _tab = _RlTab.proyek1),
            ),
            const SizedBox(width: 10),
            _TabPill(
              label: 'info r/l proyek 2',
              active: _tab == _RlTab.proyek2,
              onTap: () => setState(() => _tab = _RlTab.proyek2),
            ),
            const SizedBox(width: 10),
            _TabPill(
              label: 'info r/l proyek 3 dst',
              active: _tab == _RlTab.proyek3,
              onTap: () => setState(() => _tab = _RlTab.proyek3),
            ),
            const SizedBox(width: 10),
            _TabPill(
              label: 'total status rugi laba',
              active: _tab == _RlTab.total,
              onTap: () => setState(() => _tab = _RlTab.total),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final profit = _profit;
    final isProfit = profit >= 0;

    return Padding(
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
            Text(
              'Ringkasan • $_scopeLabel',
              style: const TextStyle(
                color: Color(0xFF6A707C),
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'Pemasukan',
                    value: _rupiah(_totalIncome),
                    valueColor: const Color(0xFF2E7D32),
                    icon: Icons.arrow_downward_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniStat(
                    label: 'Pengeluaran',
                    value: _rupiah(_totalExpense),
                    valueColor: const Color(0xFFD32F2F),
                    icon: Icons.arrow_upward_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8ECF4)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8ECF4)),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isProfit
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: isProfit
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFD32F2F),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isProfit ? 'Laba Bersih' : 'Rugi Bersih',
                      style: const TextStyle(
                        color: Color(0xFF6A707C),
                        fontSize: 12,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    _rupiah(profit.abs()),
                    style: TextStyle(
                      color: isProfit
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFD32F2F),
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w900,
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

  Widget _buildList() {
    final data = _activeList;
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada data transaksi.',
          style: TextStyle(
            color: Color(0xFF6A707C),
            fontSize: 12.5,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final e = data[i];
        final isIn = e.type == _RlType.pemasukan;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openItemSheet(e),
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
                  child: Icon(
                    isIn
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: isIn
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFD32F2F),
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
                          fontFamily: 'Plus Jakarta Sans',
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
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _fmtDate(e.date),
                        style: const TextStyle(
                          color: Color(0xFF9AA4B2),
                          fontSize: 11.5,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  (isIn ? '+ ' : '- ') + _rupiah(e.amount),
                  style: TextStyle(
                    color: isIn
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFD32F2F),
                    fontSize: 12.5,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ plus icon bawah (tambah transaksi)
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        foregroundColor: Colors.white,
        elevation: 3,
        onPressed: _openAddSheet,
        child: const Icon(Icons.add_rounded, size: 26),
      ),

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
                    'Rugi Laba',
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

            // ===== SUMMARY =====
            _buildSummary(),

            const SizedBox(height: 10),

            // ===== LIST =====
            Expanded(child: _buildList()),
          ],
        ),
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF1E232C),
            fontSize: 11.5,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: active ? FontWeight.w900 : FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8ECF4)),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: valueColor),
          ),
          const SizedBox(width: 10),
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 12.5,
                    fontFamily: 'Plus Jakarta Sans',
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
                  fontFamily: 'Plus Jakarta Sans',
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

class _ChoicePill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ChoicePill({
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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? kPurple : const Color(0xFFF6F7F8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? kPurple : const Color(0xFFE8ECF4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF1E232C),
            fontSize: 11.5,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: active ? FontWeight.w900 : FontWeight.w800,
          ),
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
            fontFamily: 'Plus Jakarta Sans',
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
              fontFamily: 'Plus Jakarta Sans',
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
enum _RlTab { proyek1, proyek2, proyek3, total }

enum _RlType { pemasukan, pengeluaran }

class _RlTxn {
  final DateTime date;
  final String title;
  final String note;
  final int amount;
  final _RlType type;

  _RlTxn({
    required this.date,
    required this.title,
    required this.note,
    required this.amount,
    required this.type,
  });
}
