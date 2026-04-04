// home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:konveksi_bareng/screens/finance/pembelian.dart';
import 'package:konveksi_bareng/screens/promotion/promosi.dart';
import 'package:konveksi_bareng/screens/finance/rugi_laba.dart';
import 'package:konveksi_bareng/screens/profile/settings.dart';
import 'package:konveksi_bareng/screens/worker/upah.dart';
import 'package:konveksi_bareng/screens/marketplace/wishlist.dart';
import 'package:konveksi_bareng/screens/marketplace/checkout.dart';

import 'package:konveksi_bareng/screens/profile/profile.dart';
import 'package:konveksi_bareng/screens/project/kelola_proyek.dart';
import 'package:konveksi_bareng/screens/inventory/bahan_baku.dart';
import 'package:konveksi_bareng/screens/chat/chat.dart';
import 'package:konveksi_bareng/screens/finance/keuangan.dart';
import 'package:konveksi_bareng/screens/schedule/jadwal.dart';
import 'package:konveksi_bareng/screens/production/pola.dart';
import 'package:konveksi_bareng/screens/worker/pekerja.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ SIDEBAR (DRAWER)
      drawer: const _AppSidebar(),

      bottomNavigationBar: const _BottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER (TETAP DI ATAS) =====
            const _HeaderSection(),

            // ===== BODY YANG SCROLL =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _PromoSection(),
                    SizedBox(height: 16),
                    _MenuGrid(),
                    SizedBox(height: 16),
                    _FeatureGrid(),
                    SizedBox(height: 16),
                    _FlashDealSection(),
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

//
// ================== HEADER (UNGU + SEARCH) ==================
//
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF6B257F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris atas: menu + judul + cart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ MENU BUTTON BUKA DRAWER
              Builder(
                builder: (context) => InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(Icons.menu, color: Colors.white),
                ),
              ),

              const Text(
                'Konveksi Bareng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),

              // ==== CART -> NAVIGATE KE CHECKOUT ====
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  );
                },
                child: Stack(
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEB6383),
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '2',
                          style: TextStyle(fontSize: 9, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search box
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF50047D),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
// ================== PROMO SECTION (CARD SIMPLE) ==================
//
class _PromoSection extends StatefulWidget {
  const _PromoSection({super.key});

  @override
  State<_PromoSection> createState() => _PromoSectionState();
}

