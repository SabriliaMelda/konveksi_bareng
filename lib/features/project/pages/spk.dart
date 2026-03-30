// spk.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/features/home/pages/home.dart';

const kPurple = Color(0xFF6B257F);

class SpkScreen extends StatefulWidget {
  const SpkScreen({super.key});

  @override
  State<SpkScreen> createState() => _SpkScreenState();
}

class _SpkScreenState extends State<SpkScreen> {
  final TextEditingController _searchC = TextEditingController();
  String _query = '';

  final List<_SpkItem> _items = [
    _SpkItem(
      nomor: 'SPK-001',
      judul: 'Pembuatan Seragam',
      mitra: 'Konveksi A',
      tanggal: '02 Jan 2026',
      status: _SpkStatus.proses,
    ),
    _SpkItem(
      nomor: 'SPK-002',
      judul: 'Jaket Hoodie',
      mitra: 'Konveksi B',
      tanggal: '28 Des 2025',
      status: _SpkStatus.selesai,
    ),
    _SpkItem(
      nomor: 'SPK-003',
      judul: 'Kaos Event',
      mitra: 'Konveksi C',
      tanggal: '25 Des 2025',
      status: _SpkStatus.pending,
    ),
  ];

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((e) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return e.nomor.toLowerCase().contains(q) ||
          e.judul.toLowerCase().contains(q) ||
          e.mitra.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        onPressed: () => _openCreateSpkSheet(context),
        child: const Icon(Icons.add, size: 26),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const _TopHeader(title: 'SPK'),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: _SearchBox(
                controller: _searchC,
                onChanged: (v) => setState(() => _query = v),
                onClear: () {
                  _searchC.clear();
                  setState(() => _query = '');
                },
                hintText: 'Cari SPK (nomor/judul/mitra)...',
              ),
            ),

            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Data SPK tidak ditemukan.',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.55),
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final spk = filtered[i];
                        return _SpkCard(
                          spk: spk,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Buka detail: ${spk.nomor}'),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCreateSpkSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateSpkSheet(),
    );
  }
}

//
// ================== MODEL ==================
//
enum _SpkStatus { pending, proses, selesai }

class _SpkItem {
  final String nomor;
  final String judul;
  final String mitra;
  final String tanggal;
  final _SpkStatus status;

  _SpkItem({
    required this.nomor,
    required this.judul,
    required this.mitra,
    required this.tanggal,
    required this.status,
  });
}

//
// ================== TOP HEADER ==================
//
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
          _CircleIcon(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
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
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: iconColor ?? Colors.black87),
      ),
    );
  }
}

//
// ================== SEARCH BOX ==================
//
class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String hintText;

  const _SearchBox({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF8F9BB3)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF8F9BB3),
                  fontSize: 13,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF111111),
                fontSize: 13,
                fontFamily: 'Plus Jakarta Sans',
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

//
// ================== SPK CARD (bookmark-style) ==================
//
class _SpkCard extends StatelessWidget {
  final _SpkItem spk;
  final VoidCallback onTap;

  const _SpkCard({required this.spk, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = _statusText(spk.status);
    final badge = _statusBadge(spk.status);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF4)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE8ECF4)),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.description_outlined,
                color: kPurple,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${spk.nomor} • ${spk.judul}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${spk.mitra} • ${spk.tanggal}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8F9BB3),
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      badge,
                      const SizedBox(width: 8),
                      Text(
                        status,
                        style: const TextStyle(
                          color: Color(0xFF3C3C3C),
                          fontSize: 12,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF8F9BB3)),
          ],
        ),
      ),
    );
  }

  static String _statusText(_SpkStatus s) {
    switch (s) {
      case _SpkStatus.pending:
        return 'Menunggu';
      case _SpkStatus.proses:
        return 'Diproses';
      case _SpkStatus.selesai:
        return 'Selesai';
    }
  }

  static Widget _statusBadge(_SpkStatus s) {
    Color bg;
    Color fg;

    switch (s) {
      case _SpkStatus.pending:
        bg = const Color(0xFFFFF1E6);
        fg = const Color(0xFFB85C00);
        break;
      case _SpkStatus.proses:
        bg = const Color(0xFFEAF1FF);
        fg = const Color(0xFF2F5FD0);
        break;
      case _SpkStatus.selesai:
        bg = const Color(0xFFE9FFF1);
        fg = const Color(0xFF1D7A3A);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Text(
        _statusText(s),
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

//
// ================== BOTTOM SHEET: CREATE SPK ==================
//
class _CreateSpkSheet extends StatefulWidget {
  const _CreateSpkSheet();

  @override
  State<_CreateSpkSheet> createState() => _CreateSpkSheetState();
}

class _CreateSpkSheetState extends State<_CreateSpkSheet> {
  final _nomorC = TextEditingController();
  final _judulC = TextEditingController();
  final _mitraC = TextEditingController();

  _SpkStatus _status = _SpkStatus.pending;

  @override
  void dispose() {
    _nomorC.dispose();
    _judulC.dispose();
    _mitraC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                const Text(
                  'Buat SPK',
                  style: TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),

                _InputLabel('Nomor SPK'),
                const SizedBox(height: 6),
                _TextFieldBox(controller: _nomorC, hint: 'Contoh: SPK-004'),

                const SizedBox(height: 12),
                _InputLabel('Judul Pekerjaan'),
                const SizedBox(height: 6),
                _TextFieldBox(
                  controller: _judulC,
                  hint: 'Contoh: Pembuatan Kaos',
                ),

                const SizedBox(height: 12),
                _InputLabel('Mitra/ Konveksi'),
                const SizedBox(height: 6),
                _TextFieldBox(controller: _mitraC, hint: 'Contoh: Konveksi A'),

                const SizedBox(height: 12),
                _InputLabel('Status'),
                const SizedBox(height: 6),
                _StatusDropdown(
                  value: _status,
                  onChanged: (v) => setState(() => _status = v),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('SPK berhasil dibuat (placeholder)'),
                        ),
                      );
                    },
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String text;
  const _InputLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontFamily: 'Plus Jakarta Sans',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _TextFieldBox({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDFDEDE)),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF8F9BB3),
            fontSize: 12,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        style: const TextStyle(
          color: Color(0xFF111111),
          fontSize: 12,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  final _SpkStatus value;
  final ValueChanged<_SpkStatus> onChanged;

  const _StatusDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDFDEDE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_SpkStatus>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: const [
            DropdownMenuItem(
              value: _SpkStatus.pending,
              child: Text('Menunggu'),
            ),
            DropdownMenuItem(value: _SpkStatus.proses, child: Text('Diproses')),
            DropdownMenuItem(value: _SpkStatus.selesai, child: Text('Selesai')),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 12,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
