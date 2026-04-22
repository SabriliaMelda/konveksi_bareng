// home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/providers/session_guard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _sessionGuard = SessionGuard();
  final TextEditingController _searchC = TextEditingController();

  String _query = '';

  @override
  void initState() {
    super.initState();
    _sessionGuard.start(
      onExpired: () {
        if (mounted) {
          context.go('/welcome');
        }
      },
    );
  }

  @override
  void dispose() {
    _sessionGuard.stop();
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColors.card,

      // ✅ SIDEBAR (DRAWER)
      drawer: _AppSidebar(),

      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER (TETAP DI ATAS) =====
            _HeaderSection(
              controller: _searchC,
              onChanged: (value) => setState(() => _query = value),
              onClear: () {
                _searchC.clear();
                setState(() => _query = '');
              },
            ),

            // ===== BODY YANG SCROLL =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16, top: 16),
                child: _query.trim().isEmpty
                    ? const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PromoSection(),
                          SizedBox(height: 16),
                          _MenuGrid(),
                          SizedBox(height: 16),
                          _FeatureGrid(),
                          SizedBox(height: 16),
                          _FlashDealSection(),
                        ],
                      )
                    : _HomeSearchResults(query: _query),
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
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _HeaderSection({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF6B257F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                  child:
                      Icon(Icons.menu, color: Theme.of(context).appColors.card),
                ),
              ),

              Text(
                'Konveksi Bareng',
                style: TextStyle(
                  color: Theme.of(context).appColors.card,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // ==== CART -> NAVIGATE KE CHECKOUT ====
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  context.push('/checkout');
                },
                child: Stack(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: Theme.of(context).appColors.card,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Color(0xFFEB6383),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '2',
                          style: TextStyle(
                              fontSize: 9,
                              color: Theme.of(context).appColors.card),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Search box
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFF50047D),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.search,
                    color: Theme.of(context).appColors.card, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    cursorColor: Theme.of(context).appColors.card,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      color: Theme.of(context).appColors.card,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                if (controller.text.isNotEmpty)
                  InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: onClear,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).appColors.card,
                        size: 18,
                      ),
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

class _HomeSearchResults extends StatelessWidget {
  final String query;

  const _HomeSearchResults({required this.query});

