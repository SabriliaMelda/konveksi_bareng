// unified_schedule_screen.dart
//
// Merged calendar for Jadwal Kirim / Buat / Beli / Upah.
// Month calendar with real dates + Gantt-style timetable for the selected day,
// each category rendered with its own color.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

const _kPurple = Color(0xFF6B257F);

// =========================================================
// MODEL
// =========================================================
enum ScheduleCategory { kirim, buat, beli, upah }

class _CategoryMeta {
  final String label;
  final Color color;
  final IconData icon;
  const _CategoryMeta(this.label, this.color, this.icon);
}

const Map<ScheduleCategory, _CategoryMeta> _catMeta = {
  ScheduleCategory.kirim:
      _CategoryMeta('Kirim', Color(0xFF26BFBF), Icons.send_rounded),
  ScheduleCategory.buat:
      _CategoryMeta('Buat', Color(0xFF89AFFF), Icons.calendar_month),
  ScheduleCategory.beli:
      _CategoryMeta('Beli', Color(0xFF735BF2), Icons.shopping_bag_outlined),
  ScheduleCategory.upah:
      _CategoryMeta('Upah', Color(0xFF00B383), Icons.payments_outlined),
};

class ScheduleItem {
  final ScheduleCategory category;
  final DateTime date; // y/m/d — time portion ignored
  final double start; // hour of day (0-24, e.g. 10.5 = 10:30)
  final double end;
  final String title;
  final String desc;
  final String location;
  final String? extra;

  ScheduleItem({
    required this.category,
    required DateTime date,
    required this.start,
    required this.end,
    required this.title,
    required this.desc,
    required this.location,
    this.extra,
  }) : date = DateTime(date.year, date.month, date.day);

  String get timeLabel {
    String fmt(double h) {
      final hh = h.floor();
      final mm = ((h - hh) * 60).round();
      return '${hh.toString().padLeft(2, '0')}:${mm.toString().padLeft(2, '0')}';
    }

    return '${fmt(start)} - ${fmt(end)}';
  }
}

DateTime _d(DateTime x) => DateTime(x.year, x.month, x.day);
bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
bool _sameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];
const _dayNamesLong = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
];

// =========================================================
// SCREEN
// =========================================================
class UnifiedScheduleScreen extends StatefulWidget {
  const UnifiedScheduleScreen({super.key});

  @override
  State<UnifiedScheduleScreen> createState() => _UnifiedScheduleScreenState();
}

