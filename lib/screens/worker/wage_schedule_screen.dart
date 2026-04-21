// jadwal_upah.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';

const kPurple = Color(0xFF6B257F);

class WageScheduleScreen extends StatefulWidget {
  const WageScheduleScreen({super.key});

  @override
  State<WageScheduleScreen> createState() => _WageScheduleScreenState();
}

class _WageScheduleScreenState extends State<WageScheduleScreen> {
  int selectedDay = 5; // default

  // indikator dot per tanggal (dummy)
  final Map<int, List<Color>> dots = {
    2: [Color(0xFF00B383), Color(0xFF0095FF)],
    5: [Color(0xFF735BF2)],
    10: [Color(0xFF00B383), Color(0xFF0095FF), Color(0xFF735BF2)],
    12: [Color(0xFF0095FF)],
    18: [Color(0xFF735BF2)],
    22: [Color(0xFF00B383)],
    29: [Color(0xFF0095FF)],
  };

  // dummy jadwal upah per tanggal (fashion)
  final Map<int, List<_UpahSchedule>> schedulesByDay = {
    5: const [
      _UpahSchedule(
        time: '10:00 - 10:30',
        title: 'Bayar Upah Penjahit',
        desc: 'Pembayaran jahit 20 pcs blouse (Mbak Sari).',
        location: 'Workshop',
        worker: 'Mbak Sari',
        project: 'Proyek 1',
        amount: 400000,
        status: _UpahPayStatus.belum,
        borderColor: Color(0xFF26BFBF),
        barColor: Color(0xFF26BFBF),
      ),
      _UpahSchedule(
        time: '15:00 - 15:30',
        title: 'Bayar Upah QC',
        desc: 'QC 50 pcs + re-check ukuran (Pak Deni).',
        location: 'Workshop',
        worker: 'Pak Deni',
        project: 'Proyek 2',
        amount: 250000,
        status: _UpahPayStatus.jatuhTempo,
        borderColor: Color(0xFF89AFFF),
        barColor: Color(0xFF89AFFF),
      ),
    ],
    10: const [
      _UpahSchedule(
        time: '11:00 - 11:30',
        title: 'Bayar Upah Cutting',
        desc: 'Cutting kain 10 roll (Mbak Rina).',
        location: 'Workshop',
        worker: 'Mbak Rina',
        project: 'Proyek 1',
        amount: 300000,
        status: _UpahPayStatus.lunas,
        borderColor: Color(0xFF735BF2),
        barColor: Color(0xFF735BF2),
      ),
    ],
  };

