import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:konveksi_bareng/services/payment_service.dart';
import 'package:konveksi_bareng/widgets/app_bottom_nav.dart';

const Color kPurple = Color(0xFF6B257F);
const Color _kBg = Color(0xFFF7F7FB);

// ── Models ───────────────────────────────────────────────────────────────────

class _CartProduct {
  final String nama;
  final String model;
  final String seller;
  final int harga;
  final String imagePath;
  int qty;
  bool selected;

  _CartProduct({
    required this.nama,
    required this.model,
    required this.seller,
    required this.harga,
    required this.imagePath,
    this.qty = 1,
    this.selected = true,
  });
}

// ── Payment options ───────────────────────────────────────────────────────────

class _PaymentOption {
  final String label;
  final String group;
  final IconData icon;
  final Color color;
  const _PaymentOption(
      {required this.label,
      required this.group,
      required this.icon,
      required this.color});
}

const _paymentOptions = [
  _PaymentOption(
      label: 'Visa',
      group: 'Kartu Kredit',
      icon: Icons.credit_card,
      color: Color(0xFF1A1F71)),
  _PaymentOption(
      label: 'Mastercard',
      group: 'Kartu Kredit',
      icon: Icons.credit_card,
      color: Color(0xFFEB001B)),
  _PaymentOption(
      label: 'GoPay',
      group: 'E-Wallet',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFF00AED6)),
  _PaymentOption(
      label: 'DANA',
      group: 'E-Wallet',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFF118EEA)),
  _PaymentOption(
      label: 'ShopeePay',
      group: 'E-Wallet',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFFEE4D2D)),
  _PaymentOption(
      label: 'QRIS',
      group: 'QRIS',
      icon: Icons.qr_code_2_rounded,
      color: Color(0xFF6B257F)),
  _PaymentOption(
      label: 'Bayar di Tempat',
      group: 'Lainnya',
      icon: Icons.local_shipping_outlined,
      color: Color(0xFF16A34A)),
];

// ── Helper ────────────────────────────────────────────────────────────────────

