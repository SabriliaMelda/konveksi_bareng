// upah.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/features/home/pages/home.dart';

const Color kPurple = Color(0xFF6B257F);

class UpahScreen extends StatefulWidget {
  const UpahScreen({super.key});

  @override
  State<UpahScreen> createState() => _UpahScreenState();
}

class _UpahScreenState extends State<UpahScreen> {
  _UpahTab _tab = _UpahTab.status;
  int _projectIndex = 0; // untuk tab per project

  // ✅ FILTER TAGIHAN (ICON ONLY)
  int _filterIndex = 0; // 0: Semua, 1: Belum, 2: Jatuh Tempo, 3: Lunas

  // =========================
  // DUMMY DATA (FASHION)
  // =========================
  final List<_UpahBill> _bills = [
    _UpahBill(
      date: DateTime.now().subtract(const Duration(days: 2)),
      workerName: 'Mbak Sari',
      role: 'Penjahit',
      project: 'Proyek 1',
      note: 'Jahit 20 pcs blouse',
      amount: 400000,
      due: DateTime.now().add(const Duration(days: 3)),
      status: _BillStatus.belumDibayar,
    ),
    _UpahBill(
      date: DateTime.now().subtract(const Duration(days: 4)),
      workerName: 'Pak Deni',
      role: 'QC',
      project: 'Proyek 2',
      note: 'QC 50 pcs',
      amount: 250000,
      due: DateTime.now().add(const Duration(days: 1)),
      status: _BillStatus.jatuhTempo,
    ),
    _UpahBill(
      date: DateTime.now().subtract(const Duration(days: 6)),
      workerName: 'Mbak Rina',
      role: 'Potong',
      project: 'Proyek 1',
      note: 'Cutting kain 10 roll',
      amount: 300000,
      due: DateTime.now().subtract(const Duration(days: 1)),
      status: _BillStatus.lunas,
    ),
    _UpahBill(
      date: DateTime.now().subtract(const Duration(days: 1)),
      workerName: 'Pak Ujang',
      role: 'Sablon/DTF',
      project: 'Proyek 3',
      note: 'DTF 30 pcs',
      amount: 450000,
      due: DateTime.now().add(const Duration(days: 5)),
      status: _BillStatus.belumDibayar,
    ),
  ];

  final List<String> _projects = const ['Proyek 1', 'Proyek 2', 'Proyek 3'];

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

  // ✅ BASE LIST: scope by tab/project
  List<_UpahBill> get _baseList {
    if (_tab == _UpahTab.perProject) {
      final p = _projects[_projectIndex];
      return _bills.where((e) => e.project == p).toList();
    }
    return _bills;
  }

  // ✅ ACTIVE LIST: base + filter status
  List<_UpahBill> get _activeList {
    final base = _baseList;

    if (_filterIndex == 0) return base; // Semua
    if (_filterIndex == 1) {
      return base.where((e) => e.status == _BillStatus.belumDibayar).toList();
    }
    if (_filterIndex == 2) {
      return base.where((e) => e.status == _BillStatus.jatuhTempo).toList();
    }
    return base.where((e) => e.status == _BillStatus.lunas).toList();
  }

  int get _totalUnpaid => _activeList
      .where((e) => e.status != _BillStatus.lunas)
      .fold(0, (a, b) => a + b.amount);

  int get _totalPaid => _activeList
      .where((e) => e.status == _BillStatus.lunas)
      .fold(0, (a, b) => a + b.amount);

  int get _countUnpaid =>
      _activeList.where((e) => e.status != _BillStatus.lunas).length;
  int get _countPaid =>
      _activeList.where((e) => e.status == _BillStatus.lunas).length;
  int get _countOverdue =>
      _activeList.where((e) => e.status == _BillStatus.jatuhTempo).length;

  String get _scopeLabel {
    if (_tab == _UpahTab.perProject) return _projects[_projectIndex];
    return 'Semua';
  }

