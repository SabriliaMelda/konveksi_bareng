// kelola_proyek_dashboard.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/widgets/app_bottom_nav.dart';
import 'package:konveksi_bareng/screens/home/schedule/unified_schedule_screen.dart';
import 'package:konveksi_bareng/screens/home/worker/worker_list_screen.dart';
import 'package:konveksi_bareng/screens/home/project/work_order_screen.dart';

const kPurple = Color(0xFF6B257F);
const _kSoft = Color(0xFFF7E1FF);
const _kSoft2 = Color(0xFFF3E4FF);

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────

class _Project {
  final int id;
  final String title;
  final String client;
  final String status;
  final double progress;
  final String imagePath;
  final String deadline;
  final int nilaiProject;

  const _Project({
    required this.id,
    required this.title,
    required this.client,
    required this.status,
    required this.progress,
    required this.imagePath,
    required this.deadline,
    required this.nilaiProject,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ManageProjectScreen extends StatefulWidget {
  const ManageProjectScreen({super.key});

  @override
  State<ManageProjectScreen> createState() => _ManageProjectScreenState();
}

class _ManageProjectScreenState extends State<ManageProjectScreen> {
  final _searchC = TextEditingController();
  int _filterIndex = 0;

  final List<_Project> _projects = List.generate(6, (i) {
    final statuses = ['On Track', 'Revisi', 'Urgent'];
    final images = [
      'assets/images/rucas.jpg',
      'assets/images/nike.jpg',
      'assets/images/adidas.jpg',
    ];
    return _Project(
      id: i + 1,
      title: 'Project ${i + 1}',
      client: 'Client ${(i % 4) + 1}',
      status: statuses[i % statuses.length],
      progress: (0.25 + (i % 4) * 0.18).clamp(0.0, 1.0),
      imagePath: images[i % images.length],
      deadline: '${(i % 9) + 2} hari lagi',
      nilaiProject: 15000000 + (i * 3500000),
    );
  });

  List<_Project> get _filtered {
    final q = _searchC.text.trim().toLowerCase();
    final base = q.isEmpty
        ? _projects
        : _projects.where((p) => p.title.toLowerCase().contains(q)).toList();
    if (_filterIndex == 0) return base;
    if (_filterIndex == 1) {
      return base.where((p) => p.status == 'On Track').toList();
    }
    if (_filterIndex == 2) {
      return base.where((p) => p.status == 'Revisi').toList();
    }
    return base.where((p) => p.status == 'Urgent').toList();
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = _filtered;

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.card,
      bottomNavigationBar: AppBottomNav(activeIndex: -1),

      // ── Chat FAB ──
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPurple,
        onPressed: () => context.push('/chat'),
        icon:
            const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
        label: const Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ── TOP ROW: BACK + SEARCH ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _NavIconButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _NavSearchPill(
                      controller: _searchC,
                      hint: 'Cari project...',
                      onChanged: (_) => setState(() {}),
                      onClear: () {
                        _searchC.clear();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── TITLE ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kelola Proyek',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── FILTER CHIPS ──
            SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount:
                    const ['Semua', 'On Track', 'Revisi', 'Urgent'].length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  const labels = ['Semua', 'On Track', 'Revisi', 'Urgent'];
                  final active = i == _filterIndex;
                  return InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => setState(() => _filterIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? kPurple : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          color:
                              active ? Colors.white : const Color(0xFF555555),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── JADWAL ──
                    _SectionHeader(
                      title: 'Jadwal',
                    ),
                    const SizedBox(height: 12),
                    _JadwalGrid(),

                    const SizedBox(height: 28),

                    // ── POLA ──
                    _SectionHeader(
                      title: 'Pola',
                    ),
                    const SizedBox(height: 12),
                    // ✅ NEW: Big rectangle button to pattern screen
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => context.push('/pattern'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).appColors.card,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 14,
                              offset: Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: kPurple.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: _kSoft2,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.content_cut_rounded,
                                color: kPurple,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Kelola Pola',
                                    style: TextStyle(
                                      color: Color(0xFF111827),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Lihat dan kelola semua pola produksi',
                                    style: TextStyle(
                                      color: Theme.of(context).appColors.muted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: kPurple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── DAFTAR PROJECT ──
                    _SectionHeader(
                      title: 'Daftar Project',
                      count: projects.length,
                      onSeeAll: () => context.push('/project-list'),
                    ),
                    const SizedBox(height: 12),
                    if (projects.isEmpty)
                      _EmptyState(message: 'Tidak ada project ditemukan.')
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: projects.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          mainAxisExtent: 255,
                        ),
                        itemBuilder: (_, i) =>
                            _ProjectCard(project: projects[i]),
                      ),

                    const SizedBox(height: 16),
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

// ─────────────────────────────────────────────────────────────────────────────
// NAV WIDGETS (shipment-style)
// ─────────────────────────────────────────────────────────────────────────────

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }
}

class _NavSearchPill extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _NavSearchPill({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF010101)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  color: Theme.of(context).appColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF010101),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close, size: 18, color: Color(0xFF777777)),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final int? count;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.count, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).appColors.ink,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _kSoft2,
              borderRadius: BorderRadius.circular(999),
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
        const Spacer(),
        if (onSeeAll != null)
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onSeeAll,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                'Lihat semua',
                style: TextStyle(
                  color: kPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROJECT CARD
// ─────────────────────────────────────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  final _Project project;
  const _ProjectCard({required this.project});

  String _formatRupiah(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write('.');
    }
    return 'Rp $buf';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Urgent':
        return const Color(0xFFEB6383);
      case 'Revisi':
        return const Color(0xFFF59E0B);
      default:
        return kPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = _statusColor(project.status);
    final pct = (project.progress * 100).round();

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8)),
          ],
          border: Border.all(color: const Color(0x0FE8ECF4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // thumbnail
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                      child: Image.asset(project.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.0),
                            Colors.black.withValues(alpha: 0.45),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: sc.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        project.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$pct%',
                        style: const TextStyle(
                          color: kPurple,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 10,
                    child: Text(
                      project.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // info bawah
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.client,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatRupiah(project.nilaiProject),
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 7,
                    decoration: BoxDecoration(
                      color: _kSoft2,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: project.progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: LinearGradient(
                            colors: [sc, sc.withValues(alpha: 0.65)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 14, color: sc),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          project.deadline,
                          style: TextStyle(
                            color: Theme.of(context).appColors.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _kSoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_forward_rounded,
                            color: kPurple, size: 16),
                      ),
                    ],
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

// ─────────────────────────────────────────────────────────────────────────────
// JADWAL GRID
// ─────────────────────────────────────────────────────────────────────────────

class _JadwalGrid extends StatelessWidget {
  const _JadwalGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      _JadwalTile(label: 'SPK', icon: Icons.description_outlined),
      _JadwalTile(label: 'Jadwal', icon: Icons.calendar_view_month_rounded),
      _JadwalTile(label: 'Pekerja', icon: Icons.people_outline_rounded),
    ];

    final itemW = (MediaQuery.of(context).size.width - 18 * 2 - 12 * 2) / 3;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((item) {
        return SizedBox(
          width: itemW,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _navigate(context, item.label),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).appColors.card,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _kSoft2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, size: 22, color: kPurple),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF393333),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _navigate(BuildContext context, String label) {
    switch (label) {
      case 'SPK':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const WorkOrderScreen()));
        break;
      case 'Jadwal':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const UnifiedScheduleScreen()));
        break;
      case 'Pekerja':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const WorkerListScreen()));
        break;
    }
  }
}

class _JadwalTile {
  final String label;
  final IconData icon;
  const _JadwalTile({required this.label, required this.icon});
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).appColors.muted,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