  static const List<_HomeSearchItem> _items = [
    _HomeSearchItem(
      title: 'Jadwal',
      subtitle: 'Lihat jadwal produksi dan belanja',
      keywords: 'jadwal schedule produksi belanja',
      icon: Icons.calendar_today,
      route: '/schedule',
    ),
    _HomeSearchItem(
      title: 'Pekerja',
      subtitle: 'Kelola data pekerja',
      keywords: 'pekerja worker karyawan tim',
      icon: Icons.group,
      route: '/worker',
    ),
    _HomeSearchItem(
      title: 'Upah',
      subtitle: 'Tagihan dan jadwal upah',
      keywords: 'upah gaji wage pembayaran pekerja',
      icon: Icons.attach_money,
      route: '/wage',
    ),
    _HomeSearchItem(
      title: 'Rugi Laba',
      subtitle: 'Laporan profit dan loss',
      keywords: 'rugi laba profit loss laporan',
      icon: Icons.bar_chart,
      route: '/profit-loss',
    ),
    _HomeSearchItem(
      title: 'Pola',
      subtitle: 'Pola dan desain produksi',
      keywords: 'pola pattern desain',
      icon: Icons.design_services,
      route: '/pattern',
    ),
    _HomeSearchItem(
      title: 'Beli',
      subtitle: 'Pembelian bahan dan kebutuhan produksi',
      keywords: 'beli purchase pembelian belanja',
      icon: Icons.shopping_bag_outlined,
      route: '/purchase',
    ),
    _HomeSearchItem(
      title: 'Promosi',
      subtitle: 'Kelola promo dan campaign',
      keywords: 'promosi promotion promo campaign',
      icon: Icons.campaign_outlined,
      route: '/promotion',
    ),
    _HomeSearchItem(
      title: 'Wishlist',
      subtitle: 'Item favorit tersimpan',
      keywords: 'wishlist favorit favorite simpan',
      icon: Icons.favorite_border,
      route: '/wishlist',
    ),
    _HomeSearchItem(
      title: 'Chat',
      subtitle: 'Komunikasi internal',
      keywords: 'chat pesan message komunitas',
      icon: Icons.chat_bubble_outline,
      route: '/chat?prev=/home',
      useGo: true,
    ),
    _HomeSearchItem(
      title: 'Kelola Proyek',
      subtitle: 'Manajemen order dan pekerjaan',
      keywords: 'kelola proyek project order pekerjaan',
      icon: Icons.assignment,
      route: '/manage-project',
    ),
    _HomeSearchItem(
      title: 'Bahan Baku',
      subtitle: 'Stok, supplier, dan pemakaian',
      keywords: 'bahan baku raw material stok supplier inventory',
      icon: Icons.inventory_2,
      route: '/raw-material',
    ),
    _HomeSearchItem(
      title: 'Keuangan',
      subtitle: 'Cashflow dan pencatatan',
      keywords: 'keuangan finance cashflow uang pencatatan',
      icon: Icons.account_balance_wallet_outlined,
      route: '/finance',
    ),
    _HomeSearchItem(
      title: 'Marketplace',
      subtitle: 'Cari produk dan toko',
      keywords: 'marketplace produk toko kaos hoodie flash deal',
      icon: Icons.storefront_outlined,
      route: '/marketplace',
    ),
    _HomeSearchItem(
      title: 'Sportswear Club',
      subtitle: 'Nike Sports T-Shirt',
      keywords: 'sportswear club nike sports tshirt flash deal',
      icon: Icons.local_offer_outlined,
      route: '/marketplace',
    ),
    _HomeSearchItem(
      title: 'Originals Trefoil',
      subtitle: 'Adidas Sports T-Shirt',
      keywords: 'originals trefoil adidas sports tshirt flash deal',
      icon: Icons.local_offer_outlined,
      route: '/marketplace',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final results = _items.where((item) {
      return item.title.toLowerCase().contains(normalized) ||
          item.subtitle.toLowerCase().contains(normalized) ||
          item.keywords.toLowerCase().contains(normalized);
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hasil pencarian',
            style: TextStyle(
              color: Theme.of(context).appColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          if (results.isEmpty)
            _EmptySearch(query: query)
          else
            ...results.map((item) => _SearchResultTile(item: item)),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final _HomeSearchItem item;

  const _SearchResultTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (item.useGo) {
            context.go(item.route);
          } else {
            context.push(item.route);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).appColors.iconSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0x176B257F),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: const Color(0xFF6B257F)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).appColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).appColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  final String query;

  const _EmptySearch({required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.iconSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: Color(0xFF6B257F),
            size: 34,
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak ada hasil untuk "$query"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).appColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSearchItem {
  final String title;
  final String subtitle;
  final String keywords;
  final IconData icon;
  final String route;
  final bool useGo;

  const _HomeSearchItem({
    required this.title,
    required this.subtitle,
    required this.keywords,
    required this.icon,
    required this.route,
    this.useGo = false,
  });
}

//
// ================== PROMO SECTION (CARD SIMPLE) ==================
//
class _PromoSection extends StatefulWidget {
  const _PromoSection();

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
            height: 170,
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
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Theme.of(context).appColors.ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF7A7E86),
                          fontSize: 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 3,
        crossAxisSpacing: 0,
        childAspectRatio: 50 / 62,
        children: items.map((e) {
          final label = e.$1;
          final icon = e.$2;

          VoidCallback? onTap;

          if (label == 'Jadwal') {
            onTap = () {
              context.push('/schedule');
            };
          } else if (label == 'Pola') {
            onTap = () {
              context.push('/pattern');
            };
          } else if (label == 'Pekerja') {
            onTap = () {
              context.push('/worker');
            };
          } else if (label == 'Chat') {
            onTap = () {
              context.go('/chat?prev=/home');
            };
          } else if (label == 'Beli') {
            onTap = () {
              context.push('/purchase');
            };
          } else if (label == 'Promosi') {
            onTap = () {
              context.push('/promotion');
            };
          } else if (label == 'Wishlist') {
            onTap = () {
              context.push('/wishlist');
            };
          } else if (label == 'Rugi Laba') {
            onTap = () {
              context.push('/profit-loss');
            };
          } else if (label == 'Upah') {
            onTap = () {
              context.push('/wage');
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
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fitur',
            style: TextStyle(
              color: Theme.of(context).appColors.ink,
              fontSize: 16,
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
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final item = features[index];
              final title = item.$1;
              final icon = item.$2;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (title == 'Kelola Proyek') {
                    context.push('/manage-project');
                  } else if (title == 'Bahan Baku') {
                    context.push('/raw-material');
                  } else if (title == 'Komunitas') {
                    context.go('/chat?prev=/home');
                  } else if (title == 'Keuangan') {
                    context.push('/finance');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).appColors.iconSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 72, color: Color(0xFF6B257F)),
                      SizedBox(height: 8),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).appColors.ink,
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
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Flash Deal',
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 16,
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
              color: Theme.of(context).appColors.iconSurface,
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
                      color: Theme.of(context).appColors.card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
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
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(
                          color: Theme.of(context).appColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).appColors.ink,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7A7E86),
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                price,
                style: TextStyle(
                  color: Theme.of(context).appColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                oldPrice,
                style: const TextStyle(
                  color: Color(0xFF7A7E86),
                  fontSize: 12,
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
  const _SeeAllCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: Color(0xFF6B257F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward,
                  color: Theme.of(context).appColors.card, size: 28),
              SizedBox(height: 8),
              Text(
                'Lihat Semua',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).appColors.card,
                  fontSize: 12,
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
// ================== SIDEBAR / DRAWER ==================
//
class _AppSidebar extends StatelessWidget {
  const _AppSidebar();

  static const Color _main = Color(0xFF6B257F);
  static const Color _mainDark = Color(0xFF50047D);
  static const Color _bg = Color(0xFFF7F5F1);
  static const Color _text = Color(0xFF111827);
  static const Color _muted = Color(0xFF6B7280);

  void _go(BuildContext context, String route) {
    context.pop(); // tutup drawer
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Theme.of(context).appColors.card,
      child: SafeArea(
        child: Column(
          children: [
            // ===== HEADER (GRADIENT + PROFIL) =====
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 18, 16, 16),
              decoration: BoxDecoration(
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
                      color: Theme.of(context)
                          .appColors
                          .card
                          .withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: Theme.of(context)
                              .appColors
                              .card
                              .withValues(alpha: 0.25)),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).appColors.card,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 12),

                  // nama + role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Pengguna',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).appColors.card,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .appColors
                                    .card
                                    .withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .appColors
                                      .card
                                      .withValues(alpha: 0.25),
                                ),
                              ),
                              child: Text(
                                'Owner Konveksi',
                                style: TextStyle(
                                  color: Theme.of(context).appColors.card,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.verified,
                              color: Theme.of(context).appColors.card,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // close
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close_rounded,
                        color: Theme.of(context).appColors.card),
                  ),
                ],
              ),
            ),

            // ===== BODY =====
            Expanded(
              child: Container(
                color: Theme.of(context).appColors.card,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  children: [
                    _sectionLabel('UTAMA'),

                    _navTile(
                      context,
                      icon: Icons.assignment_rounded,
                      label: 'Kelola Proyek',
                      subtitle: 'Manajemen order & pekerjaan',
                      onTap: () => _go(context, '/manage-project'),
                    ),
                    _navTile(
                      context,
                      icon: Icons.inventory_2_rounded,
                      label: 'Bahan Baku',
                      subtitle: 'Stok, supplier, pemakaian',
                      onTap: () => _go(context, '/raw-material'),
                    ),
                    _navTile(
                      context,
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Keuangan',
                      subtitle: 'Cashflow & pencatatan',
                      onTap: () => _go(context, '/finance'),
                    ),
                    _navTile(
                      context,
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'Chat',
                      subtitle: 'Komunikasi internal',
                      onTap: () => _go(context, '/chat'),
                    ),
                    _navTile(
                      context,
                      icon: Icons.favorite_border_rounded,
                      label: 'Wishlist',
                      subtitle: 'Simpan item favorit',
                      onTap: () => _go(context, '/wishlist'),
                    ),

                    const SizedBox(height: 14),
                    _dividerPill(context),
                    const SizedBox(height: 14),

                    _sectionLabel('AKUN'),

                    _navTile(
                      context,
                      icon: Icons.person_outline_rounded,
                      label: 'Profile',
                      subtitle: 'Data akun & bisnis',
                      onTap: () => _go(context, '/profile'),
                    ),
                    _navTile(
                      context,
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      subtitle: 'Preferensi aplikasi',
                      onTap: () => _go(context, '/settings'),
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
                        children: [
                          Icon(Icons.lightbulb_outline, color: _main),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Tips: rapikan alur produksi di Kelola Proyek untuk hasil lebih cepat.',
                              style: TextStyle(
                                color: _muted,
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
                      context,
                      label: 'Logout',
                      icon: Icons.logout_rounded,
                      onTap: () {
                        context.pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _primaryButton(
                      context,
                      label: 'Upgrade',
                      icon: Icons.workspace_premium_rounded,
                      onTap: () {
                        context.pop();
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
      padding: EdgeInsets.only(left: 6, bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          color: _muted,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _dividerPill(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.border,
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
      padding: EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
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
                  color: Theme.of(context).appColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Theme.of(context).appColors.border),
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
                      style: TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: _muted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryButton(
    BuildContext context, {
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
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _main,
          foregroundColor: Theme.of(context).appColors.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _ghostButton(
    BuildContext context, {
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
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: _main,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFFE8ECF4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Theme.of(context).appColors.card,
        ),
      ),
    );
  }
}