String _rupiah(int n) {
  final s = n.toString();
  final buf = StringBuffer('Rp ');
  for (int i = 0; i < s.length; i++) {
    final fromEnd = s.length - i;
    buf.write(s[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write('.');
  }
  return buf.toString();
}

// ── Screen ────────────────────────────────────────────────────────────────────

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  _PaymentOption? _selectedPayment;

  final List<_CartProduct> _products = [
    _CartProduct(
      nama: 'Kaos Oversize',
      model: 'Basic Cotton 30s',
      seller: 'Adidas',
      harga: 212000,
      imagePath: 'assets/images/adidas.jpg',
      qty: 4,
    ),
    _CartProduct(
      nama: 'Jaket Windbreaker',
      model: 'Slim Fit Series',
      seller: 'Adidas',
      harga: 389000,
      imagePath: 'assets/images/adidas.jpg',
    ),
    _CartProduct(
      nama: 'Hoodie Fleece',
      model: 'Premium Oversized',
      seller: 'Nike',
      harga: 459000,
      imagePath: 'assets/images/nike.jpg',
      qty: 2,
    ),
    _CartProduct(
      nama: 'Celana Jogger',
      model: 'Dri-FIT Tech',
      seller: 'Nike',
      harga: 325000,
      imagePath: 'assets/images/nike.jpg',
    ),
    _CartProduct(
      nama: 'Kemeja Oxford',
      model: 'Slim Casual',
      seller: 'Rucas',
      harga: 189000,
      imagePath: 'assets/images/rucas.jpg',
    ),
  ];

  List<String> get _sellerList =>
      (_products.map((p) => p.seller).toSet().toList()..sort());

  List<_CartProduct> _bySeller(String seller) =>
      _products.where((p) => p.seller == seller).toList();

  int get _totalHarga =>
      _products.where((p) => p.selected).fold(0, (s, p) => s + p.harga * p.qty);

  int get _totalItems =>
      _products.where((p) => p.selected).fold(0, (s, p) => s + p.qty);

  Future<void> _handlePay() async {
    if (_selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Pilih metode pembayaran terlebih dahulu')));
      return;
    }
    final selectedItems = _products.where((p) => p.selected).toList();
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih minimal 1 produk')));
      return;
    }

    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ProcessingDialog(),
    );

    try {
      final result = await PaymentService.submitOrder(
        paymentMethod: _selectedPayment!.label,
        totalAmount: _totalHarga,
        items: selectedItems
            .map((p) => OrderItem(
                  nama: p.nama,
                  model: p.model,
                  seller: p.seller,
                  harga: p.harga,
                  qty: p.qty,
                ))
            .toList(),
      );

      if (!mounted) return;
      Navigator.pop(context); // close dialog

      // Navigate to purchase/payment status screen
      context.push('/purchase', extra: result);
    } catch (_) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses pembayaran. Coba lagi.')));
    }
  }

  void _showPaymentPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).appColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollController) => _PaymentPickerSheet(
          selected: _selectedPayment,
          scrollController: scrollController,
          onSelect: (opt) {
            setState(() => _selectedPayment = opt);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showCheckoutMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).appColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Opsi Checkout',
                        style: TextStyle(
                          color: Theme.of(context).appColors.ink,
                          fontSize: 16,
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
                const SizedBox(height: 12),
                _CheckoutMenuTile(
                  icon: Icons.select_all_rounded,
                  title: 'Pilih semua',
                  subtitle: 'Centang semua item di keranjang',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    setState(() {
                      for (final product in _products) {
                        product.selected = true;
                      }
                    });
                  },
                ),
                _CheckoutMenuTile(
                  icon: Icons.deselect_rounded,
                  title: 'Batal pilih semua',
                  subtitle: 'Hapus centang semua item',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    setState(() {
                      for (final product in _products) {
                        product.selected = false;
                      }
                    });
                  },
                ),
                _CheckoutMenuTile(
                  icon: Icons.local_offer_outlined,
                  title: 'Voucher',
                  subtitle: 'Cek voucher yang bisa dipakai',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _showVoucherSheet();
                  },
                ),
                _CheckoutMenuTile(
                  icon: Icons.edit_note_outlined,
                  title: 'Catatan pesanan',
                  subtitle: 'Tambahkan catatan untuk seller',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _showOrderNoteSheet();
                  },
                ),
                _CheckoutMenuTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Bantuan checkout',
                  subtitle: 'Lihat informasi pembayaran dan keranjang',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _showCheckoutHelpSheet();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showVoucherSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).appColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _SimpleInfoSheet(
        title: 'Voucher',
        icon: Icons.local_offer_outlined,
        message:
            'Voucher gratis ongkir dan diskon akan otomatis muncul saat tersedia untuk item yang dipilih.',
      ),
    );
  }

  void _showOrderNoteSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).appColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catatan Pesanan',
                  style: TextStyle(
                    color: Theme.of(context).appColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  autofocus: true,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Contoh: warna, ukuran, atau instruksi packing',
                    filled: true,
                    fillColor: _kBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          BorderSide(color: Theme.of(context).appColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          BorderSide(color: Theme.of(context).appColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kPurple),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurple,
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        color: Theme.of(context).appColors.card,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCheckoutHelpSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).appColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _SimpleInfoSheet(
        title: 'Bantuan Checkout',
        icon: Icons.help_outline_rounded,
        message:
            'Pilih minimal satu item dan metode pembayaran sebelum menekan Bayar Sekarang.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      bottomNavigationBar: AppBottomNav(activeIndex: -1),
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(onMoreTap: _showCheckoutMenu),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Products grouped by seller
                    for (final seller in _sellerList) ...[
                      _SellerHeader(name: seller),
                      const SizedBox(height: 8),
                      for (final p in _bySeller(seller)) ...[
                        _CartTile(
                          product: p,
                          onToggle: () =>
                              setState(() => p.selected = !p.selected),
                          onQtyChange: (v) => setState(() => p.qty = v),
                        ),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 6),
                    ],
                    const Divider(color: Color(0xFFEEEEEE)),
                    const Divider(color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    // Payment
                    _PaymentSection(
                        selected: _selectedPayment, onTap: _showPaymentPicker),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    // Summary
                    _SummarySection(
                        totalItems: _totalItems, totalHarga: _totalHarga),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _PayBar(
              total: _totalHarga,
              onPay: _handlePay,
            ),
          ],
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  final VoidCallback onMoreTap;

  const _AppBar({required this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _RoundBtn(
              icon: Icons.arrow_back_ios_new,
              onTap: () => Navigator.pop(context)),
          Expanded(
            child: Text('Checkout',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).appColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ),
          _RoundBtn(icon: Icons.more_horiz, onTap: onMoreTap),
        ],
      ),
    );
  }
}

