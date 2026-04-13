import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const kPurple = Color(0xFF6B257F);
const kLightPurple = Color(0xFFF7E1FF);
const kCardPurple = Color(0xFFCA82DE);

class ManageProjectScreen extends StatelessWidget {
  const ManageProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _HeaderBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _MenuGrid(),
                    SizedBox(height: 24),
                    _SectionHeader(title: 'In Progress', count: 6),
                    SizedBox(height: 12),
                    _InProgressList(),
                    SizedBox(height: 24),
                    _SectionHeader(title: 'Task Groups', count: 4),
                    SizedBox(height: 12),
                    _TaskGroupCard(
                      title: 'Office Project',
                      tasksText: '23 Tasks',
                      percent: 70,
                    ),
                    SizedBox(height: 12),
                    _TaskGroupCard(
                      title: 'Personal Project',
                      tasksText: '30 Tasks',
                      percent: 52,
                    ),
                    SizedBox(height: 12),
                    _TaskGroupCard(
                      title: 'Daily Study',
                      tasksText: '30 Tasks',
                      percent: 87,
                    ),
                    SizedBox(height: 12),
                    _TaskGroupCard(
                      title: 'Daily Study',
                      tasksText: '3 Tasks',
                      percent: 87,
                    ),
                    SizedBox(height: 16),
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

// ================== HEADER ATAS ==================
class _HeaderBar extends StatelessWidget {
  const _HeaderBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ).copyWith(top: 12, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back,
            onTap: () => context.pop(),
          ),
          const Text(
            'Kelola Proyek',
            style: TextStyle(
              color: Color(0xFF24252C),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          _CircleIconButton(icon: Icons.home_filled, onTap: () {}),
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
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE4E4E4)),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
    );
  }
}

// ================== MENU GRID ==================
class _MenuGrid extends StatelessWidget {
  const _MenuGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Daftar Project', Icons.folder_open),
      ('Jadwal', Icons.event_note),
      ('Pekerja', Icons.people_alt_outlined),
      ('Pola', Icons.auto_graph),
      ('Chat', Icons.chat_bubble_outline),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final item in items)
          _MenuItem(
            label: item.$1,
            icon: item.$2,
            onTap: () {
              if (item.$1 == 'Daftar Project') {
                context.push('/project-list');
              } else if (item.$1 == 'Jadwal') {
                context.push('/schedule');
              } else if (item.$1 == 'Pekerja') {
                context.push('/worker');
              } else if (item.$1 == 'Chat') {
                context.push('/chat');
              } else if (item.$1 == 'Pola') {
                context.push('/pattern');
              }
            },
          ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _MenuItem({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 20 * 2 - 12 * 2) / 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF9F7FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: kPurple),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF393333),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== SECTION HEADER ==================
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF24252C),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E4FF),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0x1A6B257F)),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 11,
              color: kPurple,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

//
// ================== IN PROGRESS LIST (REVISI - LEBIH NYAMBUNG) ==================
//
class _InProgressList extends StatelessWidget {
  const _InProgressList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 178,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 2),
        children: const [
          _InProgressCard(
            title: 'Grocery shopping app design',
            subtitle: 'Office Project',
            progress: 0.65,
            accent: kPurple,
            soft: Color(0xFFF7E1FF),
            icon: Icons.storefront_rounded,
            chip: 'UI/UX',
            eta: '3 days left',
          ),
          SizedBox(width: 12),
          _InProgressCard(
            title: 'Uber Eats redesign challenge',
            subtitle: 'Personal Project',
            progress: 0.45,
            accent: Color(0xFFBA53FF),
            soft: Color(0xFFF3E4FF),
            icon: Icons.delivery_dining_rounded,
            chip: 'Redesign',
            eta: '1 week left',
          ),
          SizedBox(width: 12),
          _InProgressCard(
            title: 'Landing page konveksi',
            subtitle: 'Client Project',
            progress: 0.82,
            accent: kPurple,
            soft: Color(0xFFF3E4FF),
            icon: Icons.design_services_rounded,
            chip: 'Web',
            eta: '2 days left',
          ),
        ],
      ),
    );
  }
}

class _InProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  final Color accent;
  final Color soft;
  final IconData icon;
  final String chip;
  final String eta;

  const _InProgressCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.accent,
    required this.soft,
    required this.icon,
    required this.chip,
    required this.eta,
  });

  @override
  Widget build(BuildContext context) {
    final int percent = (progress.clamp(0.0, 1.0) * 100).round();

    return Container(
      width: 245,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [soft, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InProgressTopRow(
            subtitle: subtitle,
            chip: chip,
            accent: accent,
            icon: icon,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF24252C),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          // progress bar + badge %
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0x1A000000)),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: LinearGradient(
                          colors: [accent, accent.withValues(alpha: 0.6)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0x1A000000)),
                ),
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: 12,
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // footer info (ETA + kecil)
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16,
                color: accent.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 6),
              Text(
                eta,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6E6A7C),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x1A000000)),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: accent,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InProgressTopRow extends StatelessWidget {
  final String subtitle;
  final String chip;
  final Color accent;
  final IconData icon;

  const _InProgressTopRow({
    required this.subtitle,
    required this.chip,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // chip kategori
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0x1A000000)),
          ),
          child: Text(
            chip,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ),
        const SizedBox(width: 8),

        // subtitle
        Expanded(
          child: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6E6A7C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // icon box
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x1A000000)),
          ),
          child: Icon(icon, color: accent, size: 18),
        ),
      ],
    );
  }
}

// ================== TASK GROUP CARDS ==================
class _TaskGroupCard extends StatelessWidget {
  final String title;
  final String tasksText;
  final int percent;

  const _TaskGroupCard({
    required this.title,
    required this.tasksText,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 32,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF3E4FF),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.folder_copy_outlined,
                color: kPurple,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF24252C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tasksText,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6E6A7C),
                    ),
                  ),
                ],
              ),
            ),
            _TaskGroupProgressBadge(percent: percent),
          ],
        ),
      ),
    );
  }
}

class _TaskGroupProgressBadge extends StatelessWidget {
  final int percent;
  const _TaskGroupProgressBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFF3E4FF),
        shape: BoxShape.circle,
        border: Border.all(color: kPurple, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '$percent%',
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF24252C),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