class _UnifiedScheduleScreenState extends State<UnifiedScheduleScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth; // first day of currently-viewed month
  final Set<ScheduleCategory> _enabled = {
    ScheduleCategory.kirim,
    ScheduleCategory.buat,
    ScheduleCategory.beli,
    ScheduleCategory.upah,
  };
  late final List<ScheduleItem> _items;

  @override
  void initState() {
    super.initState();
    final today = _d(DateTime.now());
    _selectedDate = today;
    _focusedMonth = DateTime(today.year, today.month, 1);
    _items = _seedItems(today);
  }

  // Seed dummy data relative to today so the calendar is never empty.
  List<ScheduleItem> _seedItems(DateTime today) {
    DateTime offset(int d) => today.add(Duration(days: d));
    return [
      // today
      ScheduleItem(
        category: ScheduleCategory.kirim,
        date: today,
        start: 10,
        end: 10.5,
        title: 'Pickup Paket Proyek 1',
        desc: 'Kurir menjemput 2 box (Blouse) dari workshop.',
        location: 'Workshop Bandung → Gudang Jakarta',
        extra: 'JNE • JNE-23920193',
      ),
      ScheduleItem(
        category: ScheduleCategory.buat,
        date: today,
        start: 11.5,
        end: 12.5,
        title: 'Sales Presentation',
        desc: 'Presentasi untuk potential client.',
        location: 'Meeting Room',
      ),
      ScheduleItem(
        category: ScheduleCategory.beli,
        date: today,
        start: 13.5,
        end: 14.5,
        title: 'Beli aksesoris',
        desc: 'Kancing & resleting untuk 30 pcs outerwear.',
        location: 'Toko Aksesoris Sinar',
        extra: 'Aksesoris',
      ),
      ScheduleItem(
        category: ScheduleCategory.upah,
        date: today,
        start: 15,
        end: 15.5,
        title: 'Bayar Upah Penjahit',
        desc: 'Pembayaran jahit 20 pcs blouse.',
        location: 'Workshop',
        extra: 'Rp 400.000 • Mbak Sari',
      ),

      // +2 days
      ScheduleItem(
        category: ScheduleCategory.buat,
        date: offset(2),
        start: 9,
        end: 12,
        title: 'Produksi batch 1',
        desc: 'Cutting + jahit batch pertama kaos basic.',
        location: 'Workshop',
      ),
      ScheduleItem(
        category: ScheduleCategory.kirim,
        date: offset(2),
        start: 14,
        end: 14.5,
        title: 'Kirim Paket QC',
        desc: 'Dokumen QC + sample dikirim ke client.',
        location: 'Workshop → Client (Bekasi)',
        extra: 'SiCepat',
      ),

      // +5 days
      ScheduleItem(
        category: ScheduleCategory.beli,
        date: offset(5),
        start: 9,
        end: 10.5,
        title: 'Belanja packaging',
        desc: 'Poly mailer + sticker logo + thank you card.',
        location: 'Marketplace (Online)',
        extra: 'Packaging',
      ),
      ScheduleItem(
        category: ScheduleCategory.upah,
        date: offset(5),
        start: 11,
        end: 11.5,
        title: 'Bayar Upah Cutting',
        desc: 'Cutting kain 10 roll.',
        location: 'Workshop',
        extra: 'Rp 300.000 • Mbak Rina',
      ),

      // -3 days (past)
      ScheduleItem(
        category: ScheduleCategory.beli,
        date: offset(-3),
        start: 10,
        end: 12,
        title: 'Belanja kain (Cotton Combed)',
        desc: 'Cari bahan untuk produksi kaos basic.',
        location: 'Pasar Baru',
        extra: 'Bahan',
      ),

      // +10 days
      ScheduleItem(
        category: ScheduleCategory.buat,
        date: offset(10),
        start: 13,
        end: 16,
        title: 'Produksi batch 2',
        desc: 'Finishing & QC batch kedua.',
        location: 'Workshop',
      ),
    ];
  }

  // -------- derived --------
  List<ScheduleItem> get _visibleItems {
    final list = _items
        .where((e) =>
            _enabled.contains(e.category) && _sameDay(e.date, _selectedDate))
        .toList();
    list.sort((a, b) => a.start.compareTo(b.start));
    return list;
  }

  Map<DateTime, Set<ScheduleCategory>> get _dotsByDay {
    final m = <DateTime, Set<ScheduleCategory>>{};
    for (final it in _items) {
      if (!_enabled.contains(it.category)) continue;
      if (!_sameMonth(it.date, _focusedMonth)) continue;
      m.putIfAbsent(it.date, () => <ScheduleCategory>{}).add(it.category);
    }
    return m;
  }

  String _dateLabel(DateTime dt) {
    final w = _dayNamesLong[dt.weekday - 1];
    final mo = _monthNames[dt.month - 1].substring(0, 3);
    return '$w, ${dt.day.toString().padLeft(2, '0')} $mo ${dt.year}';
  }

  // -------- actions --------
  void _prevMonth() => setState(() {
        _focusedMonth =
            DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
      });

  void _nextMonth() => setState(() {
        _focusedMonth =
            DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
      });

  void _jumpToToday() {
    final today = _d(DateTime.now());
    setState(() {
      _selectedDate = today;
      _focusedMonth = DateTime(today.year, today.month, 1);
    });
  }

  void _onTapDay(DateTime d) {
    setState(() {
      _selectedDate = d;
      if (!_sameMonth(d, _focusedMonth)) {
        _focusedMonth = DateTime(d.year, d.month, 1);
      }
    });
  }

  void _openItemDetails(ScheduleItem it) {
    final meta = _catMeta[it.category]!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).appColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
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
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: meta.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(meta.icon, size: 14, color: meta.color),
                      const SizedBox(width: 6),
                      Text(
                        'Jadwal ${meta.label}',
                        style: TextStyle(
                          color: meta.color,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '${_dateLabel(it.date)} • ${it.timeLabel}',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              it.title,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              it.desc,
              style: TextStyle(
                color: Theme.of(context).appColors.muted,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.place_outlined,
                    size: 16, color: Color(0xFF9AA4B2)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    it.location,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (it.extra != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: Color(0xFF9AA4B2)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      it.extra!,
                      style: TextStyle(
                        color: Theme.of(context).appColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _items.remove(it));
                      context.pop();
                    },
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 16, color: Color(0xFFDC2626)),
                    label: const Text('Hapus',
                        style: TextStyle(color: Color(0xFFDC2626))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => context.pop(),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final first = DateTime(DateTime.now().year - 2, 1, 1);
    final last = DateTime(DateTime.now().year + 3, 12, 31);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) _onTapDay(_d(picked));
  }

  void _openAddSheet() {
    ScheduleCategory cat = ScheduleCategory.buat;
    DateTime date = _selectedDate;
    final titleC = TextEditingController();
    final descC = TextEditingController();
    final locC = TextEditingController();
    final startC = TextEditingController(text: '09:00');
    final endC = TextEditingController(text: '10:00');

    double? parseTime(String s) {
      final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(s.trim());
      if (m == null) return null;
      final h = int.parse(m.group(1)!);
      final mi = int.parse(m.group(2)!);
      if (h > 23 || mi > 59) return null;
      return h + mi / 60.0;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).appColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetCtx) {
        final bottomInset = MediaQuery.of(sheetCtx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottomInset),
          child: StatefulBuilder(
            builder: (ctx, setLocal) => SingleChildScrollView(
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
                    'Tambah Jadwal',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Kategori',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6B7280))),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ScheduleCategory.values.map((c) {
                      final m = _catMeta[c]!;
                      final active = cat == c;
                      return GestureDetector(
                        onTap: () => setLocal(() => cat = c),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: active
                                ? m.color
                                : m.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(m.icon,
                                  size: 14,
                                  color: active ? Colors.white : m.color),
                              const SizedBox(width: 6),
                              Text(
                                m.label,
                                style: TextStyle(
                                  color: active ? Colors.white : m.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Tanggal',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6B7280))),
                  const SizedBox(height: 6),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: date,
                        firstDate: DateTime(DateTime.now().year - 2),
                        lastDate: DateTime(DateTime.now().year + 3, 12, 31),
                      );
                      if (picked != null) setLocal(() => date = _d(picked));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE8ECF4)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Color(0xFF6B7280)),
                          const SizedBox(width: 8),
                          Text(_dateLabel(date),
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _LabeledField(
                      label: 'Judul',
                      controller: titleC,
                      hint: 'Judul jadwal'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: _LabeledField(
                              label: 'Mulai (HH:MM)',
                              controller: startC,
                              hint: '09:00')),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _LabeledField(
                              label: 'Selesai (HH:MM)',
                              controller: endC,
                              hint: '10:00')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _LabeledField(
                      label: 'Lokasi', controller: locC, hint: 'Lokasi'),
                  const SizedBox(height: 10),
                  _LabeledField(
                      label: 'Catatan',
                      controller: descC,
                      hint: 'Catatan (opsional)'),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kPurple,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            final title = titleC.text.trim();
                            final s = parseTime(startC.text);
                            final e = parseTime(endC.text);
                            if (title.isEmpty ||
                                s == null ||
                                e == null ||
                                e <= s) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Isi judul dan jam yang valid (HH:MM, selesai > mulai).')),
                              );
                              return;
                            }
                            setState(() {
                              _items.add(ScheduleItem(
                                category: cat,
                                date: date,
                                start: s,
                                end: e,
                                title: title,
                                desc: descC.text.trim().isEmpty
                                    ? '-'
                                    : descC.text.trim(),
                                location: locC.text.trim().isEmpty
                                    ? '-'
                                    : locC.text.trim(),
                              ));
                              _selectedDate = date;
                              _focusedMonth =
                                  DateTime(date.year, date.month, 1);
                            });
                            context.pop();
                          },
                          child: const Text('Simpan'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // -------- build --------
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Scaffold(
      backgroundColor: colors.card,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _kPurple,
        foregroundColor: Colors.white,
        onPressed: _openAddSheet,
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _TopHeader(
              title: 'Kalender Jadwal',
              onBack: () => context.pop(),
              onHome: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (r) => false,
                );
              },
            ),
            const SizedBox(height: 4),
            _MonthBar(
              month: _monthNames[_focusedMonth.month - 1],
              year: '${_focusedMonth.year}',
              onPrev: _prevMonth,
              onNext: _nextMonth,
              onTapTitle: _pickDate,
              onToday: _jumpToToday,
            ),
            const SizedBox(height: 6),
            _CategoryLegend(
              enabled: _enabled,
              onToggle: (c) => setState(() {
                if (_enabled.contains(c)) {
                  if (_enabled.length > 1) _enabled.remove(c);
                } else {
                  _enabled.add(c);
                }
              }),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _CalendarGrid(
                focusedMonth: _focusedMonth,
                selectedDate: _selectedDate,
                dotsByDay: _dotsByDay,
                onTap: _onTapDay,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              color: _kPurple,
              child: Row(
                children: [
                  const Icon(Icons.event, size: 16, color: Color(0xFFECECEC)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _dateLabel(_selectedDate),
                      style: const TextStyle(
                        color: Color(0xFFECECEC),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${_visibleItems.length} item',
                    style: const TextStyle(
                      color: Color(0xFFECECEC),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _GanttChart(
              items: _visibleItems,
              enabled: _enabled,
              onTap: _openItemDetails,
            ),
            const SizedBox(height: 6),
            const Divider(height: 1),
            Expanded(
              child: _visibleItems.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada jadwal pada tanggal ini.',
                        style: TextStyle(
                          color: colors.muted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 90),
                      itemCount: _visibleItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final it = _visibleItems[i];
                        return _ItemCard(
                          item: it,
                          onTap: () => _openItemDetails(it),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// TOP HEADER
// =========================================================
class _TopHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onHome;
  const _TopHeader(
      {required this.title, required this.onBack, required this.onHome});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconBtn(icon: Icons.arrow_back, onTap: onBack),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).appColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          _CircleIconBtn(
              icon: Icons.home_filled, iconColor: _kPurple, onTap: onHome),
        ],
      ),
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  const _CircleIconBtn(
      {required this.icon, required this.onTap, this.iconColor});

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

class _MonthBar extends StatelessWidget {
  final String month;
  final String year;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onTapTitle;
  final VoidCallback onToday;
  const _MonthBar({
    required this.month,
    required this.year,
    required this.onPrev,
    required this.onNext,
    required this.onTapTitle,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          _CircleIconBtn(icon: Icons.chevron_left, onTap: onPrev),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTapTitle,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    Text(month,
                        style: const TextStyle(
                            color: Color(0xFF222B45),
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(year,
                        style: const TextStyle(
                            color: Color(0xFF8F9BB3), fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: onToday,
            style: TextButton.styleFrom(
                foregroundColor: _kPurple,
                padding: const EdgeInsets.symmetric(horizontal: 10)),
            child: const Text('Hari ini',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
          ),
          _CircleIconBtn(icon: Icons.chevron_right, onTap: onNext),
        ],
      ),
    );
  }
}

// =========================================================
// LEGEND (tap to toggle category filter)
// =========================================================
class _CategoryLegend extends StatelessWidget {
  final Set<ScheduleCategory> enabled;
  final ValueChanged<ScheduleCategory> onToggle;
  const _CategoryLegend({required this.enabled, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ScheduleCategory.values.map((c) {
          final m = _catMeta[c]!;
          final on = enabled.contains(c);
          return GestureDetector(
            onTap: () => onToggle(c),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:
                    on ? m.color.withValues(alpha: 0.15) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                    color: on ? m.color : const Color(0xFFE5E7EB), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: on ? m.color : const Color(0xFFCBD5E1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    m.label,
                    style: TextStyle(
                      color: on ? m.color : const Color(0xFF9CA3AF),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// =========================================================
// CALENDAR GRID — real dates, Monday-first
// =========================================================
class _CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Map<DateTime, Set<ScheduleCategory>> dotsByDay;
  final ValueChanged<DateTime> onTap;

  const _CalendarGrid({
    required this.focusedMonth,
    required this.selectedDate,
    required this.dotsByDay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    // leading blanks: Monday=1 … Sunday=7 → offset 0..6
    final leading = firstOfMonth.weekday - 1;
    // Always render 6 weeks (42 cells) for a stable height.
    const totalCells = 42;

    final today = _d(DateTime.now());

    final cells = <DateTime>[];
    // prev-month fillers
    for (int i = leading - 1; i >= 0; i--) {
      cells.add(firstOfMonth.subtract(Duration(days: i + 1)));
    }
    // current month
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(focusedMonth.year, focusedMonth.month, d));
    }
    // next-month fillers
    while (cells.length < totalCells) {
      final last = cells.last;
      cells.add(last.add(const Duration(days: 1)));
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
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
        const SizedBox(height: 6),
        GridView.builder(
          itemCount: cells.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (_, i) {
            final d = cells[i];
            final inMonth = _sameMonth(d, focusedMonth);
            final isSel = _sameDay(d, selectedDate);
            final isToday = _sameDay(d, today);
            final cats = dotsByDay[d] ?? const <ScheduleCategory>{};
            return GestureDetector(
              onTap: () => onTap(d),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSel
                          ? _kPurple
                          : (isToday
                              ? _kPurple.withValues(alpha: 0.12)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                      border: (!isSel && isToday)
                          ? Border.all(color: _kPurple, width: 1)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${d.day}',
                      style: TextStyle(
                        color: isSel
                            ? Colors.white
                            : (inMonth
                                ? const Color(0xFF222B45)
                                : const Color(0xFFB9C0CC)),
                        fontSize: 13.5,
                        fontWeight: (isSel || isToday)
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  SizedBox(
                    height: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ScheduleCategory.values
                          .where(cats.contains)
                          .map((c) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: _catMeta[c]!.color,
                                    shape: BoxShape.circle),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WDay extends StatelessWidget {
  final String t;
  const _WDay(this.t);
  @override
  Widget build(BuildContext context) => Text(t,
      style: const TextStyle(color: Color(0xFF8F9BB3), fontSize: 11.5));
}

// =========================================================
// GANTT CHART
// =========================================================
class _GanttChart extends StatelessWidget {
  final List<ScheduleItem> items;
  final Set<ScheduleCategory> enabled;
  final void Function(ScheduleItem) onTap;
  const _GanttChart({
    required this.items,
    required this.enabled,
    required this.onTap,
  });

  static const double startHour = 6;
  static const double endHour = 22;
  static const double hourWidth = 56;
  static const double rowHeight = 34;
  static const double labelColW = 52;
  static const double headerH = 24;

  @override
  Widget build(BuildContext context) {
    final rows = ScheduleCategory.values.where(enabled.contains).toList();
    final totalWidth = (endHour - startHour) * hourWidth;

    return SizedBox(
      height: rows.length * rowHeight + headerH + 4,
      child: Row(
        children: [
          SizedBox(
            width: labelColW,
            child: Padding(
              padding: const EdgeInsets.only(top: headerH),
              child: Column(
                children: rows.map((c) {
                  final m = _catMeta[c]!;
                  return Container(
                    height: rowHeight,
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                              color: m.color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          m.label,
                          style: TextStyle(
                            color: m.color,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: totalWidth,
                child: Stack(
                  children: [
                    for (double h = startHour; h <= endHour; h += 1)
                      Positioned(
                        left: (h - startHour) * hourWidth,
                        top: 0,
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: headerH,
                              child: Text(
                                '${h.toInt().toString().padLeft(2, '0')}:00',
                                style: const TextStyle(
                                  color: Color(0xFF9AA4B2),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 1,
                                color: const Color(0xFFEEF0F4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    for (int r = 0; r < rows.length; r++)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: headerH + r * rowHeight,
                        height: rowHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFFF1F2F6),
                                width: r == rows.length - 1 ? 0 : 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    for (final it in items)
                      if (rows.contains(it.category))
                        Positioned(
                          left: (it.start.clamp(startHour, endHour) -
                                  startHour) *
                              hourWidth,
                          top: headerH +
                              rows.indexOf(it.category) * rowHeight +
                              4,
                          width: ((it.end.clamp(startHour, endHour) -
                                      it.start.clamp(startHour, endHour)) *
                                  hourWidth)
                              .clamp(18.0, double.infinity),
                          height: rowHeight - 8,
                          child: _GanttBar(item: it, onTap: () => onTap(it)),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GanttBar extends StatelessWidget {
  final ScheduleItem item;
  final VoidCallback onTap;
  const _GanttBar({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = _catMeta[item.category]!.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: c.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        alignment: Alignment.centerLeft,
        child: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

// =========================================================
// ITEM CARD
// =========================================================
class _ItemCard extends StatelessWidget {
  final ScheduleItem item;
  final VoidCallback onTap;
  const _ItemCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final meta = _catMeta[item.category]!;
    final colors = Theme.of(context).appColors;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: meta.color.withValues(alpha: 0.6)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0C1C252C),
                blurRadius: 8,
                offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 74,
              decoration: BoxDecoration(
                color: meta.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(meta.icon, size: 13, color: meta.color),
                        const SizedBox(width: 4),
                        Text(meta.label,
                            style: TextStyle(
                                color: meta.color,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900)),
                        const Spacer(),
                        Text(item.timeLabel,
                            style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1B1B1B),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colors.muted, fontSize: 11.5),
                    ),
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

// =========================================================
// SMALL FORM FIELD
// =========================================================
class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  const _LabeledField(
      {required this.label, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _kPurple),
            ),
          ),
        ),
      ],
    );
  }
}