class _CheckoutMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CheckoutMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: kPurple.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: kPurple, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).appColors.muted,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).appColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleInfoSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;

  const _SimpleInfoSheet({
    required this.title,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: kPurple.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: kPurple, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).appColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
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
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Theme.of(context).appColors.border),
          color: Theme.of(context).appColors.card,
        ),
        child: Icon(icon, size: 18, color: Theme.of(context).appColors.ink),
      ),
    );
  }
}

// ── Seller header ─────────────────────────────────────────────────────────────

class _SellerHeader extends StatelessWidget {
  final String name;
  const _SellerHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
              color: kPurple, borderRadius: BorderRadius.circular(2)),
        ),
        SizedBox(width: 8),
        Icon(Icons.storefront_outlined, size: 16, color: kPurple),
        SizedBox(width: 6),
        Text(name,
            style: TextStyle(
                color: Theme.of(context).appColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w800)),
      ],
    );
  }
}

// ── Cart tile ─────────────────────────────────────────────────────────────────

class _CartTile extends StatelessWidget {
  final _CartProduct product;
  final VoidCallback onToggle;
  final ValueChanged<int> onQtyChange;
  const _CartTile(
      {required this.product,
      required this.onToggle,
      required this.onQtyChange});

  @override
  Widget build(BuildContext context) {
    final p = product;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).appColors.divider),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 150),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: p.selected ? kPurple : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: p.selected ? kPurple : Color(0xFFDFDEDE),
                  width: 1.5,
                ),
              ),
              child: p.selected
                  ? Icon(Icons.check,
                      size: 14, color: Theme.of(context).appColors.card)
                  : null,
            ),
          ),
          const SizedBox(width: 10),

          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              p.imagePath,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: Color(0xFFF3E4FF),
                child: Icon(Icons.image_not_supported_outlined,
                    color: kPurple, size: 24),
              ),
            ),
          ),
          SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.nama,
                    style: TextStyle(
                        color: Theme.of(context).appColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(p.model,
                    style: const TextStyle(
                        color: Color(0xFF787676),
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text(_rupiah(p.harga),
                    style: TextStyle(
                        color: kPurple,
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),

          // Qty stepper
          Row(
            children: [
              _QtyBtn(
                  icon: Icons.remove,
                  onTap: () {
                    if (p.qty > 1) onQtyChange(p.qty - 1);
                  }),
              SizedBox(width: 10),
              Text('${p.qty}',
                  style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 10),
              _QtyBtn(icon: Icons.add, onTap: () => onQtyChange(p.qty + 1)),
            ],
          ),
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
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Theme.of(context).appColors.border),
          color: Theme.of(context).appColors.card,
        ),
        child: Icon(icon, size: 14, color: Theme.of(context).appColors.ink),
      ),
    );
  }
}

// ── Payment section ───────────────────────────────────────────────────────────

