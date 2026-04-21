import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/screens/marketplace/product_detail_screen.dart';
import 'package:konveksi_bareng/widgets/app_bottom_nav.dart';

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
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchC = TextEditingController();

  String _activeCategory = 'Semua';
  _MarketplaceSort _sort = _MarketplaceSort.rekomendasi;
  RangeValues _priceRange = const RangeValues(0, 200000);
  double _minRating = 0;
  bool _promoOnly = false;

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
    final query = _searchC.text.trim().toLowerCase();
    final filtered = _products.where((p) {
      final matchesCategory = _activeCategory == 'Semua' ||
          p.title.toLowerCase().contains(_activeCategory.toLowerCase());
      final matchesQuery = query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          p.store.toLowerCase().contains(query) ||
          (p.promoText?.toLowerCase().contains(query) ?? false);
      final matchesPrice =
          p.price >= _priceRange.start && p.price <= _priceRange.end;
      final matchesRating = p.rating >= _minRating;
      final matchesPromo = !_promoOnly || p.isPromo;

      return matchesCategory &&
          matchesQuery &&
          matchesPrice &&
          matchesRating &&
          matchesPromo;
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
                    onTap: _showFilterSheet,
                  ),
                  const SizedBox(width: 10),
                  _IconPill(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                          pageBuilder: (_, __, ___) =>
                              const _MarketplaceNotificationsScreen(),
                        ),
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
                      Slider(
                        value: draftRating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        activeColor: kPurple,
                        label: draftRating == 0
                            ? 'Semua'
                            : draftRating.toStringAsFixed(1),
                        onChanged: (value) {
                          setSheetState(() => draftRating = value);
                        },
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: kPurple,
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

class _MarketplaceNotificationsScreen extends StatelessWidget {
  const _MarketplaceNotificationsScreen();

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
      subtitle: 'Kemeja Oxford punya voucher gratis ongkir untuk pembelian ini.',
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
      bottomNavigationBar: const AppBottomNav(activeIndex: -1),
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
                    onTap: () => Navigator.of(context).pop(),
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
