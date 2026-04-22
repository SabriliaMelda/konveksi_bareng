// lib/pages/bahan_baku.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/marketplace/checkout.dart';
import 'package:konveksi_bareng/screens/marketplace/marketplace.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/widgets/app_bottom_nav.dart';

const Color kPurple = Color(0xFF6B257F);
const Color kBg = Color(0xFFF7F7FB);
const Color kSoft = Color(0xFFF6F4F0);

class RawMaterialScreen extends StatefulWidget {
  const RawMaterialScreen({super.key});

  @override
  State<RawMaterialScreen> createState() => _RawMaterialScreenState();
}

class _RawMaterialScreenState extends State<RawMaterialScreen> {
  int _activeCategory = 0;
  final TextEditingController _searchC = TextEditingController();

  static const _categories = [
    'Kain',
    'Benang',
    'Aksesoris',
    'Packaging',
    'Lainnya',
  ];

  String get _category => _categories[_activeCategory];
  String get _query => _searchC.text.trim();

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _query.isNotEmpty;
    return Scaffold(
      backgroundColor: kBg,
      bottomNavigationBar: AppBottomNav(activeIndex: -1),
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              controller: _searchC,
              onChanged: (_) => setState(() {}),
              onClear: () {
                _searchC.clear();
                setState(() {});
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _QuickMenuGrid(query: _query),
                    if (isSearching) ...[
                      const SizedBox(height: 18),
                      Text(
                        'Hasil Pencarian',
                        style: TextStyle(
                          color: Theme.of(context).appColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 18),
                      _CategoryRow(
                        active: _activeCategory,
                        categories: _categories,
                        onChanged: (idx) =>
                            setState(() => _activeCategory = idx),
                      ),
                    ],
                    const SizedBox(height: 18),
                    _RekomendasiSection(
                      category: _category,
                      query: _query,
                    ),
                    const SizedBox(height: 18),
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

// ================== HEADER UNGU + SEARCH ==================
class _Header extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _Header({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: kPurple,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _HeaderIcon(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _isSearching
                    ? _SearchBar(
                        controller: widget.controller,
                        onChanged: widget.onChanged,
                        onClear: () {
                          widget.onClear();
                          setState(() => _isSearching = false);
                        },
                      )
                    : Text(
                        'Bahan Baku',
                        style: TextStyle(
                          color: Theme.of(context).appColors.card,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
              if (!_isSearching) ...[
                const SizedBox(width: 10),
                _HeaderIcon(
                  icon: Icons.search_rounded,
                  onTap: () {
                    setState(() => _isSearching = true);
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

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
          color: Theme.of(context).appColors.card.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Theme.of(context).appColors.card.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Theme.of(context).appColors.card, size: 20),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
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
        color: Theme.of(context).appColors.card.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).appColors.card.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari bahan baku, kain, aksesoris...',
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();

              return InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onClear,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, color: Colors.white70, size: 18),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ================== QUICK MENU (GRID 4 KOLOM / 8 ITEM) ==================
class _QuickMenuGrid extends StatelessWidget {
  final String query;

  const _QuickMenuGrid({required this.query});

  @override
  Widget build(BuildContext context) {
    final items = <_QuickItem>[
      const _QuickItem('Marketplace', Icons.storefront_outlined),
      const _QuickItem('Wishlist', Icons.favorite_border),
      const _QuickItem('Keranjang', Icons.shopping_cart_outlined),
      const _QuickItem('Chat', Icons.chat_bubble_outline),
      const _QuickItem('Pemesanan', Icons.local_offer_outlined),
      const _QuickItem('Pengiriman', Icons.local_shipping_outlined),
      const _QuickItem('Penjualan', Icons.point_of_sale_outlined),
    ];
    final normalizedQuery = query.toLowerCase();
    final filteredItems = normalizedQuery.isEmpty
        ? items
        : items
            .where(
              (item) => item.label.toLowerCase().contains(normalizedQuery),
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akses Cepat',
          style: TextStyle(
            color: Theme.of(context).appColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        if (filteredItems.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).appColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8ECF4)),
            ),
            child: Text(
              'Tidak ada menu akses cepat yang cocok.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).appColors.muted,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 90,
            ),
            itemBuilder: (context, i) {
              final it = filteredItems[i];
              return _QuickCardSmall(
                label: it.label,
                icon: it.icon,
                onTap: () => _goQuick(context, it.label),
              );
            },
          ),
      ],
    );
  }

  void _goQuick(BuildContext context, String label) {
    if (label == 'Marketplace') {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          pageBuilder: (_, __, ___) =>
              MarketplaceScreen(prevRoute: '/raw-material'),
        ),
      );
      return;
    }
    if (label == 'Wishlist') {
      context.go('/wishlist?prev=/raw-material');
      return;
    }
    if (label == 'Keranjang') {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          pageBuilder: (_, __, ___) => CheckoutScreen(),
        ),
      );
      return;
    }
    if (label == 'Chat') {
      context.go('/chat?prev=/raw-material');
      return;
    }
    if (label == 'Pemesanan') {
      context.go('/purchase?prev=/raw-material');
      return;
    }
    if (label == 'Pengiriman') {
      context.go('/shipment?prev=/raw-material');
      return;
    }
    if (label == 'Penjualan') {
      context.go('/sales?prev=/raw-material');
      return;
    }
  }
}

class _QuickItem {
  final String label;
  final IconData icon;
  const _QuickItem(this.label, this.icon);
}

class _QuickCardSmall extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickCardSmall({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(16),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0xFFF3E4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: kPurple, size: 18),
            ),
            SizedBox(height: 8),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).appColors.ink,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== CATEGORY ROW ==================
