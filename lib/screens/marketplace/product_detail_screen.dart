import 'package:flutter/material.dart';

const _kPurple = Color(0xFF6B257F);
const _kPurpleLight = Color(0xFFF3E4FF);
const _kBg = Color(0xFFF7F7FB);

// ── Public model ─────────────────────────────────────────────────────────────

class MarketplaceProduct {
  final String title;
  final String store;
  final int price;
  final double rating;
  final int sold;
  final String imageUrl;
  final bool isPromo;
  final String? promoText;
  final String? description;
  final List<String> sizes;
  final List<Color> colors;
  final int stock;

  const MarketplaceProduct({
    required this.title,
    required this.store,
    required this.price,
    required this.rating,
    required this.sold,
    required this.imageUrl,
    this.isPromo = false,
    this.promoText,
    this.description,
    this.sizes = const ['S', 'M', 'L', 'XL', 'XXL'],
    this.colors = const [
      Color(0xFF1E232C),
      Color(0xFF6B257F),
      Color(0xFFE53935),
      Color(0xFF1565C0),
      Color(0xFFF9A825),
    ],
    this.stock = 99,
  });
}

// ── Screen ───────────────────────────────────────────────────────────────────

class ProductDetailScreen extends StatefulWidget {
  final MarketplaceProduct product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;
  String? _selectedSize;
  int _selectedColorIdx = 0;
  bool _isFav = false;

  MarketplaceProduct get p => widget.product;

