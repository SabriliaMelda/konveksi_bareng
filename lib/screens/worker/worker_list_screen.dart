import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/widgets/app_bottom_nav.dart';

const kPurple = Color(0xFF6B257F);
const _kSoft = Color(0xFFF3E4FF);

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

class WorkerItem {
  String nama;
  String role;
  String phone;
  String address;
  String notes;
  String? avatarAsset;
  List<String> projects;
  bool isBookmark;

  WorkerItem({
    required this.nama,
    required this.role,
    this.phone = '',
    this.address = '',
    this.notes = '',
    this.avatarAsset,
    List<String>? projects,
    this.isBookmark = false,
  }) : projects = projects ?? [];
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({super.key});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  final TextEditingController _searchC = TextEditingController();
  String _query = '';

  final List<WorkerItem> _items = [
    WorkerItem(
      nama: 'Santy',
      role: 'Pekerja Jahit',
      phone: '081234567890',
      address: 'Jl. Mawar No. 5, Bandung',
      notes: 'Spesialis blouse & kemeja.',
      avatarAsset: 'assets/images/pekerja/santy.jpg',
      projects: ['Project C', 'Project D', 'Project E'],
      isBookmark: false,
    ),
    WorkerItem(
      nama: 'Pekerja 2',
      role: 'Pekerja Obras',
      phone: '089876543210',
      address: 'Jl. Melati No. 12, Bandung',
      notes: '',
      avatarAsset: 'assets/images/pekerja/pekerja2.jpg',
      projects: ['Project A', 'Project B'],
      isBookmark: true,
    ),
  ];

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  List<WorkerItem> get _filtered {
    if (_query.trim().isEmpty) return _items;
    final q = _query.toLowerCase();
    return _items
        .where((e) =>
            e.nama.toLowerCase().contains(q) ||
            e.role.toLowerCase().contains(q))
        .toList();
  }

  // ── Add / Edit sheet ──────────────────────────────────────────────────────

