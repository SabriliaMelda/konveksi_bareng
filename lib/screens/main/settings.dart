// settings.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:konveksi_bareng/config/app_theme.dart';
import 'package:konveksi_bareng/providers/theme_provider.dart';
import 'package:konveksi_bareng/widgets/app_bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ===== Search =====
  final _searchC = TextEditingController();

  // ===== Dummy states =====
  bool _notif = true;
  bool _biometric = false;
  bool _autoBackup = true;

  // ===== Expand/Collapse sections =====
  bool _expPref = true;
  bool _expUmum = true;
  bool _expBantuan = true;

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  bool _match(String text, String q) {
    if (q.isEmpty) return true;
    return text.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final q = _searchC.text.trim().toLowerCase();
    final tp = context.watch<ThemeProvider>();

    // ===== Theme tokens from ThemeProvider =====
    final bool isDark = tp.darkMode;
    const purple = Color(0xFF6B257F);

    final bg = tp.bg;
    final ink = tp.ink;
    final muted = tp.muted;
    final border = tp.border;
    final card = tp.card;
    final tile = tp.tile;
    final tileBorder = tp.tileBorder;
    final iconSurface = tp.iconSurface;

    // === Auto open section kalau ada hasil search ===
    final prefHas = _match('notifikasi reminder update status', q) ||
        _match('dark mode tema gelap', q) ||
        _match('biometrik fingerprint face id', q) ||
        _match('auto backup simpan otomatis', q);

    final umumHas = _match('profil nama foto kontak', q) ||
        _match('keamanan pin perangkat', q) ||
        _match('bahasa indonesia', q) ||
        _match('tema tampilan warna font layout', q);

    final bantuanHas = _match('pusat bantuan faq panduan', q) ||
        _match('kebijakan privasi data penggunaan', q) ||
        _match('tentang aplikasi versi build lisensi', q);

    final showPref = q.isEmpty ? true : prefHas;
    final showUmum = q.isEmpty ? true : umumHas;
    final showBantuan = q.isEmpty ? true : bantuanHas;

    final expPref = q.isEmpty ? _expPref : true;
    final expUmum = q.isEmpty ? _expUmum : true;
    final expBantuan = q.isEmpty ? _expBantuan : true;

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: AppBottomNav(activeIndex: 2),
      body: Stack(
        children: [
          _GradientBackdropPurple(isDark: isDark), // ✅ ikut dark
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              children: [
                // ===== Header =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleIcon(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => context.pop(),
                      iconColor: ink,
                      surface: iconSurface,
                      borderColor: border,
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ink,
                        height: 1.2,
                      ),
                    ),
                    _CircleIcon(
                      icon: Icons.home_filled,
                      iconColor: purple,
                      onTap: () {
                        context.go('/home');
                      },
                      surface: iconSurface,
                      borderColor: border,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ✅ SEARCH BAR
                _GlassCard(
                  cardColor: card,
                  borderColor: border,
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: muted, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchC,
                          onChanged: (_) => setState(() {}),
                          style: TextStyle(
                            color: ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                'Cari setting... (contoh: notifikasi, tema)',
                            hintStyle: TextStyle(
                              color: muted,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ),
                      if (_searchC.text.isNotEmpty)
                        InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () {
                            _searchC.clear();
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.close_rounded,
                              color: muted,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ===== Account card =====
                _GlassCard(
                  cardColor: card,
                  borderColor: border,
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? const [Color(0xFF1F2937), Color(0xFF0F172A)]
                                : const [Color(0xFFF3E8FF), Color(0xFFFFFFFF)],
                          ),
                          border: Border.all(color: border),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: purple,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IT BDN',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ink,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Admin • bdn@company.com (dummy)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _Pill(
                        text: 'Edit',
                        color: purple,
                        onTap: () => _toast(context, 'Edit profil (dummy)'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ===== Preferensi (collapsible) =====
                if (showPref) ...[
                  _AccordionHeader(
                    title: 'Preferensi',
                    subtitle: 'Pengaturan cepat untuk aplikasi',
                    expanded: expPref,
                    onTap: () => setState(() => _expPref = !_expPref),
                    ink: ink,
                    muted: muted,
                    border: border,
                    card: card,
                    accent: purple,
                  ),
                  const SizedBox(height: 10),
                  if (expPref)
                    _GlassCard(
                      cardColor: card,
                      borderColor: border,
                      child: Column(
                        children: [
                          if (_match('notifikasi reminder update status', q))
                            _SwitchRow(
                              accent: purple,
                              icon: Icons.notifications_active_outlined,
                              title: 'Notifikasi',
                              subtitle: 'Reminder & update status',
                              value: _notif,
                              onChanged: (v) => setState(() => _notif = v),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                              isDark: isDark,
                            ),
                          if (_match('notifikasi reminder update status', q) &&
                              (_match('dark mode tema gelap', q) ||
                                  _match('biometrik fingerprint face id', q) ||
                                  _match('auto backup simpan otomatis', q)))
                            _DividerSoft(
                              color: isDark
                                  ? const Color(0x14FFFFFF)
                                  : const Color(0x110F172A),
                            ),
                          if (_match('dark mode tema gelap', q))
                            _SwitchRow(
                              accent: purple,
                              icon: Icons.dark_mode_outlined,
                              title: 'Dark Mode',
                              subtitle: 'Tema gelap',
                              value: isDark,
                              onChanged: (v) => tp.setDarkMode(v),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                              isDark: isDark,
                            ),
                          if (_match('dark mode tema gelap', q) &&
                              (_match('biometrik fingerprint face id', q) ||
                                  _match('auto backup simpan otomatis', q)))
                            _DividerSoft(
                              color: isDark
                                  ? const Color(0x14FFFFFF)
                                  : const Color(0x110F172A),
                            ),
                          if (_match('biometrik fingerprint face id', q))
                            _SwitchRow(
                              accent: purple,
                              icon: Icons.fingerprint_rounded,
                              title: 'Biometrik',
                              subtitle: 'Fingerprint / Face ID (dummy)',
                              value: _biometric,
                              onChanged: (v) => setState(() => _biometric = v),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                              isDark: isDark,
                            ),
                          if (_match('biometrik fingerprint face id', q) &&
                              _match('auto backup simpan otomatis', q))
                            _DividerSoft(
                              color: isDark
                                  ? const Color(0x14FFFFFF)
                                  : const Color(0x110F172A),
                            ),
                          if (_match('auto backup simpan otomatis', q))
                            _SwitchRow(
                              accent: purple,
                              icon: Icons.cloud_sync_outlined,
                              title: 'Auto Backup',
                              subtitle: 'Simpan otomatis (dummy)',
                              value: _autoBackup,
                              onChanged: (v) => setState(() => _autoBackup = v),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                              isDark: isDark,
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                ],

                // ===== Umum (collapsible) =====
                if (showUmum) ...[
                  _AccordionHeader(
                    title: 'Umum',
                    subtitle: 'Kelola akun, keamanan, dan tampilan',
                    expanded: expUmum,
                    onTap: () => setState(() => _expUmum = !_expUmum),
                    ink: ink,
                    muted: muted,
                    border: border,
                    card: card,
                    accent: purple,
                  ),
                  const SizedBox(height: 10),
                  if (expUmum)
                    _GlassCard(
                      cardColor: card,
                      borderColor: border,
                      child: Column(
                        children: [
                          if (_match('profil nama foto kontak', q))
                            _MenuRow(
                              accent: purple,
                              icon: Icons.person_outline_rounded,
                              title: 'Profil',
                              subtitle: 'Nama, foto, kontak',
                              onTap: () => _toast(context, 'Profil (dummy)'),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                            ),
                          if (_match('profil nama foto kontak', q) &&
                              (_match('keamanan pin perangkat', q) ||
                                  _match('bahasa indonesia', q) ||
                                  _match('tema tampilan warna font layout', q)))
                            _DividerSoft(
                              color: isDark
                                  ? const Color(0x14FFFFFF)
                                  : const Color(0x110F172A),
                            ),
                          if (_match('keamanan pin perangkat', q))
                            _MenuRow(
                              accent: purple,
                              icon: Icons.lock_outline_rounded,
                              title: 'Keamanan',
                              subtitle: 'PIN, perangkat',
                              onTap: () => _toast(context, 'Keamanan (dummy)'),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                            ),
                          if (_match('keamanan pin perangkat', q) &&
                              (_match('bahasa indonesia', q) ||
                                  _match('tema tampilan warna font layout', q)))
                            _DividerSoft(
                              color: isDark
                                  ? const Color(0x14FFFFFF)
                                  : const Color(0x110F172A),
                            ),
                          if (_match('bahasa indonesia', q))
                            _MenuRow(
                              accent: purple,
                              icon: Icons.language_rounded,
                              title: 'Bahasa',
                              subtitle: 'Indonesia',
                              onTap: () => _toast(context, 'Bahasa (dummy)'),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                            ),
                          if (_match('bahasa indonesia', q) &&
                              _match('tema tampilan warna font layout', q))
                            _DividerSoft(
                              color: isDark
                                  ? const Color(0x14FFFFFF)
                                  : const Color(0x110F172A),
                            ),
                          if (_match('tema tampilan warna font layout', q))
                            _MenuRow(
                              accent: purple,
                              icon: Icons.palette_outlined,
                              title: 'Tema & Tampilan',
                              subtitle: 'Warna, font, layout',
                              onTap: () => _toast(context, 'Tema (dummy)'),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                ],

                // ===== Bantuan (collapsible) =====
                if (showBantuan) ...[
                  _AccordionHeader(
                    title: 'Bantuan',
                    subtitle: 'Info & dukungan',
                    expanded: expBantuan,
                    onTap: () => setState(() => _expBantuan = !_expBantuan),
                    ink: ink,
                    muted: muted,
                    border: border,
                    card: card,
                    accent: purple,
                  ),
                  const SizedBox(height: 10),
                  if (expBantuan)
                    _GlassCard(
                      cardColor: card,
                      borderColor: border,
                      child: Column(
                        children: [
                          if (_match('pusat bantuan faq panduan', q))
                            _MenuRow(
                              accent: purple,
                              icon: Icons.help_outline_rounded,
                              title: 'Pusat Bantuan',
                              subtitle: 'FAQ & panduan',
                              onTap: () =>
                                  _toast(context, 'Pusat Bantuan (dummy)'),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                            ),
                          if (_match('pusat bantuan faq panduan', q) &&
                              (_match('kebijakan privasi data penggunaan', q) ||
                                  _match(
                                    'tentang aplikasi versi build lisensi',
                                    q,
                                  )))
                            _DividerSoft(
                              color: isDark
                                  ? const Color(0x14FFFFFF)
                                  : const Color(0x110F172A),
                            ),
                          if (_match('kebijakan privasi data penggunaan', q))
                            _MenuRow(
                              accent: purple,
                              icon: Icons.privacy_tip_outlined,
                              title: 'Kebijakan Privasi',
                              subtitle: 'Data & penggunaan',
                              onTap: () =>
                                  _toast(context, 'Kebijakan Privasi (dummy)'),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                            ),
                          if (_match('kebijakan privasi data penggunaan', q) &&
                              _match('tentang aplikasi versi build lisensi', q))
                            _DividerSoft(
                              color: isDark
                                  ? const Color(0x14FFFFFF)
                                  : const Color(0x110F172A),
                            ),
                          if (_match('tentang aplikasi versi build lisensi', q))
                            _MenuRow(
                              accent: purple,
                              icon: Icons.info_outline_rounded,
                              title: 'Tentang Aplikasi',
                              subtitle: 'Versi, build, lisensi',
                              onTap: () => _toast(context, 'Tentang (dummy)'),
                              ink: ink,
                              muted: muted,
                              tile: tile,
                              tileBorder: tileBorder,
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 18),
                ],

                // ===== Logout =====
                _GlassCard(
                  cardColor: card,
                  borderColor: border,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => _toast(context, 'Logout (dummy)'),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0x22EF4444)),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0x0FFF6B6B), Color(0x00FFFFFF)],
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFEF4444),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// ===== Background gradient (ikut darkMode) =====
class _GradientBackdropPurple extends StatelessWidget {
  final bool isDark;
  const _GradientBackdropPurple({required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (isDark) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF070A12), Color(0xFF0B1220), Color(0xFF0F172A)],
          ),
        ),
        child: Stack(
          children: const [
            Positioned(
              top: -60,
              right: -40,
              child: _BlurBlob(size: 220, color: Color(0x223B82F6)),
            ),
            Positioned(
              bottom: -80,
              left: -60,
              child: _BlurBlob(size: 260, color: Color(0x224C1D95)),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDF4FF), Color(0xFFF8FAFC), Color(0xFFF3E8FF)],
        ),
      ),
      child: Stack(
        children: const [
          Positioned(
            top: -60,
            right: -40,
            child: _BlurBlob(size: 220, color: Color(0x556B257F)),
          ),
          Positioned(
            bottom: -80,
            left: -60,
            child: _BlurBlob(size: 260, color: Color(0x338B5CF6)),
          ),
        ],
      ),
    );
  }
}

class _BlurBlob extends StatelessWidget {
  final double size;
  final Color color;
  const _BlurBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ===== Reusable UI =====
class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color cardColor;
  final Color borderColor;

  const _GlassCard({
    required this.child,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color surface;
  final Color borderColor;

  const _CircleIcon({
    required this.icon,
    required this.onTap,
    required this.surface,
    required this.borderColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
          color: surface,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? const Color(0xFF0F172A),
        ),
      ),
    );
  }
}

class _AccordionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool expanded;
  final VoidCallback onTap;

  final Color ink;
  final Color muted;
  final Color border;
  final Color card;
  final Color accent;

  const _AccordionHeader({
    required this.title,
    required this.subtitle,
    required this.expanded,
    required this.onTap,
    required this.ink,
    required this.muted,
    required this.border,
    required this.card,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0E000000),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: Icon(Icons.expand_more_rounded, color: accent, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}

class _DividerSoft extends StatelessWidget {
  final Color color;
  const _DividerSoft({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, thickness: 1, color: color),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  const _Pill({required this.text, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.18)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withValues(alpha: 0.14), const Color(0x00FFFFFF)],
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  final Color ink;
  final Color muted;
  final Color tile;
  final Color tileBorder;
  final bool isDark;

  const _SwitchRow({
    required this.accent,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.ink,
    required this.muted,
    required this.tile,
    required this.tileBorder,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: tile,
            border: Border.all(color: tileBorder),
          ),
          child: Icon(icon, color: accent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ink,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: muted,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: accent,
          inactiveThumbColor: isDark ? const Color(0xFFCBD5E1) : null,
          inactiveTrackColor: isDark ? const Color(0x33475569) : null,
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  final Color ink;
  final Color muted;
  final Color tile;
  final Color tileBorder;

  const _MenuRow({
    required this.accent,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.ink,
    required this.muted,
    required this.tile,
    required this.tileBorder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: tile,
                border: Border.all(color: tileBorder),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: ink,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: muted,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: muted),
          ],
        ),
      ),
    );
  }
}