  String _rupiah(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write('.');
    }
    return 'Rp $buf';
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPriceRow(),
                    const _Gap(),
                    _buildStoreRow(),
                    const _Gap(),
                    _buildColorPicker(),
                    const SizedBox(height: 12),
                    _buildSizePicker(),
                    const _Gap(),
                    _buildDescription(),
                    const _Gap(),
                    _buildStats(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: Colors.white,
      leading: _CircleBtn(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.pop(context),
      ),
      actions: [
        _CircleBtn(
          icon: _isFav ? Icons.favorite_rounded : Icons.favorite_border,
          iconColor: _isFav ? Colors.red : const Color(0xFF1E232C),
          onTap: () => setState(() => _isFav = !_isFav),
        ),
        _CircleBtn(
          icon: Icons.share_outlined,
          onTap: () => _snack('Share (dummy)'),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              p.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: _kPurpleLight,
                child: const Icon(Icons.image_not_supported_outlined,
                    size: 60, color: _kPurple),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x66000000)],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
            if (p.isPromo && (p.promoText ?? '').isNotEmpty)
              Positioned(
                left: 16,
                bottom: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _kPurple,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(p.promoText!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_rupiah(p.price),
              style: const TextStyle(
                  color: _kPurple, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(p.title,
              style: const TextStyle(
                  color: Color(0xFF1E232C),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.3)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  size: 18, color: Color(0xFFFFC107)),
              const SizedBox(width: 4),
              Text(p.rating.toStringAsFixed(1),
                  style: const TextStyle(
                      color: Color(0xFF1E232C),
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Text('• ${p.sold} terjual',
                  style: const TextStyle(
                      color: Color(0xFF6A707C),
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: p.stock > 0
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  p.stock > 0 ? 'Stok: ${p.stock}' : 'Habis',
                  style: TextStyle(
                    color: p.stock > 0
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFD32F2F),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _kPurpleLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.storefront_outlined,
                color: _kPurple, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.store,
                    style: const TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                const Text('Toko Resmi • Pengiriman Cepat',
                    style: TextStyle(
                        color: Color(0xFF6A707C),
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _snack('Kunjungi toko (dummy)'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _kPurple,
              side: const BorderSide(color: _kPurple),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              textStyle:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            child: const Text('Kunjungi'),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Warna',
              style: TextStyle(
                  color: Color(0xFF1E232C),
                  fontSize: 14,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(
            children: List.generate(p.colors.length, (i) {
              final sel = i == _selectedColorIdx;
              return GestureDetector(
                onTap: () => setState(() => _selectedColorIdx = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 10),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: p.colors[i],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: sel ? _kPurple : Colors.transparent,
                      width: 2.5,
                    ),
                    boxShadow: sel
                        ? [
                            BoxShadow(
                              color: p.colors[i].withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : null,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSizePicker() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Ukuran',
                  style: TextStyle(
                      color: Color(0xFF1E232C),
                      fontSize: 14,
                      fontWeight: FontWeight.w800)),
              const Spacer(),
              GestureDetector(
                onTap: () => _snack('Panduan ukuran (dummy)'),
                child: const Text('Panduan Ukuran',
                    style: TextStyle(
                        color: _kPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: p.sizes.map((s) {
              final sel = s == _selectedSize;
              return GestureDetector(
                onTap: () => setState(() => _selectedSize = s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 52,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: sel ? _kPurple : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: sel ? _kPurple : const Color(0xFFE8ECF4),
                    ),
                  ),
                  child: Text(s,
                      style: TextStyle(
                          color: sel ? Colors.white : const Color(0xFF1E232C),
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    final desc = p.description ??
        'Produk berkualitas tinggi dari ${p.store}. '
            'Dibuat dengan bahan pilihan yang nyaman dipakai sehari-hari. '
            'Tersedia dalam berbagai ukuran dan warna. '
            'Cocok untuk berbagai kesempatan.';
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Deskripsi Produk',
              style: TextStyle(
                  color: Color(0xFF1E232C),
                  fontSize: 14,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(desc,
              style: const TextStyle(
                  color: Color(0xFF6A707C),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          _StatItem(
              icon: Icons.star_rounded,
              iconColor: const Color(0xFFFFC107),
              label: 'Rating',
              value: p.rating.toStringAsFixed(1)),
          _StatItem(
              icon: Icons.shopping_bag_outlined,
              iconColor: _kPurple,
              label: 'Terjual',
              value: '${p.sold}'),
          _StatItem(
              icon: Icons.inventory_2_outlined,
              iconColor: const Color(0xFF2E7D32),
              label: 'Stok',
              value: '${p.stock}'),
          _StatItem(
              icon: Icons.local_shipping_outlined,
              iconColor: const Color(0xFF1565C0),
              label: 'Kirim',
              value: 'Cepat'),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8ECF4))),
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 20, offset: Offset(0, -6))
        ],
      ),
      child: Row(
        children: [
          // Qty stepper
          Container(
            height: 44,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE8ECF4)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _QtyBtn(
                    icon: Icons.remove,
                    onTap: () {
                      if (_qty > 1) setState(() => _qty--);
                    }),
                SizedBox(
                  width: 36,
                  child: Text('$_qty',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E232C))),
                ),
                _QtyBtn(
                    icon: Icons.add,
                    onTap: () {
                      if (_qty < p.stock) setState(() => _qty++);
                    }),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                if (_selectedSize == null) {
                  _snack('Pilih ukuran terlebih dahulu');
                  return;
                }
                _snack('Ditambahkan ke keranjang (dummy)');
              },
              icon: const Icon(Icons.shopping_cart_outlined, size: 18),
              label: const Text('Keranjang'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _kPurple,
                side: const BorderSide(color: _kPurple),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_selectedSize == null) {
                  _snack('Pilih ukuran terlebih dahulu');
                  return;
                }
                _snack('Beli sekarang (dummy)');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPurple,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              child: const Text('Beli'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small widgets ─────────────────────────────────────────────────────────────

class _Gap extends StatelessWidget {
  const _Gap();
  @override
  Widget build(BuildContext context) => const SizedBox(height: 8);
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                  color: Color(0x18000000), blurRadius: 8, offset: Offset(0, 2))
            ],
          ),
          child:
              Icon(icon, size: 18, color: iconColor ?? const Color(0xFF1E232C)),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  const _StatItem(
      {required this.icon,
      required this.iconColor,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF1E232C),
                  fontSize: 13,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF6A707C),
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: SizedBox(
        width: 38,
        height: 44,
        child: Icon(icon, size: 18, color: _kPurple),
      ),
    );
  }
}