class _PromoSectionState extends State<_PromoSection> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  // daftar promo
  final List<Map<String, String>> promos = [
    {
      'title': "Don't Miss Out!",
      'subtitle': 'Discount up to 50%',
      'image': 'assets/images/rucas.jpg',
    },
    {
      'title': 'New Arrival!',
      'subtitle': 'Jersey tim favoritmu',
      'image': 'assets/images/nike.jpg',
    },
    {
      'title': 'Special Bundle',
      'subtitle': 'Hemat sampai 70%',
      'image': 'assets/images/adidas.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();

    // ===== AUTO SLIDE SETIAP 3 DETIK =====
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      final nextPage = (_currentPage + 1) % promos.length;

      setState(() {
        _currentPage = nextPage;
      });

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // ====== CAROUSEL ======
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _pageController,
              itemCount: promos.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final item = promos[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _PromoCard(
                    title: item['title']!,
                    subtitle: item['subtitle']!,
                    imagePath: item['image']!,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // ====== DOT INDICATOR ======
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(promos.length, (index) {
              final bool active = index == _currentPage;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF6B257F)
                      : const Color(0xFFD4DBE1),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const _PromoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // shadow lembut
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // ===== TEKS KIRI =====
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF7A7E86),
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B257F),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Check Now',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== GAMBAR KANAN =====
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Container(
                color: const Color(0xFFE3E5EA),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// ================== MENU GRID ==================
//
class _MenuGrid extends StatelessWidget {
  const _MenuGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      // ===== BARIS ATAS =====
      ('Jadwal', Icons.calendar_today),
      ('Pekerja', Icons.group),
      ('Upah', Icons.attach_money),
      ('Rugi Laba', Icons.bar_chart),
      ('Pola', Icons.design_services),

      // ===== BARIS BAWAH =====
      ('Beli', Icons.shopping_bag_outlined),
      ('Promosi', Icons.campaign_outlined),
      ('Wishlist', Icons.favorite_border),
      ('Chat', Icons.chat_bubble_outline),
      ('More', Icons.grid_view_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        runSpacing: 16,
        spacing: 16,
        alignment: WrapAlignment.spaceBetween,
        children: items.map((e) {
          final label = e.$1;
          final icon = e.$2;

          VoidCallback? onTap;

          if (label == 'Jadwal') {
            onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const JadwalScreen()),
              );
            };
          } else if (label == 'Pola') {
            onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PolaScreen()),
              );
            };
          } else if (label == 'Pekerja') {
            onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PekerjaScreen()),
              );
            };
          } else if (label == 'Chat') {
            onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              );
            };
          } else if (label == 'Beli') {
            onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PembelianScreen()),
              );
            };
          } else if (label == 'Promosi') {
            onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PromosiScreen()),
              );
            };
          } else if (label == 'Wishlist') {
            onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            };
          } else if (label == 'Rugi Laba') {
            onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RugiLabaScreen()),
              );
            };
          } else if (label == 'Upah') {
            onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UpahScreen()),
              );
            };
          } else if (label == 'More') {
            // Optional: buka drawer saat klik More
            onTap = () => Scaffold.of(context).openDrawer();
          }

          return _MenuItem(
            label: label,
            icon: icon,
            isPrimary: label == 'More',
            onTap: onTap,
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.label,
    required this.icon,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isPrimary ? const Color(0xFF6B257F) : const Color(0xFFF6F4F0);
    final iconColor = isPrimary ? Colors.white : const Color(0xFF6B257F);
    final textColor = isPrimary ? Colors.black : const Color(0xFF7A7E86);

    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: onTap,
      child: SizedBox(
        width: 56,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(36),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ================== FEATURE GRID ==================
//
class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    final features = [
      ('Kelola Proyek', Icons.assignment),
      ('Bahan Baku', Icons.inventory_2),
      ('Komunitas', Icons.groups),
      ('Keuangan', Icons.account_balance_wallet_outlined),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fitur',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final item = features[index];
              final title = item.$1;
              final icon = item.$2;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (title == 'Kelola Proyek') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KelolaProyekScreen(),
                      ),
                    );
                  } else if (title == 'Bahan Baku') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BahanBakuScreen(),
                      ),
                    );
                  } else if (title == 'Komunitas') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    );
                  } else if (title == 'Keuangan') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KeuanganScreen()),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F4F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 90, color: const Color(0xFF6B257F)),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

//
// ================== FLASH DEAL SECTION ==================
//
class _FlashDealSection extends StatelessWidget {
  const _FlashDealSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Flash Deal',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x1EEB6383),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '10:20:35',
                      style: TextStyle(
                        color: Color(0xFFEB6383),
                        fontSize: 12,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFF6B257F),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _ProductCard(
                  title: 'Sportswear Club',
                  subtitle: 'Nike Sports T-Shirt',
                  price: '\$54,80',
                  oldPrice: '\$60,00',
                  imageUrl: 'assets/images/nike.jpg',
                ),
                SizedBox(width: 16),
                _ProductCard(
                  title: 'Originals Trefoil',
                  subtitle: 'Adidas Sports T-Shirt',
                  price: '\$69,10',
                  oldPrice: '\$76,90',
                  imageUrl: 'assets/images/adidas.jpg',
                ),
                SizedBox(width: 16),
                _SeeAllCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String oldPrice;
  final String imageUrl;

