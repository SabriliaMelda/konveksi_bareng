// unified_schedule_screen.dart
//
// Merged calendar for Jadwal Kirim / Buat / Beli / Upah.
// Fully scrollable — calendar, gantt, and item list all scroll together.

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
  final DateTime date;
  final double start; // hour of day, e.g. 10.5 = 10:30
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
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
const _dayNamesLong = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

// =========================================================
// SCREEN
// =========================================================
class UnifiedScheduleScreen extends StatefulWidget {
  final ScheduleCategory? initialCategory;
  const UnifiedScheduleScreen({super.key, this.initialCategory});

  @override
  State<UnifiedScheduleScreen> createState() => _UnifiedScheduleScreenState();
}

class _UnifiedScheduleScreenState extends State<UnifiedScheduleScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth;
  late final Set<ScheduleCategory> _enabled;
  late final List<ScheduleItem> _items;
  bool _calendarExpanded = false; // ✅ NEW: track calendar expand state

  @override
  void initState() {
    super.initState();
    final today = _d(DateTime.now());
    _selectedDate = today;
    _focusedMonth = DateTime(today.year, today.month, 1);
    _items = _seedItems(today);
    _enabled = widget.initialCategory != null
        ? {widget.initialCategory!}
        : {
            ScheduleCategory.kirim,
            ScheduleCategory.buat,
            ScheduleCategory.beli,
            ScheduleCategory.upah,
          };
  }

  List<ScheduleItem> _seedItems(DateTime today) {
    DateTime offset(int d) => today.add(Duration(days: d));
    return [
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

  // ── derived ──────────────────────────────────────────────────────────────

  List<ScheduleItem> get _visibleItems {
    final list = _items
        .where((e) =>
            _enabled.contains(e.category) && _sameDay(e.date, _selectedDate))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    return list;
  }

  // items grouped by date, for the calendar cell event bars
  Map<DateTime, List<ScheduleItem>> get _itemsByDay {
    final m = <DateTime, List<ScheduleItem>>{};
    for (final it in _items) {
      if (!_enabled.contains(it.category)) continue;
      if (!_sameMonth(it.date, _focusedMonth)) continue;
      m.putIfAbsent(it.date, () => []).add(it);
    }
    // sort each day's items by start time
    for (final list in m.values) {
      list.sort((a, b) => a.start.compareTo(b.start));
    }
    return m;
  }

  String _dateLabel(DateTime dt) {
    final w = _dayNamesLong[dt.weekday - 1];
    final mo = _monthNames[dt.month - 1].substring(0, 3);
    return '$w, ${dt.day.toString().padLeft(2, '0')} $mo ${dt.year}';
  }

  // ── navigation ────────────────────────────────────────────────────────────

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

  // ── item detail sheet ─────────────────────────────────────────────────────

  void _openItemDetails(ScheduleItem it) {
    final meta = _catMeta[it.category]!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).appColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            16, 14, 16, 20 + MediaQuery.of(context).viewInsets.bottom),
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
                Flexible(
                  child: Text(
                    '${_dateLabel(it.date)} • ${it.timeLabel}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
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
                        color: Theme.of(context).appColors.muted, fontSize: 12),
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
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
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
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFDC2626)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  // ── add sheet ─────────────────────────────────────────────────────────────

  void _openAddSheet() {
    ScheduleCategory cat = widget.initialCategory ?? ScheduleCategory.buat;
    DateTime date = _selectedDate;
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);
    final titleC = TextEditingController();
    final descC = TextEditingController();
    final locC = TextEditingController();

    String fmtTime(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).appColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final inset = MediaQuery.of(sheetCtx).viewInsets.bottom;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(18, 14, 18, 18 + inset),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // drag handle
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
                  const Text(
                    'Tambah Jadwal',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Kategori ──
                  const _SheetLabel('Kategori'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ScheduleCategory.values.map((c) {
                      final m = _catMeta[c]!;
                      final active = cat == c;
                      return GestureDetector(
                        onTap: () => setLocal(() => cat = c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: active
                                ? m.color
                                : m.color.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: active
                                  ? m.color
                                  : m.color.withValues(alpha: 0.3),
                            ),
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
                  const SizedBox(height: 14),

                  // ── Tanggal — native date picker ──
                  const _SheetLabel('Tanggal'),
                  const SizedBox(height: 8),
                  _DatePickerTile(
                    label: _dateLabel(date),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: date,
                        firstDate: DateTime(DateTime.now().year - 2),
                        lastDate: DateTime(DateTime.now().year + 3, 12, 31),
                      );
                      if (picked != null) setLocal(() => date = _d(picked));
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Jam — native time picker ──
                  const _SheetLabel('Jam'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _TimePickerTile(
                          label: 'Mulai',
                          time: fmtTime(startTime),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: ctx,
                              initialTime: startTime,
                            );
                            if (picked != null) {
                              setLocal(() => startTime = picked);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TimePickerTile(
                          label: 'Selesai',
                          time: fmtTime(endTime),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: ctx,
                              initialTime: endTime,
                            );
                            if (picked != null) {
                              setLocal(() => endTime = picked);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Fields ──
                  _LabeledField(
                      label: 'Judul', controller: titleC, hint: 'Judul jadwal'),
                  const SizedBox(height: 12),
                  _LabeledField(
                      label: 'Lokasi', controller: locC, hint: 'Lokasi'),
                  const SizedBox(height: 12),
                  _LabeledField(
                    label: 'Catatan',
                    controller: descC,
                    hint: 'Catatan (opsional)',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),

                  // ── Actions ──
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetCtx),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD1D5DB)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text('Batal',
                              style: TextStyle(color: Color(0xFF374151))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          onPressed: () {
                            final title = titleC.text.trim();
                            if (title.isEmpty) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(
                                    content: Text('Judul wajib diisi.')),
                              );
                              return;
                            }
                            final s = startTime.hour + startTime.minute / 60.0;
                            final e = endTime.hour + endTime.minute / 60.0;
                            if (e <= s) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Jam selesai harus lebih dari jam mulai.')),
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
                            Navigator.pop(sheetCtx);
                          },
                          child: const Text('Simpan'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final visible = _visibleItems;

    return Scaffold(
      backgroundColor: colors.card,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _kPurple,
        foregroundColor: Colors.white,
        onPressed: _openAddSheet,
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: _TopHeader(
                title: 'Kalender Jadwal',
                onBack: () => context.pop(),
                onHome: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (r) => false,
                ),
              ),
            ),

            // ── Month bar ──
            SliverToBoxAdapter(
              child: _MonthBar(
                month: _monthNames[_focusedMonth.month - 1],
                year: '${_focusedMonth.year}',
                onPrev: _prevMonth,
                onNext: _nextMonth,
                onToday: _jumpToToday,
              ),
            ),

            // ── Category legend ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
                child: _CategoryLegend(
                  enabled: _enabled,
                  onToggle: (c) => setState(() {
                    if (_enabled.contains(c)) {
                      if (_enabled.length > 1) _enabled.remove(c);
                    } else {
                      _enabled.add(c);
                    }
                  }),
                ),
              ),
            ),

            // ── Calendar grid ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _CalendarGrid(
                  focusedMonth: _focusedMonth,
                  selectedDate: _selectedDate,
                  itemsByDay: _itemsByDay,
                  onTap: _onTapDay,
                  onTapItem: _openItemDetails,
                  isExpanded: _calendarExpanded, // ✅ NEW
                  onToggleExpand: () => setState(
                      () => _calendarExpanded = !_calendarExpanded), // ✅ NEW
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            const SliverToBoxAdapter(child: Divider(height: 1)),

            // ── Selected day label ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
                child: Text(
                  _dateLabel(_selectedDate),
                  style: const TextStyle(
                    color: _kPurple,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            // ── Item list or empty state ──
            if (visible.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'Belum ada jadwal pada tanggal ini.',
                      style: TextStyle(
                        color: colors.muted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final it = visible[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ItemCard(
                          item: it,
                          onTap: () => _openItemDetails(it),
                        ),
                      );
                    },
                    childCount: visible.length,
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

// =========================================================
// MONTH BAR
// =========================================================
class _MonthBar extends StatelessWidget {
  final String month;
  final String year;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;
  const _MonthBar({
    required this.month,
    required this.year,
    required this.onPrev,
    required this.onNext,
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
// CATEGORY LEGEND
// =========================================================
class _CategoryLegend extends StatelessWidget {
  final Set<ScheduleCategory> enabled;
  final ValueChanged<ScheduleCategory> onToggle;
  const _CategoryLegend({required this.enabled, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ScheduleCategory.values.map((c) {
        final m = _catMeta[c]!;
        final on = enabled.contains(c);
        return GestureDetector(
          onTap: () => onToggle(c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: on
                  ? m.color.withValues(alpha: 0.15)
                  : const Color(0xFFF3F4F6),
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
    );
  }
}

// =========================================================
// CALENDAR GRID — real dates, Monday-first, Google Calendar style
// ✅ NEW: Collapsible to show only 1 week
// =========================================================
class _CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Map<DateTime, List<ScheduleItem>> itemsByDay;
  final ValueChanged<DateTime> onTap;
  final void Function(ScheduleItem) onTapItem;
  final bool isExpanded; // ✅ NEW
  final VoidCallback onToggleExpand; // ✅ NEW

  const _CalendarGrid({
    required this.focusedMonth,
    required this.selectedDate,
    required this.itemsByDay,
    required this.onTap,
    required this.onTapItem,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    final leading = firstOfMonth.weekday - 1; // Mon=0 … Sun=6
    const totalCells = 42;
    final today = _d(DateTime.now());

    final cells = <DateTime>[];
    for (int i = leading - 1; i >= 0; i--) {
      cells.add(firstOfMonth.subtract(Duration(days: i + 1)));
    }
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(focusedMonth.year, focusedMonth.month, d));
    }
    while (cells.length < totalCells) {
      cells.add(cells.last.add(const Duration(days: 1)));
    }

    // ✅ NEW: Find which week contains the selected date
    int selectedWeek = 0;
    for (int i = 0; i < cells.length; i++) {
      if (_sameDay(cells[i], selectedDate)) {
        selectedWeek = i ~/ 7;
        break;
      }
    }

    // ✅ NEW: Determine how many weeks to show
    final weeksToShow = isExpanded ? 6 : 1;
    final startWeek = isExpanded ? 0 : selectedWeek;

    return Column(
      children: [
        // weekday header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WDay('Sen'),
              _WDay('Sel'),
              _WDay('Rab'),
              _WDay('Kam'),
              _WDay('Jum'),
              _WDay('Sab'),
              _WDay('Min'),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // ✅ NEW: Animated size for smooth expand/collapse
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              // grid rows (1 week or 6 weeks)
              for (int week = startWeek;
                  week < startWeek + weeksToShow;
                  week++) ...[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(7, (col) {
                      final idx = week * 7 + col;
                      final d = cells[idx];
                      final inMonth = _sameMonth(d, focusedMonth);
                      final isSel = _sameDay(d, selectedDate);
                      final isToday = _sameDay(d, today);
                      final dayItems = itemsByDay[d] ?? const [];
                      const maxVisible = 2;
                      final overflow = dayItems.length > maxVisible
                          ? dayItems.length - maxVisible
                          : 0;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onTap(d),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? _kPurple.withValues(alpha: 0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isSel
                                  ? Border.all(color: _kPurple, width: 1.5)
                                  : null,
                            ),
                            padding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // date number
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: isToday && !isSel
                                        ? _kPurple
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${d.day}',
                                    style: TextStyle(
                                      color: isToday && !isSel
                                          ? Colors.white
                                          : (inMonth
                                              ? const Color(0xFF222B45)
                                              : const Color(0xFFB9C0CC)),
                                      fontSize: 12,
                                      fontWeight: (isSel || isToday)
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                // event pills
                                ...dayItems.take(maxVisible).map((it) {
                                  final c = _catMeta[it.category]!.color;
                                  return GestureDetector(
                                    onTap: () => onTapItem(it),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 2),
                                      height: 13,
                                      decoration: BoxDecoration(
                                        color: c,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        it.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                // overflow indicator
                                if (overflow > 0)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, top: 1),
                                      child: Text(
                                        '+$overflow',
                                        style: TextStyle(
                                          color:
                                              _kPurple.withValues(alpha: 0.7),
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                if (week < startWeek + weeksToShow - 1)
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
              ],
            ],
          ),
        ),
        // ✅ NEW: Expand/Collapse button
        const SizedBox(height: 8),
        InkWell(
          onTap: onToggleExpand,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: _kPurple.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                  color: _kPurple,
                ),
                const SizedBox(width: 6),
                Text(
                  isExpanded ? 'Sembunyikan' : 'Lihat Kalender Penuh',
                  style: const TextStyle(
                    color: _kPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WDay extends StatelessWidget {
  final String t;
  const _WDay(this.t);
  @override
  Widget build(BuildContext context) =>
      Text(t, style: const TextStyle(color: Color(0xFF8F9BB3), fontSize: 11.5));
}

// =========================================================
// ITEM CARD — agenda list style, time shown below title
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
          border: Border.all(color: meta.color.withValues(alpha: 0.5)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0C1C252C), blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // left color bar
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: meta.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // category badge
                    Row(
                      children: [
                        Icon(meta.icon, size: 12, color: meta.color),
                        const SizedBox(width: 4),
                        Text(
                          meta.label,
                          style: TextStyle(
                            color: meta.color,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // title
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1B1B1B),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // time — now below title
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 12, color: Color(0xFF9AA4B2)),
                        const SizedBox(width: 4),
                        Text(
                          item.timeLabel,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // location
                    Row(
                      children: [
                        const Icon(Icons.place_outlined,
                            size: 12, color: Color(0xFF9AA4B2)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: colors.muted, fontSize: 11.5),
                          ),
                        ),
                      ],
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
// SHEET HELPERS
// =========================================================

class _SheetLabel extends StatelessWidget {
  final String text;
  const _SheetLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: Color(0xFF6B7280),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DatePickerTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8ECF4)),
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF9FAFB),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 16, color: Color(0xFF6B7280)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down,
                size: 20, color: Color(0xFF9AA4B2)),
          ],
        ),
      ),
    );
  }
}

class _TimePickerTile extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;
  const _TimePickerTile(
      {required this.label, required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8ECF4)),
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF9FAFB),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time_outlined,
                size: 16, color: Color(0xFF6B7280)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9AA4B2),
                          fontWeight: FontWeight.w700)),
                  Text(time,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827))),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down,
                size: 20, color: Color(0xFF9AA4B2)),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

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
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 13),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
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
              borderSide: const BorderSide(color: _kPurple, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
