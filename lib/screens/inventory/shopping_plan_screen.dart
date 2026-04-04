// rencana_belanja.dart (FASHION)
import 'package:flutter/material.dart';

const Color kPurple = Color(0xFF6B257F);

class ShoppingPlanScreen extends StatefulWidget {
  const ShoppingPlanScreen({super.key});

  @override
  State<ShoppingPlanScreen> createState() => _ShoppingPlanScreenState();
}

class _ShoppingPlanScreenState extends State<ShoppingPlanScreen> {
  _PlanTab _tab = _PlanTab.marketplace;

  // =========================
  // DUMMY DATA (FASHION)
  // =========================
  final List<_PlanItem> _marketPlans = [
    _PlanItem(
      title: 'Kain Katun Combed 30s (roll)',
      note: 'Cari toko dengan ongkir termurah',
      qty: 2,
      estPrice: 650000,
      due: DateTime.now().add(const Duration(days: 3)),
      status: _PlanStatus.draft,
    ),
    _PlanItem(
      title: 'Resleting YKK 20cm (pack)',
      note: 'Bandingkan harga 2 marketplace',
      qty: 5,
      estPrice: 45000,
      due: DateTime.now().add(const Duration(days: 7)),
      status: _PlanStatus.onTrack,
    ),
    _PlanItem(
      title: 'Poly Mailer / Plastik Packing',
      note: 'Ukuran M, untuk pengiriman',
      qty: 3,
      estPrice: 38000,
      due: DateTime.now().add(const Duration(days: 5)),
      status: _PlanStatus.onTrack,
    ),
  ];

  final List<_PlanItem> _otherPlans = [
    _PlanItem(
      title: 'Benang Jahit (hitam/putih)',
      note: 'Stok produksi mingguan',
      qty: 6,
      estPrice: 15000,
      due: DateTime.now().add(const Duration(days: 5)),
      status: _PlanStatus.draft,
    ),
    _PlanItem(
      title: 'Label Brand + Hangtag (500 pcs)',
      note: 'Cetak untuk koleksi baru',
      qty: 1,
      estPrice: 250000,
      due: DateTime.now().add(const Duration(days: 10)),
      status: _PlanStatus.onTrack,
    ),
    _PlanItem(
      title: 'Biaya Foto Produk',
      note: 'Untuk katalog marketplace',
      qty: 1,
      estPrice: 300000,
      due: DateTime.now().add(const Duration(days: 12)),
      status: _PlanStatus.draft,
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

  List<_PlanItem> get _activeList =>
      _tab == _PlanTab.marketplace ? _marketPlans : _otherPlans;

  int get _totalEstimate =>
      _activeList.fold(0, (a, b) => a + (b.estPrice * b.qty));

  int get _countItems => _activeList.length;

  void _openAddSheet() {
    final titleC = TextEditingController();
    final noteC = TextEditingController();
    final qtyC = TextEditingController(text: '1');
    final priceC = TextEditingController();

    DateTime due = DateTime.now().add(const Duration(days: 7));

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
                  Text(
                    _tab == _PlanTab.marketplace
                        ? 'Tambah Rencana (Marketplace)'
                        : 'Tambah Rencana (Lainnya)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InputField(
                    controller: titleC,
                    label: 'Nama barang / kebutuhan',
                    hint: 'Contoh: Kain katun combed, resleting, hanger',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: noteC,
                    label: 'Catatan',
                    hint: 'Contoh: bandingkan harga, pilih toko rating tinggi',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _InputField(
                          controller: qtyC,
                          label: 'Qty',
                          hint: '1',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InputField(
                          controller: priceC,
                          label: 'Estimasi harga (satuan)',
                          hint: 'Contoh: 250000',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Target tanggal beli',
                    style: TextStyle(
                      color: Color(0xFF6A707C),
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 2),
                        initialDate: due,
                      );
                      if (picked != null) setLocal(() => due = picked);
                    },
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7F8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8ECF4)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.event_outlined,
                            size: 18,
                            color: kPurple,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _fmtDate(due),
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 12.5,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                                  content: Text('Nama rencana wajib diisi'),
                                ),
                              );
                              return;
                            }
                            final qty = int.tryParse(qtyC.text.trim()) ?? 1;
                            final price = int.tryParse(priceC.text.trim()) ?? 0;

