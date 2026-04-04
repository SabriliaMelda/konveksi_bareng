// jadwal_belanja.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

const kPurple = Color(0xFF6B257F);

class ShoppingScheduleScreen extends StatefulWidget {
  const ShoppingScheduleScreen({super.key});

  @override
  State<ShoppingScheduleScreen> createState() => _ShoppingScheduleScreenState();
}

class _ShoppingScheduleScreenState extends State<ShoppingScheduleScreen> {
  int selectedDay = DateTime.now().day;

  // indikator dot per tanggal (dummy)
  final Map<int, List<Color>> dots = {
    2: [Color(0xFF00B383), Color(0xFF0095FF)],
    5: [Color(0xFF735BF2)],
    10: [Color(0xFF0095FF), Color(0xFF735BF2)],
    15: [Color(0xFF00B383)],
    22: [Color(0xFF0095FF)],
    29: [Color(0xFF00B383), Color(0xFF0095FF), Color(0xFF735BF2)],
  };

  // dummy data jadwal belanja (fashion)
  final List<_BelanjaSchedule> schedules = [
    _BelanjaSchedule(
      day: 5,
      time: '10:00 - 12:00',
      title: 'Belanja kain (Cotton Combed)',
      desc: 'Cari bahan untuk produksi kaos basic, bandingkan 2 toko.',
      location: 'Pasar Baru',
      tag: _BelanjaTag.bahan,
    ),
    _BelanjaSchedule(
      day: 5,
      time: '13:30 - 14:30',
      title: 'Beli aksesoris (kancing & resleting)',
      desc: 'Kebutuhan untuk 30 pcs outerwear.',
      location: 'Toko Aksesoris Sinar',
      tag: _BelanjaTag.aksesoris,
    ),
    _BelanjaSchedule(
      day: 10,
      time: '09:00 - 10:30',
      title: 'Belanja packaging',
      desc: 'Poly mailer + sticker logo + thank you card.',
      location: 'Marketplace (Online)',
      tag: _BelanjaTag.packaging,
    ),
    _BelanjaSchedule(
      day: 15,
      time: '15:00 - 16:00',
      title: 'Cetak label brand',
      desc: 'Order label woven untuk batch produksi berikutnya.',
      location: 'Vendor Label',
      tag: _BelanjaTag.vendor,
    ),
  ];

  // =========================
  // HELPERS
  // =========================
  String _monthName(int m) {
    const months = [
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
    return months[m - 1];
  }

  String _dateLabel() {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, selectedDay);
    const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final wd = w[dt.weekday - 1];
    String two(int x) => x.toString().padLeft(2, '0');
    return '$wd, ${two(dt.day)} ${_monthName(dt.month).substring(0, 3)}, ${dt.year}';
  }

  List<_BelanjaSchedule> get _activeSchedules =>
      schedules.where((e) => e.day == selectedDay).toList();

