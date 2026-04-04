// jadwal.dart
import 'package:konveksi_bareng/screens/schedule/jadwal_belanja.dart';
import 'package:konveksi_bareng/screens/schedule/jadwal_kirim.dart';
import 'package:konveksi_bareng/screens/worker/jadwal_upah.dart';
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/schedule/jadwal_buat.dart';
import 'package:konveksi_bareng/screens/project/spk.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

const kPurple = Color(0xFF6B257F);

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  int _selectedIndex = 3; // default: Thu 07 (sesuai desain)

  final List<_DayItem> _days = const [
    _DayItem(label: 'Mon', date: '02'),
    _DayItem(label: 'Tue', date: '03'),
    _DayItem(label: 'Wed', date: '04'),
    _DayItem(label: 'Thu', date: '07'),
    _DayItem(label: 'Fri', date: '06'),
    _DayItem(label: 'Sat', date: '05'),
    _DayItem(label: 'Sun', date: '08'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _HeaderBar(),
            const SizedBox(height: 8),
            _DaySelector(
              days: _days,
              selectedIndex: _selectedIndex,
              onSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFEDE8E8)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: const _JadwalMenuGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ================== HEADER ATAS ==================
//
class _HeaderBar extends StatelessWidget {
  const _HeaderBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ).copyWith(top: 12, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          const Text(
            'Jadwal',
            style: TextStyle(
              color: Color(0xFF121111),
              fontSize: 16,
              fontFamily: 'Encode Sans',
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          _CircleIconButton(
            icon: Icons.home_filled,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFDFDEDE)),
          color: Colors.white,
        ),
        child: Icon(
          icon,
          size: 20,
          color: icon == Icons.home_filled ? kPurple : Colors.black87,
        ),
      ),
    );
  }
}

//
// ================== DAY SELECTOR (HORIZONTAL) ==================
//
class _DayItem {
  final String label;
  final String date;

  const _DayItem({required this.label, required this.date});
}

class _DaySelector extends StatelessWidget {
  final List<_DayItem> days;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _DaySelector({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = days[index];
          final bool isActive = index == selectedIndex;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: Column(
              children: [
                Container(
                  width: 50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFF2E2F8) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFFA98B98)
                          : const Color(0xFFF8EDE2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isActive
                              ? const Color(0xFFC7B2BB)
                              : const Color(0xFFABABAB),
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w300,
                          height: 1.6,
                        ),
                      ),
                      Text(
                        item.date,
                        style: TextStyle(
                          color: isActive
                              ? const Color(0xFF81616F)
                              : const Color(0xFF797979),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Opacity(
                  opacity: 0.6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _Dot(color: Color(0xFF26BFBF)),
                      SizedBox(width: 4),
                      _Dot(color: Color(0xFF89AFFF)),
                      SizedBox(width: 4),
                      _Dot(color: Color(0xFFFFB017)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

//
// ================== MENU GRID JADWAL ==================
//
class _JadwalMenuGrid extends StatelessWidget {
  const _JadwalMenuGrid();

  @override
  Widget build(BuildContext context) {
    final menus = [
      _JadwalMenuItem(label: 'SPK', icon: Icons.description_outlined),
      _JadwalMenuItem(label: 'Jadwal Buat', icon: Icons.calendar_month),
      _JadwalMenuItem(
        label: 'Jadwal Belanja',
        icon: Icons.shopping_bag_outlined,
      ),
      _JadwalMenuItem(label: 'Jadwal Upah', icon: Icons.payments_outlined),
      _JadwalMenuItem(label: 'Jadwal Kirim', icon: Icons.send_rounded),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: menus.map((item) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 24 * 2 - 12 * 2) / 3,
          child: _JadwalMenuCard(item: item),
        );
      }).toList(),
    );
  }
}

class _JadwalMenuItem {
  final String label;
  final IconData icon;

  _JadwalMenuItem({required this.label, required this.icon});
}

class _JadwalMenuCard extends StatelessWidget {
  final _JadwalMenuItem item;

  const _JadwalMenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // ✅ NAVIGASI SPK
        if (item.label == 'SPK') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SpkScreen()),
          );
          return;
        }

        // ✅ NAVIGASI JADWAL BUAT
        if (item.label == 'Jadwal Buat') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JadwalBuatScreen()),
          );
          return;
        }

        if (item.label == 'Jadwal Belanja') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JadwalBelanjaScreen()),
          );
          return;
        }

        if (item.label == 'Jadwal Upah') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JadwalUpahScreen()),
          );
          return;
        }

        if (item.label == 'Jadwal Kirim') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JadwalKirimScreen()),
          );
          return;
        }

        // TODO: menu lain nanti
      },
      child: Container(
        height: 86,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 26, color: kPurple),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF393333),
                  fontSize: 12,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