                            final item = _PlanItem(
                              title: title,
                              note: noteC.text.trim().isEmpty
                                  ? '-'
                                  : noteC.text.trim(),
                              qty: qty <= 0 ? 1 : qty,
                              estPrice: price < 0 ? 0 : price,
                              due: due,
                              status: _PlanStatus.draft,
                            );

                            setState(() {
                              if (_tab == _PlanTab.marketplace) {
                                _marketPlans.insert(0, item);
                              } else {
                                _otherPlans.insert(0, item);
                              }
                            });

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Rencana ditambahkan (dummy)'),
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

  void _openItemAction(_PlanItem item) {
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
                item.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              _SheetAction(
                icon: Icons.check_circle_outline_rounded,
                label: 'Tandai selesai (dummy)',
                color: const Color(0xFF2E7D32),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ditandai selesai (dummy)')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _SheetAction(
                icon: Icons.edit_outlined,
                label: 'Ubah rencana (dummy)',
                color: kPurple,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Ubah (dummy)')));
                },
              ),
              const SizedBox(height: 10),
              _SheetAction(
                icon: Icons.delete_outline_rounded,
                label: 'Hapus rencana (dummy)',
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
              label: 'Dari marketplace',
              active: _tab == _PlanTab.marketplace,
              onTap: () => setState(() => _tab = _PlanTab.marketplace),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TabPill(
              label: 'Rencana lainnya',
              active: _tab == _PlanTab.lainnya,
              onTap: () => setState(() => _tab = _PlanTab.lainnya),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
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
              _tab == _PlanTab.marketplace
                  ? 'Ringkasan rencana (Marketplace)'
                  : 'Ringkasan rencana (Lainnya)',
              style: const TextStyle(
                color: Color(0xFF6A707C),
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _rupiah(_totalEstimate),
              style: const TextStyle(
                color: kPurple,
                fontSize: 22,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _MiniStat(label: 'Item', value: '$_countItems'),
                const SizedBox(width: 10),
                _MiniStat(
                  label: 'Kategori',
                  value: _tab == _PlanTab.marketplace
                      ? 'Marketplace'
                      : 'Lainnya',
                ),
              ],
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
          'Belum ada rencana.',
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
        final item = data[i];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openItemAction(item),
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
                    _tab == _PlanTab.marketplace
                        ? Icons.storefront_outlined
                        : Icons.inventory_2_outlined,
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
                        item.title,
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
                        item.note,
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
                        'Target: ${_fmtDate(item.due)} • Qty ${item.qty}',
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
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusBadge(status: item.status),
                    const SizedBox(height: 8),
                    Text(
                      _rupiah(item.estPrice * item.qty),
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 12.5,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
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

      // ✅ plus icon bawah (untuk tambah rencana)
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
                    'Rencana Belanja',
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

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
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
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 13,
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

class _StatusBadge extends StatelessWidget {
  final _PlanStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late final String text;
    late final Color color;

    switch (status) {
      case _PlanStatus.draft:
        text = 'Draft';
        color = const Color(0xFF6A707C);
        break;
      case _PlanStatus.onTrack:
        text = 'On Track';
        color = const Color(0xFF2E7D32);
        break;
      case _PlanStatus.overdue:
        text = 'Overdue';
        color = const Color(0xFFD32F2F);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w900,
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
enum _PlanTab { marketplace, lainnya }

enum _PlanStatus { draft, onTrack, overdue }

class _PlanItem {
  final String title;
  final String note;
  final int qty;
  final int estPrice;
  final DateTime due;
  final _PlanStatus status;

  _PlanItem({
    required this.title,
    required this.note,
    required this.qty,
    required this.estPrice,
    required this.due,
    required this.status,
  });
}
