import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konveksi_bareng/config/app_colors.dart';

import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/auth_background.dart';

const _strings = {
  'id': {
    'help': 'Bantuan',
    'title': 'Pilih Peran Anda',
    'subtitle': 'Pilih peran yang sesuai dengan tujuan Anda menggunakan aplikasi',
    'continue': 'Lanjutkan',
    'saving': 'Menyimpan...',
    'errorPick': 'Silakan pilih salah satu peran.',
    'errorServer': 'Tidak dapat terhubung ke server.',
    'ownerTitle': 'Owner',
    'ownerDesc': 'Pemilik usaha yang mengelola seluruh operasional konveksi.',
    'konveksiTitle': 'Konveksi',
    'konveksiDesc': 'Penyedia jasa konveksi yang menerima dan mengerjakan order.',
    'clientTitle': 'Client',
    'clientDesc': 'Pelanggan yang memesan produk atau jasa konveksi.',
  },
  'en': {
    'help': 'Help',
    'title': 'Choose Your Role',
    'subtitle': 'Pick the role that matches how you will use the app',
    'continue': 'Continue',
    'saving': 'Saving...',
    'errorPick': 'Please select a role.',
    'errorServer': 'Cannot connect to server.',
    'ownerTitle': 'Owner',
    'ownerDesc': 'Business owner managing the whole konveksi operation.',
    'konveksiTitle': 'Konveksi',
    'konveksiDesc': 'Konveksi provider that receives and fulfills orders.',
    'clientTitle': 'Client',
    'clientDesc': 'Customer who orders konveksi products or services.',
  },
};

class _RoleOption {
  final String value;
  final IconData icon;
  _RoleOption(this.value, this.icon);
}

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _lang = 'id';
  String? _selected;
  String _error = '';
  bool _loading = false;
  String _email = '';

  final _roles = <_RoleOption>[
    _RoleOption('owner', Icons.business_center_outlined),
    _RoleOption('konveksi', Icons.precision_manufacturing_outlined),
    _RoleOption('client', Icons.person_outline),
  ];

  Map<String, String> get t =>
      Map<String, String>.from(_strings[_lang] as Map);

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final email = await StorageService.getItem('security_email');
    if (email == null && mounted) {
      context.go('/login');
      return;
    }
    setState(() => _email = email ?? '');
  }

  String _titleFor(String role) {
    switch (role) {
      case 'owner':
        return t['ownerTitle']!;
      case 'konveksi':
        return t['konveksiTitle']!;
      default:
        return t['clientTitle']!;
    }
  }

  String _descFor(String role) {
    switch (role) {
      case 'owner':
        return t['ownerDesc']!;
      case 'konveksi':
        return t['konveksiDesc']!;
      default:
        return t['clientDesc']!;
    }
  }

  Future<void> _handleSubmit() async {
    if (_selected == null) {
      setState(() => _error = t['errorPick']!);
      return;
    }
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final result = await AuthService.selectRole(
        email: _email,
        role: _selected!,
      );
      if (!result.ok) {
        setState(() => _error = result.message ?? 'Gagal menyimpan');
      } else {
        await StorageService.deleteItem('security_email');
        if (mounted) context.go('/login');
      }
    } catch (_) {
      setState(() => _error = t['errorServer']!);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(t['title']!,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w800, color: kPurple)),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(t['subtitle']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kPurpleLight)),
          ),
          const SizedBox(height: 20),
          AuthErrorBox(message: _error),
          for (final r in _roles) ...[
            _RoleCard(
              selected: _selected == r.value,
              icon: r.icon,
              title: _titleFor(r.value),
              description: _descFor(r.value),
              onTap: () => setState(() {
                _selected = r.value;
                _error = '';
              }),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurpleButton,
                disabledBackgroundColor: kPurpleButton.withValues(alpha: 0.7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                _loading ? t['saving']! : t['continue']!,
                style: TextStyle(
                    color: Theme.of(context).appColors.card,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          AuthBottomBar(
            lang: _lang,
            onLangChanged: (code) => setState(() {
              _lang = code;
              _error = '';
            }),
            helpLabel: t['help']!,
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RoleCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Theme.of(context).appColors.card;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? kPurpleButton : const Color(0xFFBEB6C2),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? kPurpleButton.withValues(alpha: 0.12)
                    : const Color(0xFFF3F0F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: selected ? kPurpleButton : kPurpleLight, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kPurple)),
                  const SizedBox(height: 2),
                  Text(description,
                      style: const TextStyle(
                          fontSize: 11,
                          height: 1.3,
                          color: kPurpleLight)),
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: selected ? true : null,
              onChanged: (_) => onTap(),
              activeColor: kPurpleButton,
            ),
          ],
        ),
      ),
    );
  }
}