class _PaymentSection extends StatelessWidget {
  final _PaymentOption? selected;
  final VoidCallback onTap;
  const _PaymentSection({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Metode Pembayaran',
            style: TextStyle(
                color: Theme.of(context).appColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w700)),
        SizedBox(height: 10),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).appColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: selected != null ? kPurple : const Color(0xFFDFDEDE)),
            ),
            child: Row(
              children: [
                if (selected != null) ...[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: selected!.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(selected!.icon, color: selected!.color, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selected!.label,
                            style: TextStyle(
                                color: Theme.of(context).appColors.ink,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                        Text(selected!.group,
                            style: TextStyle(
                                color: Color(0xFF787676),
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ] else ...[
                  Icon(Icons.payment_outlined,
                      color: Color(0xFF9E9E9E), size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Pilih metode pembayaran',
                        style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
                Icon(Icons.keyboard_arrow_down,
                    color: Theme.of(context).appColors.ink),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentPickerSheet extends StatelessWidget {
  final _PaymentOption? selected;
  final ValueChanged<_PaymentOption> onSelect;
  final ScrollController scrollController;
  const _PaymentPickerSheet(
      {required this.selected,
      required this.onSelect,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<_PaymentOption>>{};
    for (final opt in _paymentOptions) {
      groups.putIfAbsent(opt.group, () => []).add(opt);
    }
    return Column(
      children: [
        // Fixed handle + title
        Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              SizedBox(height: 14),
              Text('Pilih Metode Pembayaran',
                  style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
            ],
          ),
        ),
        // Scrollable options
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              for (final entry in groups.entries) ...[
                Text(entry.key,
                    style: const TextStyle(
                        color: Color(0xFF787676),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                for (final opt in entry.value)
                  _PaymentTile(
                    option: opt,
                    isSelected: selected?.label == opt.label,
                    onTap: () => onSelect(opt),
                  ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final _PaymentOption option;
  final bool isSelected;
  final VoidCallback onTap;
  const _PaymentTile(
      {required this.option, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E4FF) : const Color(0xFFF7F7FB),
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: isSelected ? kPurple : const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: option.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(option.icon, color: option.color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(option.label,
                  style: TextStyle(
                      color: isSelected ? kPurple : const Color(0xFF121111),
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600)),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: kPurple, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Summary ───────────────────────────────────────────────────────────────────

class _SummarySection extends StatelessWidget {
  final int totalItems;
  final int totalHarga;
  const _SummarySection({required this.totalItems, required this.totalHarga});

  @override
  Widget build(BuildContext context) {
    const ongkir = 0;
    const diskon = 0;
    final subtotal = totalHarga + ongkir - diskon;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ringkasan Pesanan',
            style: TextStyle(
                color: Theme.of(context).appColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        _SummaryRow(
            label: 'Total ($totalItems barang)', value: _rupiah(totalHarga)),
        const SizedBox(height: 8),
        _SummaryRow(label: 'Ongkos Kirim', value: _rupiah(ongkir)),
        const SizedBox(height: 8),
        _SummaryRow(label: 'Diskon', value: '- ${_rupiah(diskon)}'),
        const SizedBox(height: 14),
        const Divider(color: Color(0xFFEEEEEE)),
        const SizedBox(height: 12),
        _SummaryRow(label: 'Subtotal', value: _rupiah(subtotal), bold: true),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow(
      {required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Color(0xFF787676), fontSize: 13)),
        Text(value,
            style: TextStyle(
                color: bold ? kPurple : Color(0xFF121111),
                fontSize: bold ? 15 : 13,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
      ],
    );
  }
}

// ── Pay bar ───────────────────────────────────────────────────────────────────

class _PayBar extends StatelessWidget {
  final int total;
  final VoidCallback onPay;
  const _PayBar({required this.total, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.card,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Total Pembayaran',
                  style: TextStyle(
                      color: Color(0xFF787676),
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(_rupiah(total),
                  style: TextStyle(
                      color: kPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.w900)),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: onPay,
                child: Text('Bayar Sekarang',
                    style: TextStyle(
                        color: Theme.of(context).appColors.card,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Processing dialog ─────────────────────────────────────────────────────────

class _ProcessingDialog extends StatelessWidget {
  const _ProcessingDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                color: kPurple,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Memproses Pembayaran',
              style: TextStyle(
                  color: Theme.of(context).appColors.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mohon tunggu sebentar...',
              style: TextStyle(
                  color: Color(0xFF787676),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
