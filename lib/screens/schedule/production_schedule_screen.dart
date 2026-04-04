// jadwal_buat.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/project/meeting.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

const kPurple = Color(0xFF6B257F);

class ProductionScheduleScreen extends StatefulWidget {
  const ProductionScheduleScreen({super.key});

  @override
  State<ProductionScheduleScreen> createState() => _ProductionScheduleScreenState();
}

class _ProductionScheduleScreenState extends State<ProductionScheduleScreen> {
  int selectedDay = 2; // default

  // dummy dot indikator per tanggal
  final Map<int, List<Color>> dots = {
    2: [Color(0xFF00B383), Color(0xFF0095FF), Color(0xFF735BF2)],
    3: [Color(0xFF0095FF)],
    10: [Color(0xFF00B383), Color(0xFF0095FF), Color(0xFF735BF2)],
    15: [Color(0xFF735BF2)],
    22: [Color(0xFF0095FF), Color(0xFF735BF2)],
    29: [Color(0xFF00B383), Color(0xFF0095FF)],
    30: [Color(0xFF0095FF)],
  };

  final List<_ScheduleCardData> schedules = const [
    _ScheduleCardData(
      time: '11:30 AM - 12:30 PM',
      title: 'Sales Presentation',
      desc:
          'A sales presentation with a potential client. The meeting is set to take place in London, and the application has adjusted the time to the local time zone.',
      location: 'London, UK',
      borderColor: Color(0xFF26BFBF),
      barColor: Color(0xFF26BFBF),
    ),
    _ScheduleCardData(
      time: '3:00 PM - 4:30 PM',
      title: 'Business Development Discussion',
      desc:
          'A discussion on business development strategies with the team. The app has seamlessly adjusted the time for Valentina, considering the time zone difference.',
      location: 'New York, USA',
      borderColor: Color(0xFF89AFFF),
      barColor: Color(0xFF89AFFF),
    ),
  ];

  String _selectedDateLabel() {
    // dummy label mengikuti screenshot
    return 'Thursday, 05 Jan, 2024';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _TopHeader(
              title: 'Jadwal Buat',
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

            // ===== MONTH HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _CircleIcon(icon: Icons.chevron_left, onTap: () {}),
                  const Spacer(),
                  Column(
                    children: const [
                      Text(
                        'January',
                        style: TextStyle(
                          color: Color(0xFF222B45),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
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
                  const Spacer(),
                  _CircleIcon(icon: Icons.chevron_right, onTap: () {}),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ===== WEEKDAY HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
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

            // ===== CALENDAR GRID =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _CalendarGrid(
                selectedDay: selectedDay,
                dots: dots,
                onTapDay: (d) => setState(() => selectedDay = d),
              ),
            ),

            const SizedBox(height: 12),

            // ===== PURPLE DATE BAR (PILL) =====
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
                        _selectedDateLabel(),
                        style: const TextStyle(
                          color: Color(0xFFECECEC),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ===== LIST SCHEDULE =====
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: ListView.separated(
                  itemCount: schedules.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final item = schedules[i];
                    return _ScheduleCard(item: item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== FLOATING BUTTON GROUP (KANAN BAWAH) =====
      floatingActionButton: _FloatingActionGroup(
        onTapCalendar: () {
          // TODO: aksi kalender mini
        },
        onTapMiddle: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MeetingScreen()),
          );
        },
        onTapPlus: () {
          // TODO: tambah jadwal
        },
      ),
    );
  }
}

//
// ================== TOP HEADER ==================
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

//
// ================== WEEKDAY TEXT ==================
//
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
// ================== CALENDAR GRID (MANUAL) ==================
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
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final cell = days[index];
        final isSelected = !cell.muted && cell.day == selectedDay;

        return GestureDetector(
          onTap: cell.muted ? null : () => onTapDay(cell.day),
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
                  '${cell.day}',
                  style: TextStyle(
                    color: cell.muted
                        ? const Color(0xFF8F9BB3)
                        : (isSelected ? kPurple : const Color(0xFF222B45)),
                    fontSize: 14.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

//
// ================== PURPLE BAR DOT ==================
//
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
// ================== SCHEDULE CARD ==================
//
class _ScheduleCardData {
  final String time;
  final String title;
  final String desc;
  final String location;
  final Color borderColor;
  final Color barColor;

  const _ScheduleCardData({
    required this.time,
    required this.title,
    required this.desc,
    required this.location,
    required this.borderColor,
    required this.barColor,
  });
}

class _ScheduleCard extends StatelessWidget {
  final _ScheduleCardData item;
  const _ScheduleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: item.borderColor, width: 1),
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
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Color(0xFF9A9A9A),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: const TextStyle(
                          color: Color(0xFF9A9A9A),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.more_vert,
                        size: 18,
                        color: Color(0xFFD8DEF3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Color(0xFF1B1B1B),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF575A66),
                      fontSize: 12,
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
                          item.location,
                          style: const TextStyle(
                            color: Color(0xFF575A66),
                            fontSize: 12,
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

//
// ================== FLOATING BUTTON GROUP (KANAN BAWAH) ==================
//
class _FloatingActionGroup extends StatelessWidget {
  final VoidCallback onTapCalendar;
  final VoidCallback onTapMiddle;
  final VoidCallback onTapPlus;

  const _FloatingActionGroup({
    required this.onTapCalendar,
    required this.onTapMiddle,
    required this.onTapPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MiniFab(icon: Icons.event_note, onTap: onTapCalendar),
        const SizedBox(width: 12),
        _MiniFab(icon: Icons.work_outline, onTap: onTapMiddle),
        const SizedBox(width: 12),

        // PLUS (kotak ungu seperti screenshot)
        GestureDetector(
          onTap: onTapPlus,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: kPurple,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 12,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.add, size: 28, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _MiniFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MiniFab({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 22, color: kPurple),
      ),
    );
  }
}