  const _ProductCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 152,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F4F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(imageUrl, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: Color(0xFFEB6383),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Row(
                    children: const [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              color: Color(0xFF7A7E86),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                oldPrice,
                style: const TextStyle(
                  color: Color(0xFF7A7E86),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeeAllCard extends StatelessWidget {
  const _SeeAllCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFF6B257F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.arrow_forward, color: Colors.white, size: 28),
              SizedBox(height: 8),
              Text(
                'Lihat Semua',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// ================== BOTTOM NAV ==================
//
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8ECF4))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            label: 'Home',
            icon: Icons.home_filled,
            active: true,
            onTap: () {},
          ),
          _BottomNavItem(
            label: 'Wishlist',
            icon: Icons.favorite_border,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),
          _BottomNavItem(
            label: 'Settings',
            icon: Icons.settings_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          _BottomNavItem(
            label: 'Chat',
            icon: Icons.chat_bubble_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              );
            },
          ),
          _BottomNavItem(
            label: 'Profile',
            icon: Icons.person_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback? onTap;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF6B257F) : const Color(0xFFC9CBCE);
    final fontWeight = active ? FontWeight.w700 : FontWeight.w400;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ================== SIDEBAR / DRAWER ==================
//
class _AppSidebar extends StatelessWidget {
  const _AppSidebar();

  static const Color _main = Color(0xFF6B257F);
  static const Color _mainDark = Color(0xFF50047D);
  static const Color _bg = Color(0xFFF7F5F1);
  static const Color _text = Color(0xFF111827);
  static const Color _muted = Color(0xFF6B7280);

  void _go(BuildContext context, Widget page) {
    Navigator.pop(context); // tutup drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // ===== HEADER (GRADIENT + PROFIL) =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_main, _mainDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // nama + role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Pengguna',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                ),
                              ),
                              child: const Text(
                                'Owner Konveksi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // close
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),

            // ===== BODY =====
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  children: [
                    _sectionLabel('UTAMA'),

                    _navTile(
                      context,
                      icon: Icons.assignment_rounded,
                      label: 'Kelola Proyek',
                      subtitle: 'Manajemen order & pekerjaan',
                      onTap: () => _go(context, const KelolaProyekScreen()),
                    ),
                    _navTile(
                      context,
                      icon: Icons.inventory_2_rounded,
                      label: 'Bahan Baku',
                      subtitle: 'Stok, supplier, pemakaian',
                      onTap: () => _go(context, const BahanBakuScreen()),
                    ),
                    _navTile(
                      context,
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Keuangan',
                      subtitle: 'Cashflow & pencatatan',
                      onTap: () => _go(context, const KeuanganScreen()),
                    ),
                    _navTile(
                      context,
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'Chat',
                      subtitle: 'Komunikasi internal',
                      onTap: () => _go(context, const ChatScreen()),
                    ),
                    _navTile(
                      context,
                      icon: Icons.favorite_border_rounded,
                      label: 'Wishlist',
                      subtitle: 'Simpan item favorit',
                      onTap: () => _go(context, const WishlistScreen()),
                    ),

                    const SizedBox(height: 14),
                    _dividerPill(),
                    const SizedBox(height: 14),

                    _sectionLabel('AKUN'),

                    _navTile(
                      context,
                      icon: Icons.person_outline_rounded,
                      label: 'Profile',
                      subtitle: 'Data akun & bisnis',
                      onTap: () => _go(context, const ProfileScreen()),
                    ),
                    _navTile(
                      context,
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      subtitle: 'Preferensi aplikasi',
                      onTap: () => _go(context, const SettingsScreen()),
                    ),

                    const SizedBox(height: 14),

                    // ===== CTA BAWAH (OPSIONAL) =====
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _bg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.lightbulb_outline, color: _main),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Tips: rapikan alur produksi di Kelola Proyek untuk hasil lebih cepat.',
                              style: TextStyle(
                                color: _muted,
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== FOOTER =====
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: _ghostButton(
                      label: 'Logout',
                      icon: Icons.logout_rounded,
                      onTap: () {
                        // TODO: logout action (kalau sudah ada auth)
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _primaryButton(
                      label: 'Upgrade',
                      icon: Icons.workspace_premium_rounded,
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: arahkan ke halaman upgrade jika ada
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: _muted,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _dividerPill() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECF4),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _navTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8ECF4)),
                ),
                child: Icon(icon, color: _main, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: _text,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _muted,
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _muted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _main,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _ghostButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 44,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: _main),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
            color: _main,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE8ECF4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