  void _openAddSheet({WorkerItem? editing}) {
    final namaC = TextEditingController(text: editing?.nama ?? '');
    final roleC = TextEditingController(text: editing?.role ?? '');
    final phoneC = TextEditingController(text: editing?.phone ?? '');
    final addressC = TextEditingController(text: editing?.address ?? '');
    final notesC = TextEditingController(text: editing?.notes ?? '');
    bool bookmark = editing?.isBookmark ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).appColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        final inset = MediaQuery.of(sheetCtx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(18, 14, 18, 18 + inset),
          child: StatefulBuilder(
            builder: (ctx, setLocal) => SingleChildScrollView(
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
                  Text(
                    editing == null ? 'Tambah Pekerja' : 'Edit Pekerja',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _Field(
                      controller: namaC, label: 'Nama', hint: 'Nama lengkap'),
                  const SizedBox(height: 12),
                  _Field(
                      controller: roleC,
                      label: 'Peran / Keahlian',
                      hint: 'Contoh: Pekerja Jahit'),
                  const SizedBox(height: 12),
                  _Field(
                    controller: phoneC,
                    label: 'No. Telepon',
                    hint: '08xxxxxxxxxx',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                      controller: addressC,
                      label: 'Alamat',
                      hint: 'Alamat lengkap'),
                  const SizedBox(height: 12),
                  _Field(
                    controller: notesC,
                    label: 'Catatan',
                    hint: 'Keahlian khusus, catatan lain...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 14),

                  // bookmark toggle
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => setLocal(() => bookmark = !bookmark),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: bookmark ? kPurple : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color:
                                  bookmark ? kPurple : const Color(0xFFD1D5DB),
                              width: 1.5,
                            ),
                          ),
                          child: bookmark
                              ? const Icon(Icons.check,
                                  size: 14, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Tandai sebagai bookmark',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetCtx),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD1D5DB)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(color: Color(0xFF374151)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final nama = namaC.text.trim();
                            final role = roleC.text.trim();
                            if (nama.isEmpty || role.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Nama dan peran wajib diisi.'),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              if (editing == null) {
                                _items.add(WorkerItem(
                                  nama: nama,
                                  role: role,
                                  phone: phoneC.text.trim(),
                                  address: addressC.text.trim(),
                                  notes: notesC.text.trim(),
                                  isBookmark: bookmark,
                                ));
                              } else {
                                editing.nama = nama;
                                editing.role = role;
                                editing.phone = phoneC.text.trim();
                                editing.address = addressC.text.trim();
                                editing.notes = notesC.text.trim();
                                editing.isBookmark = bookmark;
                              }
                            });
                            Navigator.pop(sheetCtx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: Text(editing == null ? 'Simpan' : 'Update'),
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

  // ── Delete confirm ────────────────────────────────────────────────────────

  void _confirmDelete(WorkerItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus pekerja?'),
        content: Text('${item.nama} akan dihapus dari daftar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _items.remove(item));
              Navigator.pop(context);
            },
            child:
                const Text('Hapus', style: TextStyle(color: Color(0xFFDC2626))),
          ),
        ],
      ),
    );
  }

  // ── Open detail ───────────────────────────────────────────────────────────

  void _openDetail(WorkerItem p) {
    context.push('/worker-detail', extra: {
      'nama': p.nama,
      'role': p.role,
      'avatarAsset': p.avatarAsset,
      'projects': p.projects,
      'phone': p.phone,
      'address': p.address,
      'notes': p.notes,
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final normal = filtered.where((e) => !e.isBookmark).toList();
    final bookmarked = filtered.where((e) => e.isBookmark).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.card,
      bottomNavigationBar: AppBottomNav(activeIndex: -1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        foregroundColor: Colors.white,
        onPressed: () => _openAddSheet(),
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _TopHeader(title: 'Daftar Pekerja'),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: _SearchBox(
                controller: _searchC,
                onChanged: (v) => setState(() => _query = v),
                onClear: () {
                  _searchC.clear();
                  setState(() => _query = '');
                },
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada pekerja.',
                        style: TextStyle(
                          color: Theme.of(context).appColors.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 90),
                      children: [
                        ...normal.map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _PekerjaTile(
                              item: p,
                              onTap: () => _openDetail(p),
                              onEdit: () => _openAddSheet(editing: p),
                              onDelete: () => _confirmDelete(p),
                              onBookmarkToggle: () =>
                                  setState(() => p.isBookmark = !p.isBookmark),
                            ),
                          ),
                        ),
                        if (bookmarked.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const _SectionLabel(text: '★ Bookmark'),
                          const SizedBox(height: 10),
                          ...bookmarked.map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _PekerjaTile(
                                item: p,
                                onTap: () => _openDetail(p),
                                onEdit: () => _openAddSheet(editing: p),
                                onDelete: () => _confirmDelete(p),
                                onBookmarkToggle: () => setState(
                                    () => p.isBookmark = !p.isBookmark),
                              ),
                            ),
                          ),
                        ],
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
// TILE
// ─────────────────────────────────────────────────────────────────────────────

class _PekerjaTile extends StatelessWidget {
  final WorkerItem item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onBookmarkToggle;

  const _PekerjaTile({
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).appColors.border),
        ),
        child: Row(
          children: [
            _Avatar(asset: item.avatarAsset, name: item.nama),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${item.role} • ${item.projects.length} proyek',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8F9BB3),
                      fontSize: 12,
                    ),
                  ),
                  if (item.phone.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.phone,
                      style: const TextStyle(
                        color: Color(0xFF8F9BB3),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // action menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert,
                  size: 20, color: Color(0xFF8F9BB3)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
                if (v == 'bookmark') onBookmarkToggle();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    const Icon(Icons.edit_outlined, size: 18, color: kPurple),
                    const SizedBox(width: 10),
                    const Text('Edit'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'bookmark',
                  child: Row(children: [
                    Icon(
                      item.isBookmark ? Icons.star : Icons.star_border,
                      size: 18,
                      color: kPurple,
                    ),
                    const SizedBox(width: 10),
                    Text(item.isBookmark ? 'Hapus bookmark' : 'Bookmark'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    const Icon(Icons.delete_outline,
                        size: 18, color: Color(0xFFDC2626)),
                    const SizedBox(width: 10),
                    const Text('Hapus',
                        style: TextStyle(color: Color(0xFFDC2626))),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FORM FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final int maxLines;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 13),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              borderSide: const BorderSide(color: kPurple, width: 1.5),
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _TopHeader extends StatelessWidget {
  final String title;
  const _TopHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIcon(icon: Icons.arrow_back, onTap: () => context.pop()),
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
            onTap: () => context.go('/home'),
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

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBox({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).appColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF8F9BB3)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari pekerja...',
                hintStyle: TextStyle(color: Color(0xFF8F9BB3), fontSize: 14),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close, size: 18, color: Color(0xFF8F9BB3)),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).appColors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? asset;
  final String name;
  const _Avatar({required this.asset, required this.name});

  @override
  Widget build(BuildContext context) {
    if (asset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          asset!,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _kSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'P',
        style: const TextStyle(
          color: kPurple,
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
      ),
    );
  }
}
