// promosi.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

const Color kPurple = Color(0xFF6B257F);

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  _PromoTab _tab = _PromoTab.promo;

  final List<_MarketPromo> _promos = [
    _MarketPromo(
      title: 'Promo Diskon Akhir Pekan',
      subtitle: 'Diskon sampai 15% untuk produk tertentu',
      badge: '15% OFF',
      endAt: DateTime.now().add(const Duration(days: 2, hours: 5)),
    ),
    _MarketPromo(
      title: 'Gratis Ongkir Area Jabodetabek',
      subtitle: 'Min. belanja Rp 250.000',
      badge: 'ONGKIR',
      endAt: DateTime.now().add(const Duration(hours: 18)),
    ),
  ];

  final List<_Voucher> _vouchers = [
    _Voucher(
      code: 'BARENG10',
      title: 'Diskon 10%',
      subtitle: 'Min. belanja Rp 150.000',
      endAt: DateTime.now().add(const Duration(days: 5)),
      kind: _VoucherKind.percent,
      value: 10,
    ),
    _Voucher(
      code: 'CASH25',
      title: 'Cashback Rp 25.000',
      subtitle: 'Min. belanja Rp 200.000',
      endAt: DateTime.now().add(const Duration(days: 3)),
      kind: _VoucherKind.cashback,
      value: 25000,
    ),
    _Voucher(
      code: 'ONGKIR',
      title: 'Gratis Ongkir',
      subtitle: 'Max potongan Rp 20.000',
      endAt: DateTime.now().add(const Duration(days: 1)),
      kind: _VoucherKind.freeShipping,
      value: 20000,
    ),
  ];

  final List<_Voucher> _history = [
    _Voucher(
      code: 'WELCOME',
      title: 'Diskon 5%',
      subtitle: 'Sudah digunakan',
      endAt: DateTime.now().subtract(const Duration(days: 10)),
      kind: _VoucherKind.percent,
      value: 5,
    ),
  ];

  String _fmtDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
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

  String _voucherBadge(_Voucher v) {
    switch (v.kind) {
      case _VoucherKind.percent:
        return '${v.value}% OFF';
      case _VoucherKind.cashback:
        return 'Cashback ${_rupiah(v.value)}';
      case _VoucherKind.freeShipping:
        return 'Ongkir s/d ${_rupiah(v.value)}';
    }
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _TabPill(
              label: 'Promo',
              active: _tab == _PromoTab.promo,
              onTap: () => setState(() => _tab = _PromoTab.promo),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TabPill(
              label: 'Voucher',
              active: _tab == _PromoTab.voucher,
              onTap: () => setState(() => _tab = _PromoTab.voucher),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TabPill(
              label: 'Riwayat',
              active: _tab == _PromoTab.riwayat,
              onTap: () => setState(() => _tab = _PromoTab.riwayat),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0xFFDFDEDE)),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Text(
                    'Promosi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF121111),
                      height: 1.4,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0xFFDFDEDE)),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.home_filled,
                        size: 20,
                        color: kPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            _buildTabs(),
            const SizedBox(height: 12),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _tab == _PromoTab.voucher
                    ? _buildVoucher()
                    : _tab == _PromoTab.riwayat
                    ? _buildHistory()
                    : _buildPromo(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== TAB PROMO ==================
  Widget _buildPromo() {
    return ListView.separated(
      key: const ValueKey('promo'),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: _promos.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        if (i == 0) return _HighlightCard();
        final p = _promos[i - 1];

        return _CardBox(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.local_offer_outlined,
                  color: kPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6A707C),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Berakhir: ${_fmtDate(p.endAt)}',
                      style: const TextStyle(
                        color: Color(0xFF9AA4B2),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Badge(text: p.badge),
                  const SizedBox(height: 10),
                  _PrimaryMiniButton(
                    text: 'Lihat',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Buka detail promo (dummy)'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ================== TAB VOUCHER ==================
  Widget _buildVoucher() {
    return ListView.separated(
      key: const ValueKey('voucher'),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: _vouchers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final v = _vouchers[i];

        return _CardBox(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.confirmation_number_outlined,
                  color: kPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      v.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6A707C),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _CodeChip(code: v.code),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Berlaku s/d ${_fmtDate(v.endAt)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF9AA4B2),
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
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Badge(text: _voucherBadge(v)),
                  const SizedBox(height: 10),
                  _GhostMiniButton(
                    text: 'Salin',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Kode ${v.code} disalin (dummy)'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _PrimaryMiniButton(
                    text: 'Pakai',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Terapkan voucher (dummy)'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ================== TAB RIWAYAT ==================
  Widget _buildHistory() {
    return ListView.separated(
      key: const ValueKey('history'),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: _history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final v = _history[i];
        return Opacity(
          opacity: 0.6,
          child: _CardBox(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F7F8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.history_rounded,
                    color: kPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF1E232C),
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${v.subtitle} • ${v.code}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF6A707C),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Berakhir: ${_fmtDate(v.endAt)}',
                        style: const TextStyle(
                          color: Color(0xFF9AA4B2),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _Badge(text: _voucherBadge(v)),
              ],
            ),
          ),
        );
      },
    );
  }
}

//
// ================== UI COMPONENTS ==================
//
class _TabPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: active ? kPurple : const Color(0xFFF6F7F8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? kPurple : const Color(0xFFE8ECF4)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF1E232C),
            fontSize: 11.5,
            fontWeight: active ? FontWeight.w900 : FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _CardBox extends StatelessWidget {
  final Widget child;
  const _CardBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0CB3B3B3),
            blurRadius: 40,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: kPurple,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CodeChip extends StatelessWidget {
  final String code;
  const _CodeChip({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Text(
        code,
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 11.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _PrimaryMiniButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryMiniButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: kPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _GhostMiniButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _GhostMiniButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8ECF4)),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: kPurple,
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CardBox(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F8),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.percent_rounded, color: kPurple, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Promo untuk kamu',
                  style: TextStyle(
                    color: Color(0xFF1E232C),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Cek promo & voucher yang bisa dipakai saat checkout.',
                  style: TextStyle(
                    color: Color(0xFF6A707C),
                    fontSize: 12,
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

//
// ================== MODELS ==================
//
enum _PromoTab { promo, voucher, riwayat }

class _MarketPromo {
  final String title;
  final String subtitle;
  final String badge;
  final DateTime endAt;

  _MarketPromo({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.endAt,
  });
}

enum _VoucherKind { percent, cashback, freeShipping }

class _Voucher {
  final String code;
  final String title;
  final String subtitle;
  final DateTime endAt;
  final _VoucherKind kind;
  final int value;

  _Voucher({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.endAt,
    required this.kind,
    required this.value,
  });
}
