// daftar_project.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/pages/home.dart';

const kPurple = Color(0xFF6B257F);

class DaftarProyekScreen extends StatefulWidget {
  const DaftarProyekScreen({super.key});

  @override
  State<DaftarProyekScreen> createState() => _DaftarProyekScreenState();
}

class _DaftarProyekScreenState extends State<DaftarProyekScreen> {
  final _searchC = TextEditingController();
  int _filterIndex = 0;

  // Dummy data project (nanti tinggal ganti dari API/DB)
  final List<_Project> _projects = List.generate(12, (i) {
    final idx = i + 1;
    final statuses = ['On Track', 'Revisi', 'Urgent'];
    final status = statuses[i % statuses.length];

    // pakai 3 gambar sample (ulang-ulang biar aman)
    final images = [
      'assets/images/rucas.jpg',
      'assets/images/nike.jpg',
      'assets/images/adidas.jpg',
    ];

    return _Project(
      id: idx,
      title: 'Project $idx',
      client: 'Client ${(idx % 4) + 1}',
      status: status,
      progress: (0.25 + (i % 4) * 0.18).clamp(0.0, 1.0),
      imagePath: images[i % images.length],
      deadline: '${(i % 9) + 2} hari lagi',

      // ✅ NILAI PROJECT (DUMMY)
      // 15jt + naik 3.5jt tiap index biar variatif
      nilaiProject: 15000000 + (i * 3500000),
    );
  });

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  List<_Project> get _filtered {
    final q = _searchC.text.trim().toLowerCase();
    final base = q.isEmpty
        ? _projects
        : _projects.where((p) => p.title.toLowerCase().contains(q)).toList();

    if (_filterIndex == 0) return base; // Semua
    if (_filterIndex == 1)
      return base.where((p) => p.status == 'On Track').toList();
    if (_filterIndex == 2)
      return base.where((p) => p.status == 'Revisi').toList();
    return base.where((p) => p.status == 'Urgent').toList();
  }

  @override
  Widget build(BuildContext context) {
    final projects = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,

      // FAB tetap
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        onPressed: () {
          // TODO: tambah project
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ========== HEADER BARU (UNGU + SEARCH) ==========
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
              decoration: const BoxDecoration(
                color: kPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // back
                      _HeaderIcon(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Daftar Project',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Encode Sans',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      // home
                      _HeaderIcon(
                        icon: Icons.home_filled,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // search
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF50047D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchC,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Cari project...',
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        if (_searchC.text.isNotEmpty)
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              _searchC.clear();
                              setState(() {});
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // filter chips
                  _FilterChips(
                    currentIndex: _filterIndex,
                    onChange: (i) => setState(() => _filterIndex = i),
                  ),
                ],
              ),
            ),

            // ========== BODY GRID ==========
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                child: GridView.builder(
                  itemCount: projects.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 kolom agar card lebih lebar & enak
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.88,
                  ),
                  itemBuilder: (context, index) {
                    final p = projects[index];
                    return _ProjectCard(project: p);
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

// ================== FILTER CHIPS ==================
class _FilterChips extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChange;
  const _FilterChips({required this.currentIndex, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final items = ['Semua', 'On Track', 'Revisi', 'Urgent'];

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = i == currentIndex;
          return InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onChange(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.white.withOpacity(0.14),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Colors.white.withOpacity(active ? 0.0 : 0.18),
                ),
              ),
              child: Text(
                items[i],
                style: TextStyle(
                  color: active ? kPurple : Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  fontFamily: 'Work Sans',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================== HEADER ICON BUTTON ==================
class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ================== PROJECT CARD (DENGAN GAMBAR + NILAI PROJECT) ==================
class _ProjectCard extends StatelessWidget {
  final _Project project;
  const _ProjectCard({required this.project});

  String _formatRupiah(int v) {
    // format sederhana: 15000000 -> Rp 15.000.000
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final indexFromEnd = s.length - i;
      buf.write(s[i]);
      if (indexFromEnd > 1 && indexFromEnd % 3 == 1) buf.write('.');
    }
    return 'Rp $buf';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(project.status);
    final progressPercent = (project.progress * 100).round();

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        // TODO: buka detail project
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
          border: Border.all(color: const Color(0x0FE8ECF4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== thumbnail image
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

                  // overlay gradient biar teks kebaca
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.45),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // status badge
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        project.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Work Sans',
                        ),
                      ),
                    ),
                  ),

                  // progress badge
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$progressPercent%',
                        style: const TextStyle(
                          color: kPurple,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Work Sans',
                        ),
                      ),
                    ),
                  ),

                  // title di bawah gambar
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
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Encode Sans',
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== info bawah
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.client,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Work Sans',
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ✅ NILAI PROJECT
                  Text(
                    _formatRupiah(project.nilaiProject),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Work Sans',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // progress bar
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E4FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: project.progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: LinearGradient(
                            colors: [
                              statusColor,
                              statusColor.withOpacity(0.65),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // deadline row
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          project.deadline,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Work Sans',
                          ),
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7E1FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: kPurple,
                          size: 18,
                        ),
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
}

// ================== MODEL DUMMY ==================
class _Project {
  final int id;
  final String title;
  final String client;
  final String status;
  final double progress;
  final String imagePath;
  final String deadline;

  // ✅ NILAI PROJECT
  final int nilaiProject;

  _Project({
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
