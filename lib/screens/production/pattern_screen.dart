// pola.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const kPurple = Color(0xFF6B257F);

class PatternScreen extends StatefulWidget {
  const PatternScreen({super.key});

  @override
  State<PatternScreen> createState() => _PatternScreenState();
}

class _PatternScreenState extends State<PatternScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== tombol plus (+) =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        onPressed: () => _openCreatePolaSheet(context),
        child: const Icon(Icons.add, size: 26),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const _TopHeader(title: 'Pola'),
            const SizedBox(height: 12),

            Expanded(
              child: Center(
                child: Text(
                  'Belum ada pola.\nKlik tombol + untuk buat pola.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.55),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCreatePolaSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreatePolaSheet(),
    );
  }
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
            onTap: () => context.pop(),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF121111),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          _CircleIcon(
            icon: Icons.home_filled,
            iconColor: kPurple,
            onTap: () {
              context.go('/home');
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
// ================== BOTTOM SHEET ==================
//
class _CreatePolaSheet extends StatefulWidget {
  const _CreatePolaSheet();

  @override
  State<_CreatePolaSheet> createState() => _CreatePolaSheetState();
}

class _CreatePolaSheetState extends State<_CreatePolaSheet> {
  String? _selectedGaya;
  String? _selectedSize;
  int _qty = 1;

  String _fileName = 'Tidak ada file yang dipilih';

  final List<String> _gayaOptions = ['T - Shirt', 'Hoodie', 'Jacket', 'Kemeja'];

  final List<String> _sizeOptions = [
    '1 Size',
    'S - M - L',
    'XS - S - M - L - XL',
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
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
                // handle
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

                // ===== PREVIEW + DESKRIPSI =====
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: const Center(
                    child: Text(
                      'Preview desain akan tampil di sini.\n'
                      'Silakan unggah gambar terlebih dahulu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6D6D6D),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Unggah Desain Anda',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Klik "Choose File" untuk mengupload gambar product',
                  style: TextStyle(
                    color: Color(0xFF6D6D6D),
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _fileName = 'contoh_file.png';
                        });
                      },
                      child: const Text('Pilih File'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11.5),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const Text(
                  'Gaya',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                _DropdownField(
                  value: _selectedGaya,
                  hint: 'T - Shirt',
                  items: _gayaOptions,
                  onChanged: (v) => setState(() => _selectedGaya = v),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Size Grading',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                _DropdownField(
                  value: _selectedSize,
                  hint: '1 Size',
                  items: _sizeOptions,
                  onChanged: (v) => setState(() => _selectedSize = v),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Jumlah',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                _QtyStepper(
                  value: _qty,
                  onMinus: () => setState(() => _qty = _qty > 1 ? _qty - 1 : 1),
                  onPlus: () => setState(() => _qty++),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kPurple),
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Buat Pola'),
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

//
// ================== COMPONENTS ==================
//
class _DropdownField extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFDFDEDE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _QtyStepper({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFDFDEDE)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onMinus,
            child: const SizedBox(
              width: 40,
              child: Icon(Icons.remove, color: kPurple),
            ),
          ),
          Expanded(child: Center(child: Text('$value'))),
          InkWell(
            onTap: onPlus,
            child: const SizedBox(
              width: 40,
              child: Icon(Icons.add, color: kPurple),
            ),
          ),
        ],
      ),
    );
  }
}
