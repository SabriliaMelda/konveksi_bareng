// lib/pages/bahan_baku.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/finance/payment_screen.dart';
import 'package:konveksi_bareng/screens/finance/sales_screen.dart';
import 'package:konveksi_bareng/screens/main/home.dart';
import 'package:konveksi_bareng/screens/marketplace/marketplace.dart';
import 'package:konveksi_bareng/screens/main/wishlist.dart';
import 'package:konveksi_bareng/screens/main/chat.dart';
import 'package:konveksi_bareng/screens/marketplace/checkout.dart';
import 'package:konveksi_bareng/screens/finance/purchase_screen.dart';
import 'package:konveksi_bareng/screens/inventory/shipment_screen.dart';

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

  static const _categories = [
    'Kain',
    'Benang',
    'Aksesoris',
    'Packaging',
    'Lainnya',
  ];

  String get _category => _categories[_activeCategory];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _QuickMenuGrid(),
                    const SizedBox(height: 18),
                    _CategoryRow(
                      active: _activeCategory,
                      categories: _categories,
                      onChanged: (idx) => setState(() => _activeCategory = idx),
                    ),
                    const SizedBox(height: 18),
                    _RekomendasiSection(category: _category),
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
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
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
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Bahan Baku',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _HeaderIcon(
                icon: Icons.home_filled,
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
          const SizedBox(height: 12),
          _SearchBar(onTap: () {}),
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
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  const _SearchBar({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.white70, size: 20),
            SizedBox(width: 10),
            Text(
              'Cari bahan baku, kain, aksesoris...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== QUICK MENU (GRID 4 KOLOM / 8 ITEM) ==================
class _QuickMenuGrid extends StatelessWidget {
  const _QuickMenuGrid();

  @override
  Widget build(BuildContext context) {
    final items = <_QuickItem>[
      const _QuickItem('Marketplace', Icons.storefront_outlined),
      const _QuickItem('Wishlist', Icons.favorite_border),
      const _QuickItem('Keranjang', Icons.shopping_cart_outlined),
      const _QuickItem('Chat', Icons.chat_bubble_outline),
      const _QuickItem('Pembelian', Icons.local_offer_outlined),
      const _QuickItem('Pengiriman', Icons.local_shipping_outlined),
      const _QuickItem('Penjualan', Icons.point_of_sale_outlined),
      const _QuickItem('Pembayaran', Icons.payment_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Akses Cepat',
          style: TextStyle(
            color: Color(0xFF24252C),
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, i) {
            final it = items[i];
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
        MaterialPageRoute(builder: (_) => const MarketplaceScreen()),
      );
      return;
    }
    if (label == 'Wishlist') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WishlistScreen()),
      );
      return;
    }
    if (label == 'Keranjang') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
      );
      return;
    }
    if (label == 'Chat') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatScreen()),
      );
      return;
    }
    if (label == 'Pembelian') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PurchaseScreen()),
      );
      return;
    }
    if (label == 'Pengiriman') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ShipmentScreen()),
      );
      return;
    }
    if (label == 'Penjualan') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SalesScreen()),
      );
      return;
    }
    if (label == 'Pembayaran') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaymentScreen()),
      );
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
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
                color: const Color(0xFFF3E4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: kPurple, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF24252C),
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
        const Text(
          'Kategori',
          style: TextStyle(
            color: Color(0xFF24252C),
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
  const _RekomendasiSection({required this.category});

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
    final products = _dataByCategory(category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Rekomendasi • $category',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF24252C),
              ),
            ),
            const Spacer(),
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
            AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: Image.asset(product.image, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            product.rating,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF24252C),
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
                        color: Colors.white.withValues(alpha: 0.92),
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
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF121111),
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.price,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF24252C),
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