  // =========================
  // ACTIONS
  // =========================
  void _openAddSheet() {
    final titleC = TextEditingController();
    final descC = TextEditingController();
    final locC = TextEditingController();
    final timeC = TextEditingController(text: '10:00 - 11:00');
    _BelanjaTag tag = _BelanjaTag.bahan;

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
                    'Tambah Jadwal Belanja (dummy)',
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
                    label: 'Judul',
                    hint: 'Contoh: Belanja kain untuk produksi',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: timeC,
                    label: 'Waktu',
                    hint: 'Contoh: 10:00 - 12:00',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: locC,
                    label: 'Lokasi',
                    hint: 'Contoh: Pasar Baru / Marketplace',
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    controller: descC,
                    label: 'Catatan',
                    hint: 'Contoh: bandingkan 2 toko',
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Kategori',
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
                          label: 'Bahan',
                          active: tag == _BelanjaTag.bahan,
                          onTap: () => setLocal(() => tag = _BelanjaTag.bahan),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ChoicePill(
                          label: 'Aksesoris',
                          active: tag == _BelanjaTag.aksesoris,
                          onTap: () =>
                              setLocal(() => tag = _BelanjaTag.aksesoris),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ChoicePill(
                          label: 'Pack',
                          active: tag == _BelanjaTag.packaging,
                          onTap: () =>
                              setLocal(() => tag = _BelanjaTag.packaging),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoicePill(
                          label: 'Vendor',
                          active: tag == _BelanjaTag.vendor,
                          onTap: () => setLocal(() => tag = _BelanjaTag.vendor),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ChoicePill(
                          label: 'Lainnya',
                          active: tag == _BelanjaTag.lainnya,
                          onTap: () =>
                              setLocal(() => tag = _BelanjaTag.lainnya),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(child: SizedBox()),
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
                            final t = titleC.text.trim();
                            if (t.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Judul wajib diisi'),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              schedules.insert(
                                0,
                                _BelanjaSchedule(
                                  day: selectedDay,
                                  time: timeC.text.trim().isEmpty
                                      ? '10:00 - 11:00'
                                      : timeC.text.trim(),
                                  title: t,
                                  desc: descC.text.trim().isEmpty
                                      ? '-'
                                      : descC.text.trim(),
                                  location: locC.text.trim().isEmpty
                                      ? '-'
                                      : locC.text.trim(),
                                  tag: tag,
                                ),
                              );
                              dots[selectedDay] =
                                  (dots[selectedDay] ??
                                  [const Color(0xFF0095FF)]);
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Jadwal ditambahkan (dummy)'),
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

  void _openItemAction(_BelanjaSchedule e) {
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
                icon: Icons.delete_outline_rounded,
                label: 'Hapus jadwal (dummy)',
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
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        foregroundColor: Colors.white,
        onPressed: _openAddSheet,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _TopHeader(
              title: 'Jadwal Belanja',
              onTapBack: () => Navigator.pop(context),
              onTapHome: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
            ),

            const SizedBox(height: 10),

            // MONTH HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _CircleIcon(icon: Icons.chevron_left, onTap: () {}),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        _monthName(now.month),
                        style: const TextStyle(
                          color: Color(0xFF222B45),
                          fontSize: 18,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${now.year}',
                        style: const TextStyle(
                          color: Color(0xFF8F9BB3),
                          fontSize: 12,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _CircleIcon(icon: Icons.chevron_right, onTap: () {}),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // WEEKDAY HEADER
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

            // CALENDAR GRID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _CalendarGrid(
                selectedDay: selectedDay,
                dots: dots,
                onTapDay: (d) => setState(() => selectedDay = d),
              ),
            ),

            const SizedBox(height: 12),

            // PURPLE DATE BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: kPurple,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const _SmallDot(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _dateLabel(),
                        style: const TextStyle(
                          color: Color(0xFFECECEC),
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        '${_activeSchedules.length} item',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // LIST
            Expanded(
              child: _activeSchedules.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada jadwal belanja pada tanggal ini.',
                        style: TextStyle(
                          color: Color(0xFF6A707C),
                          fontSize: 12.5,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      itemCount: _activeSchedules.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final e = _activeSchedules[i];
                        final meta = _tagMeta(e.tag);
                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _openItemAction(e),
                          child: _ScheduleCard(
                            time: e.time,
                            title: e.title,
                            desc: e.desc,
                            location: e.location,
                            barColor: meta.color,
                            borderColor: meta.color,
                            badge: meta.text,
                          ),
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

//
// ================== WIDGETS ==================
//
class _TopHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTapBack;
  final VoidCallback onTapHome;

  const _TopHeader({
    required this.title,
    required this.onTapBack,
    required this.onTapHome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIcon(icon: Icons.arrow_back, onTap: onTapBack),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF121111),
              fontSize: 16,
              fontFamily: 'Encode Sans',
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          _CircleIcon(
            icon: Icons.home_filled,
            iconColor: kPurple,
            onTap: onTapHome,
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
          border: Border.all(color: const Color(0xFFDFDEDE)),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C1C252C),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
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
        fontFamily: 'Lato',
      ),
    );
  }
}

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
    // grid sederhana: 1..31 (tanpa offset weekday biar simpel)
    final days = List<int>.generate(31, (i) => i + 1);

    return GridView.builder(
      itemCount: days.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 6,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final day = days[index];
        final isSelected = day == selectedDay;

        return GestureDetector(
          onTap: () => onTapDay(day),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFDBC0F2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected ? kPurple : const Color(0xFF222B45),
                    fontSize: 14.5,
                    fontFamily: 'Lato',
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 6,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: (dots[day] ?? const [])
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

class _ScheduleCard extends StatelessWidget {
  final String time;
  final String title;
  final String desc;
  final String location;
  final Color borderColor;
  final Color barColor;
  final String badge;

  const _ScheduleCard({
    required this.time,
    required this.title,
    required this.desc,
    required this.location,
    required this.borderColor,
    required this.barColor,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C1C252C),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 128,
            decoration: BoxDecoration(
              color: barColor,
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
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Color(0xFF9A9A9A),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Color(0xFF9A9A9A),
                          fontSize: 12,
                          fontFamily: 'Lato',
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F7F8),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFE8ECF4)),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: barColor,
                            fontSize: 11,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1B1B1B),
                      fontSize: 15.5,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF575A66),
                      fontSize: 12,
                      fontFamily: 'Lato',
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Color(0xFF575A66),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Color(0xFF575A66),
                            fontSize: 12,
                            fontFamily: 'Lato',
                          ),
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

//
// ================== MODELS ==================
//
enum _BelanjaTag { bahan, aksesoris, packaging, vendor, lainnya }

class _BelanjaSchedule {
  final int day;
  final String time;
  final String title;
  final String desc;
  final String location;
  final _BelanjaTag tag;

  _BelanjaSchedule({
    required this.day,
    required this.time,
    required this.title,
    required this.desc,
    required this.location,
    required this.tag,
  });
}

class _TagMeta {
  final String text;
  final Color color;
  const _TagMeta(this.text, this.color);
}

_TagMeta _tagMeta(_BelanjaTag t) {
  switch (t) {
    case _BelanjaTag.bahan:
      return const _TagMeta('Bahan', Color(0xFF26BFBF));
    case _BelanjaTag.aksesoris:
      return const _TagMeta('Aksesoris', Color(0xFF735BF2));
    case _BelanjaTag.packaging:
      return const _TagMeta('Packaging', Color(0xFF0095FF));
    case _BelanjaTag.vendor:
      return const _TagMeta('Vendor', Color(0xFF00B383));
    case _BelanjaTag.lainnya:
      return const _TagMeta('Lainnya', Color(0xFFE65100));
  }
}
