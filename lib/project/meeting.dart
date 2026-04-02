// meeting.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/project/buat_meeting.dart'; // ✅ tambah ini

const kPurple = Color(0xFF6B257F);

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final List<_MeetingItem> due = const [
    _MeetingItem(
      color: Color(0xFF26BFBF),
      time: '11:30 AM - 12:30 PM',
      title: 'Sales Presentation',
      desc:
          'A sales presentation with a potential client. The meeting is set to take place in London, and the a...',
      location: 'London, UK',
    ),
    _MeetingItem(
      color: Color(0xFF89AFFF),
      time: '3:00 PM - 4:30 PM',
      title: 'Business Development Discussion',
      desc:
          'A discussion on business development strategies with the team. The app has seamlessly adjusted...',
      location: 'New York, USA',
    ),
  ];

  final List<_MeetingItem> upcoming = const [
    _MeetingItem(
      color: Color(0xFFFFB017),
      time: '8:30 AM - 9:30 AM',
      title: 'Team Collaboration',
      desc:
          'Collaborative session with the international team in Tokyo. The application has factored in the tim...',
      location: 'Tokyo, Japan',
    ),
    _MeetingItem(
      color: Color(0xFF26BFBF),
      time: '11:30 AM - 12:30 PM',
      title: 'Sales Presentation',
      desc:
          'A sales presentation with a potential client. The meeting is set to take place in London, and the a...',
      location: 'London, UK',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ====== FLOATING PLUS (ungu) ======
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        onPressed: () {
          // ✅ pindah ke halaman buat_meeting.dart
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BuatMeetingScreen()),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      // ====== BOTTOM BAR (calendar + Meetings) ======
      bottomNavigationBar: const _MeetingsBottomBar(),

      body: SafeArea(
        child: Column(
          children: [
            // ===== TOP HEADER =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleBtn(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Jadwal Buat',
                    style: TextStyle(
                      color: Color(0xFF121111),
                      fontSize: 16,
                      fontFamily: 'Encode Sans',
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  _CircleBtn(
                    icon: Icons.home_filled,
                    iconColor: kPurple,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // ===== TITLE ROW: "Jan 2024" + filter/search =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Jan 2024',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 20,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 1.6,
                      ),
                    ),
                  ),
                  _SquareIcon(
                    icon: Icons.tune_rounded, // filter
                    borderColor: Color(0xFFC4D7FF),
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _SquareIcon(
                    icon: Icons.search_rounded,
                    borderColor: Color(0xFFA98B98),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // ===== LIST =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                children: [
                  // Due header
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Due (2). ',
                          style: TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        TextSpan(
                          text: 'Today, Thursday 05',
                          style: TextStyle(
                            color: Color(0xFF575A66),
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...due.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _MeetingCard(item: e),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Upcoming header
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Upcoming (3). ',
                          style: TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        TextSpan(
                          text: 'Friday ',
                          style: TextStyle(
                            color: Color(0xFF575A66),
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        TextSpan(
                          text: '06',
                          style: TextStyle(
                            color: Color(0xFF575A66),
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...upcoming.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _MeetingCard(item: e),
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
}

//
// ===================== WIDGETS =====================
//
class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleBtn({required this.icon, required this.onTap, this.iconColor});

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
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: iconColor ?? Colors.black87),
      ),
    );
  }
}

class _SquareIcon extends StatelessWidget {
  final IconData icon;
  final Color borderColor;
  final VoidCallback onTap;

  const _SquareIcon({
    required this.icon,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1),
          color: Colors.white,
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF333333)),
      ),
    );
  }
}

class _MeetingItem {
  final Color color;
  final String time;
  final String title;
  final String desc;
  final String location;

  const _MeetingItem({
    required this.color,
    required this.time,
    required this.title,
    required this.desc,
    required this.location,
  });
}

class _MeetingCard extends StatelessWidget {
  final _MeetingItem item;
  const _MeetingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 129,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.color, width: 1),
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
          // bar kiri warna
          Container(
            width: 10,
            height: double.infinity,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Color(0xE59A9A9A),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: const TextStyle(
                          color: Color(0xE59A9A9A),
                          fontSize: 12,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          height: 1.4,
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
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Almarai',
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
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Color(0xFF575A66),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.location,
                        style: const TextStyle(
                          color: Color(0xFF575A66),
                          fontSize: 12,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          height: 1.4,
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

class _MeetingsBottomBar extends StatelessWidget {
  const _MeetingsBottomBar();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 76,
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FA),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 20,
              offset: Offset(-2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(width: 18),
            const Icon(Icons.cases_outlined, color: Color(0xFF111111)),
            const SizedBox(width: 10),
            const Text(
              'Meetings',
              style: TextStyle(
                color: Color(0xFF111111),
                fontSize: 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 56),
          ],
        ),
      ),
    );
  }
}
