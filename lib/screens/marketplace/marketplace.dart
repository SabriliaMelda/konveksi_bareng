import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/screens/marketplace/product_detail_screen.dart';
import 'package:konveksi_bareng/widgets/app_bottom_nav.dart';

const kPurple = Color(0xFF6B257F);

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchC = TextEditingController();

  String _activeCategory = 'Semua';

  final List<String> _categories = const [
    'Semua',
    'Kaos',
    'Hoodie',
    'Kemeja',
    'Jaket',
    'Celana',
    'Topi',
  ];

  final List<_Product> _products = const [
    _Product(
      title: 'Kaos Oversize Basic',
      store: 'Konveksi Bareng',
      price: 59000,
      rating: 4.8,
      sold: 1200,
      imageUrl: 'https://picsum.photos/seed/kaos1/400/400',
      isPromo: true,
      promoText: 'Diskon 20%',
    ),
    _Product(
      title: 'Hoodie Premium Fleece',
      store: 'Bareng Official',
      price: 159000,
      rating: 4.7,
      sold: 780,
      imageUrl: 'https://picsum.photos/seed/hoodie1/400/400',
      isPromo: false,
    ),
    _Product(
      title: 'Kemeja Oxford',
      store: 'Konveksi Partner',
      price: 99000,
      rating: 4.6,
      sold: 430,
      imageUrl: 'https://picsum.photos/seed/kemeja1/400/400',
      isPromo: true,
      promoText: 'Gratis Ongkir',
    ),
    _Product(
      title: 'Jaket Windbreaker',
      store: 'Bareng Wear',
      price: 129000,
      rating: 4.5,
      sold: 520,
      imageUrl: 'https://picsum.photos/seed/jaket1/400/400',
      isPromo: false,
    ),
    _Product(
      title: 'Celana Chino',
      store: 'Konveksi Bareng',
      price: 119000,
      rating: 4.7,
      sold: 610,
      imageUrl: 'https://picsum.photos/seed/celana1/400/400',
      isPromo: false,
    ),
    _Product(
      title: 'Topi Baseball',
      store: 'Bareng Official',
      price: 39000,
      rating: 4.4,
      sold: 300,
      imageUrl: 'https://picsum.photos/seed/topi1/400/400',
      isPromo: true,
      promoText: 'Best Seller',
    ),
  ];

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _products.where((p) {
      if (_activeCategory == 'Semua') return true;
      final cat = _activeCategory.toLowerCase();
      return p.title.toLowerCase().contains(cat);
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.card,
      bottomNavigationBar: AppBottomNav(activeIndex: -1),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),

            // ===== TOP ROW: back + search + filter + notif =====
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new,
                    iconColor: Theme.of(context).appColors.ink,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SearchPill(
                      controller: _searchC,
                      hint: 'Cari produk, toko, kategori...',
                      onChanged: (_) => setState(() {}),
                      onClear: () {
                        _searchC.clear();
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  _IconPill(
                    icon: Icons.tune_rounded,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Filter/Sort (dummy)')),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _IconPill(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifikasi (dummy)')),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 14),

            // ===== TITLE =====
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Marketplace',
                      style: TextStyle(
                        color: Theme.of(context).appColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ===== PROMO BANNER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _PromoBanner(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buka promo (dummy)')),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // ===== CATEGORIES =====
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final c = _categories[i];
                  final active = c == _activeCategory;
                  return _CategoryChip(
                    text: c,
                    active: active,
                    onTap: () => setState(() => _activeCategory = c),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ===== PRODUCT GRID (FIX OVERFLOW) =====
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  // IMPORTANT: bikin cell lebih tinggi supaya tidak overflow
                  childAspectRatio: 0.62,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final p = filtered[i];
                  return _ProductCard(
                    product: p,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                          pageBuilder: (_, __, ___) => ProductDetailScreen(
                            product: MarketplaceProduct(
                              title: p.title,
                              store: p.store,
                              price: p.price,
                              rating: p.rating,
                              sold: p.sold,
                              imageUrl: p.imageUrl,
                              isPromo: p.isPromo,
                              promoText: p.promoText,
                            ),
                          ),
                        ),
                      );
                    },
                    onFav: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Wishlist: ${p.title}')),
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
}

//
// ===================== MODELS =====================
//
class _Product {
  final String title;
  final String store;
  final int price;
  final double rating;
  final int sold;
  final String imageUrl;
  final bool isPromo;
  final String? promoText;

  const _Product({
    required this.title,
    required this.store,
    required this.price,
    required this.rating,
    required this.sold,
    required this.imageUrl,
    required this.isPromo,
    this.promoText,
  });
}

//
// ===================== UI COMPONENTS =====================
//
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).appColors.border),
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchPill({
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
                hintStyle: const TextStyle(
                  color: Color(0xFF010101),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF010101),
                fontSize: 12,
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

class _IconPill extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconPill({required this.icon, required this.onTap});

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
          color: Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 22, color: Theme.of(context).appColors.ink),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _PromoBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 110,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment(0.05, 0.10),
            end: Alignment(1.27, 1.27),
            colors: [Color(0xFF9F82AD), Color(0x3FEBD4F3)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Promo Mingguan',
                    style: TextStyle(
                      color: Theme.of(context).appColors.card,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Diskon sampai 30% + gratis ongkir.\nCek produk pilihan hari ini.',
                    style: TextStyle(
                      color: Theme.of(context).appColors.card,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: Theme.of(context).appColors.card.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.local_offer_outlined,
                color: Theme.of(context).appColors.card,
                size: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? kPurple : const Color(0xFFF6F7F8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? kPurple : const Color(0xFFE8ECF4)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF1E232C),
            fontSize: 12,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _Product product;
  final VoidCallback onTap;
  final VoidCallback onFav;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onFav,
  });

  String _rupiah(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write('.');
    }
    return 'Rp $buf';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).appColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0CB3B3B3),
              blurRadius: 40,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image (turunin sedikit biar aman)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    height: 132,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: onFav,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .appColors
                            .card
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                            color: Theme.of(context).appColors.border),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: kPurple,
                      ),
                    ),
                  ),
                ),
                if (product.isPromo && (product.promoText ?? '').isNotEmpty)
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kPurple,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        product.promoText!,
                        style: TextStyle(
                          color: Theme.of(context).appColors.card,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // content
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    product.store,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _rupiah(product.price),
                    style: TextStyle(
                      color: kPurple,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: Color(0xFFFFC107),
                      ),
                      SizedBox(width: 4),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: Theme.of(context).appColors.ink,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '• ${product.sold} terjual',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).appColors.muted,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
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
}
