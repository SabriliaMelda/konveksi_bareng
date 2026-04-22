import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/screens/main/chat.dart';
import 'package:konveksi_bareng/screens/marketplace/product_detail_screen.dart';
import 'package:konveksi_bareng/widgets/marketplace_bottom_nav.dart';

const kPurple = Color(0xFF6B257F);

enum _MarketplaceSort { rekomendasi, termurah, termahal, terlaris, rating }

extension on _MarketplaceSort {
  String get label {
    switch (this) {
      case _MarketplaceSort.rekomendasi:
        return 'Rekomendasi';
      case _MarketplaceSort.termurah:
        return 'Termurah';
      case _MarketplaceSort.termahal:
        return 'Termahal';
      case _MarketplaceSort.terlaris:
        return 'Terlaris';
      case _MarketplaceSort.rating:
        return 'Rating';
    }
  }
}

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

class MarketplaceScreen extends StatefulWidget {
  final String? prevRoute;

  const MarketplaceScreen({super.key, this.prevRoute});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchC = TextEditingController();
  final ScrollController _productScrollC = ScrollController();
  final ScrollController _shortcutScrollC = ScrollController();
  final List<GlobalKey> _sectionKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  _MarketplaceSort _sort = _MarketplaceSort.rekomendasi;
  RangeValues _priceRange = const RangeValues(0, 200000);
  double _minRating = 0;
  bool _promoOnly = false;
  bool _showShortcutShadow = false;
  int? _activeShortcutIndex;

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
  void initState() {
    super.initState();
    _productScrollC.addListener(_handleProductScroll);
  }

  void _handleProductScroll() {
    final next = _productScrollC.hasClients && _productScrollC.offset > 2;
    final resolvedActiveIndex = _visibleSectionIndex();
    if (next == _showShortcutShadow &&
        resolvedActiveIndex == _activeShortcutIndex) {
      return;
    }
    setState(() {
      _showShortcutShadow = next;
      _activeShortcutIndex = resolvedActiveIndex;
    });
    if (resolvedActiveIndex != null) {
      _scrollShortcutIntoView(resolvedActiveIndex);
    }
  }

  int? _visibleSectionIndex() {
    if (!_productScrollC.hasClients) return null;

    final position = _productScrollC.position;
    if (position.extentAfter <= 80) {
      return _sectionKeys.length - 1;
    }

    int? activeIndex;
    var closestDistance = double.infinity;
    const triggerY = 260.0;

    for (var i = 0; i < _sectionKeys.length; i++) {
      final sectionContext = _sectionKeys[i].currentContext;
      final sectionObject = sectionContext?.findRenderObject();
      if (sectionObject is! RenderBox || !sectionObject.attached) continue;

      final sectionPosition = sectionObject.localToGlobal(Offset.zero);
      final titleY = sectionPosition.dy + 14;
      final sectionBottom = sectionPosition.dy + sectionObject.size.height;
      final distance = (titleY - triggerY).abs();

      if (titleY >= 120 && titleY <= triggerY + 120 && distance < closestDistance) {
        closestDistance = distance;
        activeIndex = i;
      } else if (titleY < 120 && sectionBottom > triggerY && activeIndex == null) {
        activeIndex = i;
      }
    }

    return activeIndex;
  }