  // =========================
  // Helpers
  // =========================
  String _fmtDateBar(int day) {
    // dummy: January 2024 (biar mirip desain contoh)
    return 'Thursday, ${day.toString().padLeft(2, '0')} Jan, 2024';
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

  List<_UpahSchedule> get _activeSchedules => schedulesByDay[selectedDay] ?? [];

  void _openAddSheet() {
    final titleC = TextEditingController(text: 'Bayar Upah');
    final workerC = TextEditingController();
    final projectC = TextEditingController(text: 'Proyek 1');
    final descC = TextEditingController();
    final locC = TextEditingController(text: 'Workshop');
    final timeC = TextEditingController(text: '10:00 - 10:30');
    final amountC = TextEditingController();

    _UpahPayStatus status = _UpahPayStatus.belum;

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
                    'Tambah Jadwal Upah (dummy)',
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
                    hint: 'Contoh: Bayar Upah Penjahit',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: workerC,
                    label: 'Nama pekerja',
                    hint: 'Contoh: Mbak Sari',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: projectC,
                    label: 'Project',
                    hint: 'Contoh: Proyek 1',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: descC,
                    label: 'Catatan',
                    hint: 'Contoh: Jahit 20 pcs blouse',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: amountC,
                    label: 'Nominal',
                    hint: 'Contoh: 250000',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  _InputField(
                    controller: locC,
                    label: 'Lokasi',
                    hint: 'Contoh: Workshop',
                  ),
                  SizedBox(height: 10),
                  _InputField(
                    controller: timeC,
                    label: 'Jam',
                    hint: 'Contoh: 10:00 - 10:30',
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Status',
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoicePill(
                          label: 'Belum',
                          active: status == _UpahPayStatus.belum,
                          onTap: () =>
                              setLocal(() => status = _UpahPayStatus.belum),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ChoicePill(
                          label: 'J. Tempo',
                          active: status == _UpahPayStatus.jatuhTempo,
                          onTap: () => setLocal(
                            () => status = _UpahPayStatus.jatuhTempo,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ChoicePill(
                          label: 'Lunas',
                          active: status == _UpahPayStatus.lunas,
                          onTap: () =>
                              setLocal(() => status = _UpahPayStatus.lunas),
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
                          onTap: () => context.pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            final title = titleC.text.trim();
                            final worker = workerC.text.trim();
                            final amount =
                                int.tryParse(amountC.text.trim()) ?? 0;

                            if (title.isEmpty || worker.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Judul & pekerja wajib diisi'),
                                ),
                              );
                              return;
                            }

                            final newItem = _UpahSchedule(
                              time: timeC.text.trim().isEmpty
                                  ? '-'
                                  : timeC.text.trim(),
                              title: title,
                              desc: descC.text.trim().isEmpty
                                  ? '-'
                                  : descC.text.trim(),
                              location: locC.text.trim().isEmpty
                                  ? '-'
                                  : locC.text.trim(),
                              worker: worker,
                              project: projectC.text.trim().isEmpty
                                  ? '-'
                                  : projectC.text.trim(),
                              amount: amount < 0 ? 0 : amount,
                              status: status,
                              borderColor: const Color(0xFF26BFBF),
                              barColor: const Color(0xFF26BFBF),
                            );

                            setState(() {
                              final list = List<_UpahSchedule>.from(
                                _activeSchedules,
                              );
                              list.insert(0, newItem);
                              schedulesByDay[selectedDay] = list;

                              dots[selectedDay] = (dots[selectedDay] ?? [])
                                ..add(const Color(0xFF735BF2));
                            });

                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Jadwal upah ditambahkan (dummy)',
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
              );
            },
          ),
        );
      },
    );
  }

  void _openItemAction(_UpahSchedule item) {
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
                  color: Color(0xFFE6E7EE),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(height: 12),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 6),
              Text(
                '${item.worker} • ${item.project} • ${_rupiah(item.amount)}',
                style: TextStyle(
                  color: Theme.of(context).appColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _SheetAction(
                icon: Icons.check_circle_outline_rounded,
                label: 'Tandai lunas (dummy)',
                color: const Color(0xFF2E7D32),
                onTap: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ditandai lunas (dummy)')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _SheetAction(
                icon: Icons.delete_outline_rounded,
                label: 'Hapus jadwal (dummy)',
                color: Color(0xFFD32F2F),
                onTap: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Hapus (dummy)')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColors.card,
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        foregroundColor: Theme.of(context).appColors.card,
        elevation: 3,
        onPressed: _openAddSheet,
        child: const Icon(Icons.add_rounded, size: 26),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _TopHeader(title: 'Jadwal Upah'),
            const SizedBox(height: 8),

            // month header (dummy)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleIcon(icon: Icons.chevron_left, onTap: () {}),
                  Column(
                    children: const [
                      Text(
                        'January',
                        style: TextStyle(
                          color: Color(0xFF222B45),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '2024',
                        style: TextStyle(
                          color: Color(0xFF8F9BB3),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  _CircleIcon(icon: Icons.chevron_right, onTap: () {}),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // weekday
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _WDay('Mon'),
                  _WDay('Tue'),
                  _WDay('Wed'),
                  _WDay('Thu'),
                  _WDay('Fri'),
                  _WDay('Sat'),
                  _WDay('Sun'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // calendar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _CalendarGrid(
                selectedDay: selectedDay,
                dots: dots,
                onTapDay: (d) => setState(() => selectedDay = d),
              ),
            ),

            const SizedBox(height: 12),

            // purple date bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: const BoxDecoration(
                color: kPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const _SmallDot(),
                  SizedBox(width: 10),
                  Text(
                    _fmtDateBar(selectedDay),
                    style: TextStyle(
                      color: Color(0xFFECECEC),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // list
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).appColors.card,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: _activeSchedules.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada jadwal upah pada tanggal ini.',
                          style: TextStyle(
                            color: Theme.of(context).appColors.muted,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : ListView.separated(
                        // ✅ aman dari FAB
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 90),
                        itemCount: _activeSchedules.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final item = _activeSchedules[i];
                          return GestureDetector(
                            onTap: () => _openItemAction(item),
                            child: _ScheduleCardUpah(
                              item: item,
                              rupiah: _rupiah,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ================== TOP HEADER ==================
//
class _TopHeader extends StatelessWidget {
  final String title;
  const _TopHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18).copyWith(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIcon(
            icon: Icons.arrow_back,
            onTap: () => context.pop(),
          ),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).appColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          _CircleIcon(
            icon: Icons.home_filled,
            iconColor: kPurple,
            onTap: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleIcon({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Theme.of(context).appColors.border),
          color: Theme.of(context).appColors.card,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: iconColor ?? Colors.black87),
      ),
    );
  }
}

class _WDay extends StatelessWidget {
  final String t;
  const _WDay(this.t);

  @override
  Widget build(BuildContext context) {
    return Text(
      t,
      style: const TextStyle(
        color: Color(0xFF8F9BB3),
        fontSize: 13,
      ),
    );
  }
}

//
// ================== CALENDAR GRID ==================
//
class _CalendarGrid extends StatelessWidget {
  final int selectedDay;
  final Map<int, List<Color>> dots;
  final ValueChanged<int> onTapDay;

  const _CalendarGrid({
    required this.selectedDay,
    required this.dots,
    required this.onTapDay,
  });

  @override
  Widget build(BuildContext context) {
    final days = <_CalCell>[
      const _CalCell(day: 31, muted: true),
      const _CalCell(day: 30, muted: true),
      const _CalCell(day: 1),
      const _CalCell(day: 2),
      const _CalCell(day: 3),
      const _CalCell(day: 4),
      const _CalCell(day: 5),
      const _CalCell(day: 6),
      const _CalCell(day: 7),
      const _CalCell(day: 8),
      const _CalCell(day: 9),
      const _CalCell(day: 10),
      const _CalCell(day: 11),
      const _CalCell(day: 12),
      const _CalCell(day: 13),
      const _CalCell(day: 14),
      const _CalCell(day: 15),
      const _CalCell(day: 16),
      const _CalCell(day: 17),
      const _CalCell(day: 18),
      const _CalCell(day: 19),
      const _CalCell(day: 20),
      const _CalCell(day: 21),
      const _CalCell(day: 22),
      const _CalCell(day: 23),
      const _CalCell(day: 24),
      const _CalCell(day: 25),
      const _CalCell(day: 26),
      const _CalCell(day: 27),
      const _CalCell(day: 28),
      const _CalCell(day: 29),
      const _CalCell(day: 30),
      const _CalCell(day: 31),
      const _CalCell(day: 1, muted: true),
      const _CalCell(day: 2, muted: true),
    ];

    return GridView.builder(
      itemCount: days.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 6,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final cell = days[index];
        final isSelected = !cell.muted && cell.day == selectedDay;

        return GestureDetector(
          onTap: cell.muted ? null : () => onTapDay(cell.day),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFDBC0F2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${cell.day}',
                  style: TextStyle(
                    color: cell.muted
                        ? const Color(0xFF8F9BB3)
                        : (isSelected ? Colors.white : const Color(0xFF222B45)),
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 6,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: (dots[cell.day] ?? const [])
                      .take(3)
                      .map(
                        (c) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CalCell {
  final int day;
  final bool muted;
  const _CalCell({required this.day, this.muted = false});
}

class _SmallDot extends StatelessWidget {
  const _SmallDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFFA98B98),
        shape: BoxShape.circle,
      ),
    );
  }
}

//
// ================== CARD UPAH ==================
//
enum _UpahPayStatus { belum, jatuhTempo, lunas }

class _UpahSchedule {
  final String time;
  final String title;
  final String desc;
  final String location;
  final String worker;
  final String project;
  final int amount;
  final _UpahPayStatus status;
  final Color borderColor;
  final Color barColor;

  const _UpahSchedule({
    required this.time,
    required this.title,
    required this.desc,
    required this.location,
    required this.worker,
    required this.project,
    required this.amount,
    required this.status,
    required this.borderColor,
    required this.barColor,
  });
}

class _ScheduleCardUpah extends StatelessWidget {
  final _UpahSchedule item;
  final String Function(int) rupiah;

  const _ScheduleCardUpah({required this.item, required this.rupiah});

  Color get _statusColor {
    switch (item.status) {
      case _UpahPayStatus.belum:
        return const Color(0xFFD32F2F);
      case _UpahPayStatus.jatuhTempo:
        return const Color(0xFFE65100);
      case _UpahPayStatus.lunas:
        return const Color(0xFF2E7D32);
    }
  }

  String get _statusText {
    switch (item.status) {
      case _UpahPayStatus.belum:
        return 'Belum';
      case _UpahPayStatus.jatuhTempo:
        return 'J. Tempo';
      case _UpahPayStatus.lunas:
        return 'Lunas';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ FIX: jangan kunci height, biar adaptif & tidak overflow
      constraints: BoxConstraints(minHeight: 128),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.borderColor, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C1C252C),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            decoration: BoxDecoration(
              color: item.barColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Color(0xE59A9A9A),
                      ),
                      SizedBox(width: 8),
                      Text(
                        item.time,
                        style: TextStyle(
                          color: Color(0xE59A9A9A),
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).appColors.iconSurface,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: Theme.of(context).appColors.border),
                        ),
                        child: Text(
                          _statusText,
                          style: TextStyle(
                            color: _statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Color(0xFF1B1B1B),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${item.worker} • ${item.project} • ${rupiah(item.amount)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Theme.of(context).appColors.muted,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).appColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.more_vert,
                        size: 18,
                        color: Color(0xFFD8DEF3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// ================== BottomSheet Components ==================
//
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
