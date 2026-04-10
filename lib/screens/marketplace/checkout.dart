import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color kPurple = Color(0xFF6B257F);

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // BG putih
      body: SafeArea(
        child: Column(
          children: [
            const _CheckoutAppBar(),
            const Divider(height: 1, color: Color(0xFFF2F2F2)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // CART LIST
                    _CartItem(
                      imagePath: 'assets/images/adidas.jpg',
                      title: 'Modern light clothes',
                      subtitle: 'Dress modern',
                      price: '\$212.99',
                      quantity: 4,
                      selected: true,
                    ),
                    SizedBox(height: 16),
                    Divider(height: 1, color: Color(0xFFF6F6F6)),
                    SizedBox(height: 16),
                    _CartItem(
                      imagePath: 'assets/images/nike.jpg',
                      title: 'Modern light clothes',
                      subtitle: 'Dress modern',
                      price: '\$162.99',
                      quantity: 1,
                      selected: true,
                    ),
                    SizedBox(height: 24),

                    // ====== SECTION REKOMENDASI / FLASH DEAL ======
                    _RecommendedSection(),
                    SizedBox(height: 24),

                    // ====== SHIPPING & SUMMARY DIPINDAH KE BAWAH ======
                    _ShippingSection(),
                    SizedBox(height: 24),

                    _SummarySection(),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // PAY BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
// ================== APP BAR ==================
//
class _CheckoutAppBar extends StatelessWidget {
  const _CheckoutAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _RoundIconButton(
            icon: Icons.arrow_back,
            onTap: () => context.pop(),
          ),
          const Text(
            'Checkout',
            style: TextStyle(
              color: Color(0xFF121111),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          _RoundIconButton(icon: Icons.more_horiz, onTap: () {}),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _RoundIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFDFDEDE)),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF121111)),
      ),
    );
  }
}

//
// ================== CART ITEM (DENGAN CHECKBOX UNGU) ==================
//
class _CartItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;
  final int quantity;
  final bool selected; // <- status checkbox

  const _CartItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    this.selected = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // CHECKBOX UNGU
        _SelectCheckbox(selected: selected),
        const SizedBox(width: 12),

        // IMAGE
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 70,
            height: 70,
            color: Colors.grey.shade200,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 15),

        // TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF121111),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF787676), fontSize: 10),
              ),
              const SizedBox(height: 12),
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFF292526),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // BUTTON + MORE
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.more_horiz, size: 20),
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _QtyButton(icon: Icons.remove, onTap: () {}),
                const SizedBox(width: 12),
                Text(
                  quantity.toString(),
                  style: const TextStyle(
                    color: Color(0xFF292526),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                _QtyButton(icon: Icons.add, onTap: () {}),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// kotak checkbox ungu di sebelah kiri gambar
class _SelectCheckbox extends StatelessWidget {
  final bool selected;

  const _SelectCheckbox({required this.selected});

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: kPurple,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.check, size: 16, color: Colors.white),
      );
    } else {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFDFDEDE), width: 1.5),
        ),
      );
    }
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFDFDEDE)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF292526)),
      ),
    );
  }
}

//
// =============== RECOMMENDED / FLASH DEAL SECTION =================
//
class _RecommendedSection extends StatelessWidget {
  const _RecommendedSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Flash Deal + timer + See All
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x1FEB6383),
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
                color: kPurple,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _RecommendedProductCard(
                imagePath: 'assets/images/nike.jpg',
                title: 'Sportswear Club',
                subtitle: 'Nike Sports T-Shirt',
                price: '\$54,80',
                oldPrice: '\$60,00',
                rating: 4.8,
              ),
              SizedBox(width: 16),
              _RecommendedProductCard(
                imagePath: 'assets/images/adidas.jpg',
                title: 'Originals Trefoil',
                subtitle: 'Adidas Sports T-Shirt',
                price: '\$69,10',
                oldPrice: '\$76,90',
                rating: 4.8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecommendedProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;
  final String oldPrice;
  final double rating;

  const _RecommendedProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.oldPrice,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image + love + add to cart
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F4F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                ),
                // love icon
                Positioned(
                  right: 10,
                  top: 10,
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
                      color: kPurple,
                    ),
                  ),
                ),
                // rating
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                // add to cart button
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: kPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7A7E86)),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.black,
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

//
// ================== SHIPPING ==================
//
class _ShippingSection extends StatelessWidget {
  const _ShippingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Information',
          style: TextStyle(
            color: Color(0xFF121111),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 55,
                    height: 32,
                    decoration: BoxDecoration(
                      color: kPurple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'VISA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '**** **** **** 2143',
                    style: TextStyle(
                      color: Color(0xFF292526),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF292526)),
            ],
          ),
        ),
      ],
    );
  }
}

//
// ================== SUMMARY ==================
//
class _SummarySection extends StatelessWidget {
  const _SummarySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SummaryRow(label: 'Total (9 items)', value: '\$1,014.95'),
        SizedBox(height: 8),
        _SummaryRow(label: 'Shipping Fee', value: '\$0.00'),
        SizedBox(height: 8),
        _SummaryRow(label: 'Discount', value: '\$0.00'),
        SizedBox(height: 16),
        Divider(color: Color(0xFFF2F2F2)),
        SizedBox(height: 12),
        _SummaryRow(label: 'Sub Total', value: '\$1,014.95', bold: true),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF292526), fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF121111),
            fontSize: 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