  void _scrollShortcutIntoView(int index) {
    if (!_shortcutScrollC.hasClients) return;

    final target = (index * 78.0 - 78.0).clamp(
      0.0,
      _shortcutScrollC.position.maxScrollExtent,
    );

    _shortcutScrollC.animateTo(
      target,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  void _scrollToSection(int index) {
    setState(() => _activeShortcutIndex = index);
    _scrollShortcutIntoView(index);
    final key = _sectionKeys[index];
    final sectionContext = key.currentContext;
    if (sectionContext == null) return;

    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(widget.prevRoute ?? '/home');
    }
  }

  @override
  void dispose() {
    _productScrollC.removeListener(_handleProductScroll);
    _productScrollC.dispose();
    _shortcutScrollC.dispose();
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchC.text.trim().toLowerCase();
    final filtered = _products.where((p) {
      final matchesQuery = query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          p.store.toLowerCase().contains(query) ||
          (p.promoText?.toLowerCase().contains(query) ?? false);
      final matchesPrice =
          p.price >= _priceRange.start && p.price <= _priceRange.end;
      final matchesRating = p.rating >= _minRating;
      final matchesPromo = !_promoOnly || p.isPromo;

      return matchesQuery && matchesPrice && matchesRating && matchesPromo;
    }).toList()
      ..sort((a, b) {
        switch (_sort) {
          case _MarketplaceSort.rekomendasi:
            return b.rating.compareTo(a.rating);
          case _MarketplaceSort.termurah:
            return a.price.compareTo(b.price);
          case _MarketplaceSort.termahal:
            return b.price.compareTo(a.price);
          case _MarketplaceSort.terlaris:
            return b.sold.compareTo(a.sold);
          case _MarketplaceSort.rating:
            return b.rating.compareTo(a.rating);
        }
      });

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.card,
      bottomNavigationBar: MarketplaceBottomNav(
        activeIndex: 0,
        prevRoute: widget.prevRoute,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4F156C),
                    Color(0xFF7B2AA0),
                    Color(0xFFB261CF),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // ===== TOP NAV: selected address + cart + chat =====
                  Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons.arrow_back_ios_new,
                        iconColor: Colors.white,
                        backgroundColor: Colors.white24,
                        borderColor: Colors.white30,
                        onTap: _handleBack,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Alamat dipilih:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Workshop Konveksi, Jakarta',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _NavIconButton(
                        icon: Icons.shopping_cart_outlined,
                        onTap: () => context.push('/checkout'),
                      ),
                      const SizedBox(width: 2),
                      _NavIconButton(
                        icon: Icons.chat_bubble_outline_rounded,
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                              pageBuilder: (_, __, ___) =>
                                  const ChatScreen(prevRoute: '/marketplace'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // ===== SEARCH =====
                  Row(
                    children: [
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
                        iconColor: Colors.white,
                        backgroundColor: Colors.white24,
                        onTap: _showFilterSheet,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              height: 94,
              padding: const EdgeInsets.only(top: 2, bottom: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).appColors.card,
                boxShadow: _showShortcutShadow
                    ? const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ]
                    : const [],
              ),
              child: ListView(
                controller: _shortcutScrollC,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _MarketplaceShortcut(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Voucher\nSpesial',
                    active: _activeShortcutIndex == 0,
                    onTap: () => _scrollToSection(0),
                  ),
                  _MarketplaceShortcut(
                    icon: Icons.verified_outlined,
                    label: 'Brand\nRekomendasi',
                    active: _activeShortcutIndex == 1,
                    onTap: () => _scrollToSection(1),
                  ),
                  _MarketplaceShortcut(
                    icon: Icons.collections_bookmark_outlined,
                    label: 'Koleksi\nPilihan',
                    active: _activeShortcutIndex == 2,
                    onTap: () => _scrollToSection(2),
                  ),
                  _MarketplaceShortcut(
                    icon: Icons.new_releases_outlined,
                    label: 'Produk\nTerbaru',
                    active: _activeShortcutIndex == 3,
                    onTap: () => _scrollToSection(3),
                  ),
                  _MarketplaceShortcut(
                    icon: Icons.local_offer_outlined,
                    label: 'Pasti\nDiskon',
                    active: _activeShortcutIndex == 4,
                    onTap: () => _scrollToSection(4),
                  ),
                  _MarketplaceShortcut(
                    icon: Icons.flash_on_outlined,
                    label: 'Flash\nSale',
                    active: _activeShortcutIndex == 5,
                    onTap: () => _scrollToSection(5),
                  ),
                  _MarketplaceShortcut(
                    icon: Icons.recommend_outlined,
                    label: 'Produk\nRekomendasi',
                    active: _activeShortcutIndex == 6,
                    onTap: () => _scrollToSection(6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ===== PRODUCT GRID (FIX OVERFLOW) =====
            Expanded(
              child: CustomScrollView(
                controller: _productScrollC,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        // IMPORTANT: bikin cell lebih tinggi supaya tidak overflow
                        childAspectRatio: 0.62,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final p = filtered[i];
                          return _ProductCard(
                            product: p,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                  pageBuilder: (_, __, ___) =>
                                      ProductDetailScreen(
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
                                SnackBar(
                                  content: Text('Wishlist: ${p.title}'),
                                ),
                              );
                            },
                          );
                        },
                        childCount: filtered.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _MarketplaceHomeSections(
                      voucherKey: _sectionKeys[0],
                      brandKey: _sectionKeys[1],
                      collectionKey: _sectionKeys[2],
                      newProductKey: _sectionKeys[3],
                      discountKey: _sectionKeys[4],
                      flashSaleKey: _sectionKeys[5],
                      recommendedKey: _sectionKeys[6],
                      products: _products,
                      onProductTap: (p) {
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

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).appColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        var draftSort = _sort;
        var draftRange = _priceRange;
        var draftRating = _minRating;
        var draftPromoOnly = _promoOnly;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Filter & Sort',
                              style: TextStyle(
                                color: Theme.of(context).appColors.ink,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(999),
                            onTap: () => Navigator.of(sheetContext).pop(),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.close, size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Urutkan',
                        style: TextStyle(
                          color: Theme.of(context).appColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _MarketplaceSort.values.map((sort) {
                          return _FilterOptionChip(
                            text: sort.label,
                            active: draftSort == sort,
                            onTap: () => setSheetState(() => draftSort = sort),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                      _FilterLabelRow(
                        title: 'Rentang Harga',
                        value:
                            '${_rupiah(draftRange.start.round())} - ${_rupiah(draftRange.end.round())}',
                      ),
                      RangeSlider(
                        values: draftRange,
                        min: 0,
                        max: 200000,
                        divisions: 20,
                        activeColor: kPurple,
                        labels: RangeLabels(
                          _rupiah(draftRange.start.round()),
                          _rupiah(draftRange.end.round()),
                        ),
                        onChanged: (value) {
                          setSheetState(() => draftRange = value);
                        },
                      ),
                      const SizedBox(height: 6),
                      _FilterLabelRow(
                        title: 'Rating Minimal',
                        value: draftRating == 0
                            ? 'Semua'
                            : draftRating.toStringAsFixed(1),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: kPurple,
                          thumbColor: kPurple,
                        ),
                        child: Slider(
                          value: draftRating,
                          min: 0,
                          max: 5,
                          divisions: 10,
                          label: draftRating == 0
                              ? 'Semua'
                              : draftRating.toStringAsFixed(1),
                          onChanged: (value) {
                            setSheetState(() => draftRating = value);
                          },
                        ),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        activeThumbColor: kPurple,
                        title: Text(
                          'Promo saja',
                          style: TextStyle(
                            color: Theme.of(context).appColors.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        value: draftPromoOnly,
                        onChanged: (value) {
                          setSheetState(() => draftPromoOnly = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setSheetState(() {
                                  draftSort = _MarketplaceSort.rekomendasi;
                                  draftRange = const RangeValues(0, 200000);
                                  draftRating = 0;
                                  draftPromoOnly = false;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kPurple),
                                minimumSize: const Size.fromHeight(46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  color: kPurple,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _sort = draftSort;
                                  _priceRange = draftRange;
                                  _minRating = draftRating;
                                  _promoOnly = draftPromoOnly;
                                });
                                Navigator.of(sheetContext).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPurple,
                                minimumSize: const Size.fromHeight(46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Terapkan',
                                style: TextStyle(
                                  color: Theme.of(context).appColors.card,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
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
      },
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
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
    this.borderColor,
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
          color: backgroundColor ?? Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: borderColor ?? Theme.of(context).appColors.border),
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

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: SizedBox(
        width: 38,
        height: 44,
        child: Icon(icon, size: 25, color: Colors.white),
      ),
    );
  }
}

class _IconPill extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback onTap;

  const _IconPill({
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    required this.onTap,
  });

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
          color: backgroundColor ?? const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 22,
          color: iconColor ?? Theme.of(context).appColors.ink,
        ),
      ),
    );
  }
}

class _MarketplaceShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _MarketplaceShortcut({
    required this.icon,
    required this.label,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF2F3F5);
    final iconColor = active ? kPurple : const Color(0xFF8B8E95);
    final textColor = active ? kPurple : Theme.of(context).appColors.muted;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        width: 78,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                height: 1.12,
                fontWeight: active ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketplaceHomeSections extends StatelessWidget {
  final GlobalKey voucherKey;
  final GlobalKey brandKey;
  final GlobalKey collectionKey;
  final GlobalKey newProductKey;
  final GlobalKey discountKey;
  final GlobalKey flashSaleKey;
  final GlobalKey recommendedKey;
  final List<_Product> products;
  final ValueChanged<_Product> onProductTap;

  const _MarketplaceHomeSections({
    required this.voucherKey,
    required this.brandKey,
    required this.collectionKey,
    required this.newProductKey,
    required this.discountKey,
    required this.flashSaleKey,
    required this.recommendedKey,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final promoProducts = products.where((p) => p.isPromo).toList();
    final newestProducts = products.reversed.toList();
    final recommendedProducts = [...products]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final bestSellers = [...products]..sort((a, b) => b.sold.compareTo(a.sold));
    final brands = products.map((p) => p.store).toSet().toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Column(
        children: [
          _SectionLeadBanner(),
          _MarketplaceSection(
            key: voucherKey,
            title: 'Voucher Spesial',
            subtitle: 'Voucher aktif untuk belanja di marketplace.',
            icon: Icons.confirmation_number_outlined,
            child: _VoucherRow(),
          ),
          _MarketplaceSection(
            key: brandKey,
            title: 'Brand Rekomendasi',
            subtitle: 'Toko pilihan dengan rating dan penjualan kuat.',
            icon: Icons.verified_outlined,
            child: _BrandRow(brands: brands),
          ),
          _MarketplaceSection(
            key: collectionKey,
            title: 'Koleksi Pilihan',
            subtitle: 'Produk kurasi untuk kebutuhan produksi populer.',
            icon: Icons.collections_bookmark_outlined,
            child: _SectionProductRow(
              products: bestSellers.take(4).toList(),
              onProductTap: onProductTap,
            ),
          ),
          _MarketplaceSection(
            key: newProductKey,
            title: 'Produk Terbaru',
            subtitle: 'Item terbaru yang baru masuk katalog.',
            icon: Icons.new_releases_outlined,
            child: _SectionProductRow(
              products: newestProducts.take(4).toList(),
              onProductTap: onProductTap,
            ),
          ),
          _MarketplaceSection(
            key: discountKey,
            title: 'Pasti Diskon',
            subtitle: 'Produk dengan promo dan benefit belanja.',
            icon: Icons.local_offer_outlined,
            child: _SectionProductRow(
              products: promoProducts,
              onProductTap: onProductTap,
            ),
          ),
          _MarketplaceSection(
            key: flashSaleKey,
            title: 'Flash Sale',
            subtitle: 'Penawaran cepat dengan stok terbatas.',
            icon: Icons.flash_on_outlined,
            child: _SectionProductRow(
              products: promoProducts.reversed.toList(),
              onProductTap: onProductTap,
            ),
          ),
          _MarketplaceSection(
            key: recommendedKey,
            title: 'Produk Rekomendasi',
            subtitle: 'Produk rating tertinggi dari semua kategori.',
            icon: Icons.recommend_outlined,
            child: _SectionProductRow(
              products: recommendedProducts.take(4).toList(),
              onProductTap: onProductTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketplaceSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _MarketplaceSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).appColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4EAF8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: kPurple, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).appColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).appColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SectionLeadBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6B257F),
            Color(0xFF9D4CB8),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kPurple.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilihan Marketplace',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Voucher, brand, dan produk pilihan dalam satu beranda.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
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

class _VoucherRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const vouchers = [
      ('BARENG10', 'Diskon 10%', 'Min. belanja Rp 150.000'),
      ('ONGKIR', 'Gratis Ongkir', 'Area Jabodetabek'),
      ('CASH25', 'Cashback 25K', 'Pembayaran digital'),
    ];

    return SizedBox(
      height: 98,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: vouchers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final voucher = vouchers[index];
          return Container(
            width: 188,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFDF3FF),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8D7F0)),
              boxShadow: [
                BoxShadow(
                  color: kPurple.withValues(alpha: 0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher.$1,
                  style: const TextStyle(
                    color: kPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  voucher.$2,
                  style: TextStyle(
                    color: Theme.of(context).appColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  voucher.$3,
                  style: TextStyle(
                    color: Theme.of(context).appColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  final List<String> brands;

  const _BrandRow({required this.brands});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).appColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Theme.of(context).appColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4EAF8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: kPurple,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    brands[index],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 12,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionProductRow extends StatelessWidget {
  final List<_Product> products;
  final ValueChanged<_Product> onProductTap;

  const _SectionProductRow({
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 176,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onProductTap(product),
            child: Container(
              width: 128,
              decoration: BoxDecoration(
                color: Theme.of(context).appColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Theme.of(context).appColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.16),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 1.35,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                height: 34,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.34),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 7,
                                right: 7,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome_rounded,
                                    color: kPurple,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).appColors.ink,
                            fontSize: 12,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _rupiah(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: kPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${product.rating.toStringAsFixed(1)} • ${product.sold} terjual',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).appColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterOptionChip extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _FilterOptionChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
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

class _FilterLabelRow extends StatelessWidget {
  final String title;
  final String value;

  const _FilterLabelRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).appColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).appColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class MarketplaceNotificationsScreen extends StatelessWidget {
  const MarketplaceNotificationsScreen({super.key});

  static const _items = [
    _MarketplaceNotificationItem(
      title: 'Promo Kaos Oversize Basic',
      subtitle: 'Diskon 20% masih aktif untuk produk pilihan hari ini.',
      time: '5 menit lalu',
      icon: Icons.local_offer_outlined,
      unread: true,
      product: MarketplaceProduct(
        title: 'Kaos Oversize Basic',
        store: 'Konveksi Bareng',
        price: 59000,
        rating: 4.8,
        sold: 1200,
        imageUrl: 'https://picsum.photos/seed/kaos1/400/400',
        isPromo: true,
        promoText: 'Diskon 20%',
      ),
    ),
    _MarketplaceNotificationItem(
      title: 'Pesanan sedang dikemas',
      subtitle: 'Hoodie Premium Fleece sedang diproses oleh Bareng Official.',
      time: '22 menit lalu',
      icon: Icons.inventory_2_outlined,
      unread: true,
      product: MarketplaceProduct(
        title: 'Hoodie Premium Fleece',
        store: 'Bareng Official',
        price: 159000,
        rating: 4.7,
        sold: 780,
        imageUrl: 'https://picsum.photos/seed/hoodie1/400/400',
        isPromo: false,
      ),
    ),
    _MarketplaceNotificationItem(
      title: 'Gratis ongkir tersedia',
      subtitle:
          'Kemeja Oxford punya voucher gratis ongkir untuk pembelian ini.',
      time: '1 jam lalu',
      icon: Icons.local_shipping_outlined,
      unread: false,
      product: MarketplaceProduct(
        title: 'Kemeja Oxford',
        store: 'Konveksi Partner',
        price: 99000,
        rating: 4.6,
        sold: 430,
        imageUrl: 'https://picsum.photos/seed/kemeja1/400/400',
        isPromo: true,
        promoText: 'Gratis Ongkir',
      ),
    ),
    _MarketplaceNotificationItem(
      title: 'Produk favorit tersedia',
      subtitle: 'Topi Baseball kembali tersedia di Bareng Official.',
      time: 'Kemarin',
      icon: Icons.favorite_border,
      unread: false,
      product: MarketplaceProduct(
        title: 'Topi Baseball',
        store: 'Bareng Official',
        price: 39000,
        rating: 4.4,
        sold: 300,
        imageUrl: 'https://picsum.photos/seed/topi1/400/400',
        isPromo: true,
        promoText: 'Best Seller',
      ),
    ),
  ];

  void _openItem(BuildContext context, _MarketplaceNotificationItem item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => ProductDetailScreen(product: item.product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColors.card,
      bottomNavigationBar: const MarketplaceBottomNav(activeIndex: -1),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new,
                    iconColor: Theme.of(context).appColors.ink,
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/marketplace');
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Notifikasi Marketplace',
                      style: TextStyle(
                        color: Theme.of(context).appColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _MarketplaceNotificationTile(
                    item: item,
                    onTap: () => _openItem(context, item),
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

class _MarketplaceNotificationTile extends StatelessWidget {
  final _MarketplaceNotificationItem item;
  final VoidCallback onTap;

  const _MarketplaceNotificationTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: item.unread
                ? const Color(0xFFE3C7F0)
                : Theme.of(context).appColors.border,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.unread
                    ? const Color(0xFFF3E4FF)
                    : Theme.of(context).appColors.iconSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                item.icon,
                color:
                    item.unread ? kPurple : Theme.of(context).appColors.muted,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).appColors.ink,
                            fontSize: 13.5,
                            fontWeight:
                                item.unread ? FontWeight.w900 : FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: TextStyle(
                          color: Theme.of(context).appColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            if (item.unread) ...[
              const SizedBox(width: 10),
              Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: kPurple,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MarketplaceNotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final bool unread;
  final MarketplaceProduct product;

  const _MarketplaceNotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.unread,
    required this.product,
  });
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
