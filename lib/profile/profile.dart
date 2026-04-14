// profile.dart
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:konveksi_bareng/screens/main/home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ===== Tokens (PURPLE) =====
  static const _purple = Color(0xFF6B257F); // main
  static const _purple2 = Color(0xFF8B5CF6); // secondary
  static const _ink = Color(0xFF0F172A);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0x1A0F172A);
  static const _card = Color(0xCCFFFFFF);

  // ===== Dummy user =====
  final _nameC = TextEditingController(text: 'IT BDN');
  final _emailC = TextEditingController(text: 'bdn@company.com');
  final _phoneC = TextEditingController(text: '08xxxxxxxxxx');
  final _roleC = TextEditingController(text: 'Admin');

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _roleC.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: Stack(
        children: [
          const _GradientBackdropPurple(),
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
                      onTap: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                        height: 1.2,
                      ),
                    ),
                    _CircleIcon(
                      icon: Icons.home_filled,
                      iconColor: _purple,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ===== Profile Card =====
                _GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFF3E8FF), Color(0xFFFFFFFF)],
                          ),
                          border: Border.all(color: _border),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: _purple,
                          size: 34,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameC.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _ink,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_roleC.text} • ${_emailC.text}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone_outlined,
                                  size: 14,
                                  color: _muted,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _phoneC.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: _muted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _Pill(
                        text: 'Ubah Foto',
                        color: _purple,
                        onTap: () => _toast('Ubah foto (dummy)'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ===== Mini stats =====
                Row(
                  children: const [
                    Expanded(
                      child: _MiniStat(label: 'Proyek', value: '3'),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _MiniStat(label: 'Tagihan', value: '12'),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _MiniStat(label: 'Selesai', value: '7'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const _SectionTitle(
                  title: 'Data Profil',
                  subtitle: 'Edit informasi akun kamu',
                ),
                const SizedBox(height: 10),

                _GlassCard(
                  child: Column(
                    children: [
                      _InputField(
                        accent: _purple,
                        controller: _nameC,
                        label: 'Nama',
                        hint: 'Masukkan nama',
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 10),
                      _InputField(
                        accent: _purple,
                        controller: _emailC,
                        label: 'Email',
                        hint: 'Masukkan email',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      _InputField(
                        accent: _purple,
                        controller: _phoneC,
                        label: 'No. HP',
                        hint: 'Masukkan nomor',
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
                      _InputField(
                        accent: _purple,
                        controller: _roleC,
                        label: 'Jabatan / Role',
                        hint: 'Contoh: Admin',
                        icon: Icons.work_outline_rounded,
                      ),
                      const SizedBox(height: 12),

                      // Save button
                      InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          setState(() {}); // refresh top card text
                          _toast('Profil disimpan (dummy)');
                        },
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: _purple.withValues(alpha: 0.18),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_purple, _purple2],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x1A6B257F),
                                blurRadius: 18,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                              color: Theme.of(context).appColors.card,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const _SectionTitle(
                  title: 'Keamanan & Aksi',
                  subtitle: 'Pengaturan tambahan akun',
                ),
                const SizedBox(height: 10),

                _GlassCard(
                  child: Column(
                    children: [
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.verified_user_outlined,
                        title: 'Verifikasi Akun',
                        subtitle: 'Email / nomor HP',
                        onTap: () => _toast('Verifikasi (dummy)'),
                      ),
                      const _DividerSoft(),
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.delete_outline_rounded,
                        title: 'Hapus Akun',
                        subtitle: 'Tindakan permanen (dummy)',
                        danger: true,
                        onTap: () => _toast('Hapus akun (dummy)'),
                      ),
                    ],
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
}

// ===== Background gradient (PURPLE) =====
class _GradientBackdropPurple extends StatelessWidget {
  const _GradientBackdropPurple();

  @override
  Widget build(BuildContext context) {
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
  const _GlassCard({required this.child});

  static const _border = Color(0x1A0F172A);
  static const _card = Color(0xCCFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border),
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

  const _CircleIcon({required this.icon, required this.onTap, this.iconColor});

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
          border: Border.all(color: Color(0x220F172A)),
          color: Theme.of(context).appColors.card,
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DividerSoft extends StatelessWidget {
  const _DividerSoft();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, thickness: 1, color: Color(0x110F172A)),
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

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1A0F172A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final Color accent;
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const _InputField({
    required this.accent,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: accent),
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0x220F172A)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0x220F172A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: accent),
            ),
          ),
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
  final bool danger;

  const _MenuRow({
    required this.accent,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFEF4444) : accent;
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
                color: const Color(0xFFF1F5F9),
                border: Border.all(color: const Color(0x110F172A)),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: danger
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF0F172A),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