class _CategoryRow extends StatelessWidget {
  final int active;
  final List<String> categories;
  final ValueChanged<int> onChanged;

  const _CategoryRow({
    required this.active,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: TextStyle(
            color: Theme.of(context).appColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final isActive = index == active;
              return InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onChanged(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? kPurple : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isActive ? kPurple : const Color(0xFFE8ECF4),
                    ),
                    boxShadow: isActive
                        ? const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 10,
                              offset: Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ================== REKOMENDASI (DINAMIS) ==================
class _RekomendasiSection extends StatelessWidget {
  final String category;
  final String query;

  const _RekomendasiSection({
    required this.category,
    required this.query,
  });

  List<_Product> _dataByCategory(String cat) {
    switch (cat) {
      case 'Benang':
        return const [
          _Product(
            title: 'Benang Jahit 20/2',
            subtitle: 'Benang • 1 roll',
            price: 'Rp 18.000',
            rating: '4.8',
            image: 'assets/images/benang_1.jpg',
          ),
          _Product(
            title: 'Benang Obras 150D',
            subtitle: 'Benang • 1 cone',
            price: 'Rp 29.000',
            rating: '4.7',
            image: 'assets/images/benang_2.jpg',
          ),
          _Product(
            title: 'Benang Nylon',
            subtitle: 'Benang • 1 cone',
            price: 'Rp 33.000',
            rating: '4.9',
            image: 'assets/images/benang_3.jpg',
          ),
          _Product(
            title: 'Benang Polyester',
            subtitle: 'Benang • 1 roll',
            price: 'Rp 21.000',
            rating: '4.7',
            image: 'assets/images/benang_4.jpg',
          ),
        ];

      case 'Aksesoris':
        return const [
          _Product(
            title: 'Resleting YKK 20cm',
            subtitle: 'Aksesoris • 1 pcs',
            price: 'Rp 9.500',
            rating: '4.9',
            image: 'assets/images/aksesoris_1.jpg',
          ),
          _Product(
            title: 'Kancing Jeans',
            subtitle: 'Aksesoris • 1 set',
            price: 'Rp 12.000',
            rating: '4.8',
            image: 'assets/images/aksesoris_2.jpg',
          ),
          _Product(
            title: 'Label Woven',
            subtitle: 'Aksesoris • 50 pcs',
            price: 'Rp 45.000',
            rating: '4.7',
            image: 'assets/images/aksesoris_3.jpg',
          ),
          _Product(
            title: 'Tali Serut Hoodie',
            subtitle: 'Aksesoris • 1 meter',
            price: 'Rp 6.500',
            rating: '4.8',
            image: 'assets/images/aksesoris_4.jpg',
          ),
        ];

      case 'Packaging':
        return const [
          _Product(
            title: 'Plastik OPP',
            subtitle: 'Packaging • 50 pcs',
            price: 'Rp 18.000',
            rating: '4.7',
            image: 'assets/images/pack_1.jpg',
          ),
          _Product(
            title: 'Poly Mailer',
            subtitle: 'Packaging • 25 pcs',
            price: 'Rp 22.000',
            rating: '4.8',
            image: 'assets/images/pack_2.jpg',
          ),
          _Product(
            title: 'Box Kardus S',
            subtitle: 'Packaging • 10 pcs',
            price: 'Rp 35.000',
            rating: '4.6',
            image: 'assets/images/pack_3.jpg',
          ),
          _Product(
            title: 'Sticker Label',
            subtitle: 'Packaging • 1 set',
            price: 'Rp 15.000',
            rating: '4.7',
            image: 'assets/images/pack_4.jpg',
          ),
        ];

      case 'Lainnya':
        return const [
          _Product(
            title: 'Jarum Mesin',
            subtitle: 'Tools • 10 pcs',
            price: 'Rp 17.000',
            rating: '4.8',
            image: 'assets/images/tools_1.jpg',
          ),
          _Product(
            title: 'Kapur Jahit',
            subtitle: 'Tools • 1 pcs',
            price: 'Rp 5.000',
            rating: '4.6',
            image: 'assets/images/tools_2.jpg',
          ),
          _Product(
            title: 'Meteran Kain',
            subtitle: 'Tools • 1 pcs',
            price: 'Rp 8.000',
            rating: '4.7',
            image: 'assets/images/tools_3.jpg',
          ),
          _Product(
            title: 'Gunting Kain',
            subtitle: 'Tools • 1 pcs',
            price: 'Rp 45.000',
            rating: '4.9',
            image: 'assets/images/tools_4.jpg',
          ),
        ];

      case 'Kain':
      default:
        return const [
          _Product(
            title: 'Kain Cotton Combed 30s',
            subtitle: 'Kain • 1 meter',
            price: 'Rp 42.000',
            rating: '4.9',
            image: 'assets/images/kain_1.jpg',
          ),
          _Product(
            title: 'Kain Drill Premium',
            subtitle: 'Kain • 1 meter',
            price: 'Rp 55.000',
            rating: '4.8',
            image: 'assets/images/kain_2.jpg',
          ),
          _Product(
            title: 'Kain Baby Terry',
            subtitle: 'Kain • 1 meter',
            price: 'Rp 49.000',
            rating: '4.7',
            image: 'assets/images/kain_3.jpg',
          ),
          _Product(
            title: 'Kain Rib 2x2',
            subtitle: 'Kain • 1 meter',
            price: 'Rp 28.000',
            rating: '4.8',
            image: 'assets/images/kain_4.jpg',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.toLowerCase();
    const allCategories = [
      'Kain',
      'Benang',
      'Aksesoris',
      'Packaging',
      'Lainnya',
    ];
    final products = normalizedQuery.isEmpty
        ? _dataByCategory(category)
        : allCategories
            .expand(_dataByCategory)
            .where(
              (product) =>
                  product.title.toLowerCase().contains(normalizedQuery) ||
                  product.subtitle.toLowerCase().contains(normalizedQuery),
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              normalizedQuery.isEmpty
                  ? 'Rekomendasi $category'
                  : 'Hasil pencarian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).appColors.ink,
              ),
            ),
            const Spacer(),
            if (normalizedQuery.isEmpty)
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Text(
                    'See all',
                    style: TextStyle(
                      color: kPurple,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (products.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).appColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8ECF4)),
            ),
            child: Text(
              'Tidak ada bahan baku yang cocok dengan "$query".',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).appColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              return _ProductCard(product: products[index]);
            },
          ),
      ],
    );
  }
}

class _Product {
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final String image;

  const _Product({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.image,
  });
}

class _ProductCard extends StatelessWidget {
  final _Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
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
            AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE0E0E0),
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: Color(0xFF9E9E9E),
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .appColors
                            .card
                            .withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            product.rating,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).appColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .appColors
                            .card
                            .withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: kPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).appColors.ink,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    product.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).appColors.muted,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.price,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).appColors.ink,
                          ),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E4FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: kPurple,
                          size: 20,
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