  // =========================
  // ACTIONS
  // =========================
  void _openAddSheet() {
    final nameC = TextEditingController();
    final roleC = TextEditingController();
    final noteC = TextEditingController();
    final amountC = TextEditingController();
    int projectPick = _projectIndex;

    DateTime due = DateTime.now().add(const Duration(days: 7));
    _BillStatus status = _BillStatus.belumDibayar;

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
                    'Tambah Tagihan Upah (dummy)',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InputField(
                    controller: nameC,
                    label: 'Nama pekerja',
                    hint: 'Contoh: Mbak Sari',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: roleC,
                    label: 'Bagian / peran',
                    hint: 'Contoh: Penjahit / QC / Potong',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: noteC,
                    label: 'Catatan pekerjaan',
                    hint: 'Contoh: Jahit 20 pcs blouse',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: amountC,
                    label: 'Nominal upah',
                    hint: 'Contoh: 250000',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Project',
                    style: TextStyle(
                      color: Color(0xFF6A707C),
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(_projects.length, (i) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: i == _projects.length - 1 ? 0 : 10,
                          ),
                          child: _ChoicePill(
                            label: 'P${i + 1}',
                            active: projectPick == i,
                            onTap: () => setLocal(() => projectPick = i),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Jatuh tempo',
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
                  const SizedBox(height: 10),
                  const Text(
                    'Status',
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
                          label: 'Belum',
                          active: status == _BillStatus.belumDibayar,
                          onTap: () =>
                              setLocal(() => status = _BillStatus.belumDibayar),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ChoicePill(
                          label: 'J. Tempo',
                          active: status == _BillStatus.jatuhTempo,
                          onTap: () =>
                              setLocal(() => status = _BillStatus.jatuhTempo),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ChoicePill(
                          label: 'Lunas',
                          active: status == _BillStatus.lunas,
                          onTap: () =>
                              setLocal(() => status = _BillStatus.lunas),
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
                            final name = nameC.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Nama pekerja wajib diisi'),
                                ),
                              );
                              return;
                            }
                            final amount =
                                int.tryParse(amountC.text.trim()) ?? 0;

                            final newBill = _UpahBill(
                              date: DateTime.now(),
                              workerName: name,
                              role: roleC.text.trim().isEmpty
                                  ? '-'
                                  : roleC.text.trim(),
                              project: _projects[projectPick],
                              note: noteC.text.trim().isEmpty
                                  ? '-'
                                  : noteC.text.trim(),
                              amount: amount < 0 ? 0 : amount,
                              due: due,
                              status: status,
                            );

                            setState(() => _bills.insert(0, newBill));
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Tagihan upah ditambahkan (dummy)',
                                ),
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

  void _openEditSheet(_UpahBill e) {
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
                e.workerName,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${e.project} • ${_rupiah(e.amount)}',
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
                label: 'Edit tagihan (dummy)',
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
                label: 'Hapus tagihan (dummy)',
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

  // =========================
  // UI BUILDERS
  // =========================
  Widget _buildSubMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _TabPill(
              icon: Icons.star_rounded,
              label: 'Status tagihan upah',
              active: _tab == _UpahTab.status,
              onTap: () => setState(() => _tab = _UpahTab.status),
            ),
            const SizedBox(width: 10),
            _TabPill(
              icon: Icons.edit_outlined,
              label: '..edit',
              active: _tab == _UpahTab.edit,
              onTap: () => setState(() => _tab = _UpahTab.edit),
            ),
            const SizedBox(width: 10),
            _TabPill(
              icon: Icons.folder_outlined,
              label: 'Status tagihan upah per project',
              active: _tab == _UpahTab.perProject,
              onTap: () => setState(() => _tab = _UpahTab.perProject),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectSubMenu() {
    if (_tab != _UpahTab.perProject) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _ChoicePill(
              label: 'Project 1',
              active: _projectIndex == 0,
              onTap: () => setState(() => _projectIndex = 0),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ChoicePill(
              label: 'Project 2',
              active: _projectIndex == 1,
              onTap: () => setState(() => _projectIndex = 1),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ChoicePill(
              label: 'dst',
              active: _projectIndex == 2,
              onTap: () => setState(() => _projectIndex = 2),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ FILTER TAGIHAN (ICON ONLY) - TANPA TULISAN
  Widget _buildBillFilter() {
    final items = <_FilterItem>[
      const _FilterItem(icon: Icons.list_alt_rounded, tooltip: 'Semua'),
      const _FilterItem(icon: Icons.schedule_rounded, tooltip: 'Belum'),
      const _FilterItem(
        icon: Icons.warning_amber_rounded,
        tooltip: 'Jatuh Tempo',
      ),
      const _FilterItem(icon: Icons.check_circle_rounded, tooltip: 'Lunas'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: List.generate(items.length, (i) {
          final active = _filterIndex == i;
          final it = items[i];

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == items.length - 1 ? 0 : 10),
              child: Tooltip(
                message: it.tooltip,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => setState(() => _filterIndex = i),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: active ? kPurple : const Color(0xFFF6F7F8),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: active ? kPurple : const Color(0xFFE8ECF4),
                      ),
                    ),
                    child: Icon(
                      it.icon,
                      size: 20,
                      color: active ? Colors.white : const Color(0xFF6A707C),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummary() {
    final unpaid = _totalUnpaid;
    final paid = _totalPaid;

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
                    label: 'Belum dibayar',
                    value: _rupiah(unpaid),
                    valueColor: const Color(0xFFD32F2F),
                    icon: Icons.schedule_rounded,
                    sub: '$_countUnpaid item',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniStat(
                    label: 'Lunas',
                    value: _rupiah(paid),
                    valueColor: const Color(0xFF2E7D32),
                    icon: Icons.check_circle_rounded,
                    sub: '$_countPaid item',
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
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 18,
                    color: kPurple,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Jatuh tempo: $_countOverdue tagihan',
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
          'Tidak ada tagihan sesuai filter.',
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
        final badge = _statusToBadge(e.status);

        final card = Container(
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
                child: const Icon(Icons.work_outline, color: kPurple, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.workerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF1E232C),
                              fontSize: 13,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _Badge(text: badge.text, color: badge.color),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${e.role} • ${e.project}',
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
                      '${e.note} • Due ${_fmtDate(e.due)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
              Text(
                _rupiah(e.amount),
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

        if (_tab == _UpahTab.edit) {
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _openEditSheet(e),
            child: card,
          );
        }

        return card;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    'Upah',
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

            // ===== SUB SUB MENU (PER PROJECT) =====
            _buildProjectSubMenu(),

            // ✅ FILTER ICON ONLY
            _buildBillFilter(),

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
class _TabPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;

  const _TabPill({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: active ? Colors.white : const Color(0xFF1E232C),
              ),
              const SizedBox(width: 6),
            ],
            Text(
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

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;
  final String sub;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
    required this.sub,
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
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: const TextStyle(
                    color: Color(0xFF9AA4B2),
                    fontSize: 11,
                    fontFamily: 'Plus Jakarta Sans',
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

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
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
// ================== SMALL MODELS
class _FilterItem {
  final IconData icon;
  final String tooltip;
  const _FilterItem({required this.icon, required this.tooltip});
}

//
// ================== MODELS
enum _UpahTab { status, edit, perProject }

enum _BillStatus { belumDibayar, jatuhTempo, lunas }

class _UpahBill {
  final DateTime date;
  final String workerName;
  final String role;
  final String project;
  final String note;
  final int amount;
  final DateTime due;
  final _BillStatus status;

  _UpahBill({
    required this.date,
    required this.workerName,
    required this.role,
    required this.project,
    required this.note,
    required this.amount,
    required this.due,
    required this.status,
  });
}

class _StatusMeta {
  final String text;
  final Color color;
  const _StatusMeta(this.text, this.color);
}

_StatusMeta _statusToBadge(_BillStatus s) {
  switch (s) {
    case _BillStatus.belumDibayar:
      return const _StatusMeta('Belum', Color(0xFFD32F2F));
    case _BillStatus.jatuhTempo:
      return const _StatusMeta('J. Tempo', Color(0xFFE65100));
    case _BillStatus.lunas:
      return const _StatusMeta('Lunas', Color(0xFF2E7D32));
  }
}
