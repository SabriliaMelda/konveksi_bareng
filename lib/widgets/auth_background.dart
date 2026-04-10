import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Konveksi Bareng theme colors ──
const Color kPurple = Color(0xFF6B257F);
const Color kPurpleButton = Color(0xFF742C92);
const Color kPurpleLight = Color(0xFF7B4E88);
const Color kPurpleBorder = Color(0xFFB88BC5);

/// Shared background + card layout for all auth screens.
class AuthBackground extends StatelessWidget {
  final Widget child;
  final bool showBackButton;

  const AuthBackground({
    super.key,
    required this.child,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final bottomInset = media.viewInsets.bottom;
    final cardWidth = size.width < 380 ? size.width * 0.85 : 340.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F8),
      body: Stack(
        children: [
          // Pattern background
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF7F3F8),
              child: Opacity(
                opacity: 0.16,
                child: Image.asset(
                  'assets/images/bg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                // Back button
                if (showBackButton)
                  Positioned(
                    left: 18,
                    top: 10,
                    child: _BackButton(),
                  ),
                // Card content
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 70,
                      bottom: 20 + bottomInset,
                    ),
                    child: Container(
                      width: cardWidth,
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFDFD),
                        border: Border.all(
                          color: const Color(0xFFD7D7D7),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: child,
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

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/welcome');
        }
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: Color(0xFF3B3B3B),
        ),
      ),
    );
  }
}

/// Logo header for auth screens.
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-10, 0),
      child: Image.asset(
        'assets/images/logo1.png',
        width: 120,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.accessibility_new_rounded,
                  color: kPurple, size: 10),
              SizedBox(width: 8),
              Text(
                'KONVEKSI\nBARENG',
                style: TextStyle(
                  color: kPurple,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Error box displayed below form titles.
class AuthErrorBox extends StatelessWidget {
  final String message;
  final List<InlineSpan>? extra;

  const AuthErrorBox({super.key, required this.message, this.extra});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFFECACA)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text.rich(
        TextSpan(
          text: message,
          style: const TextStyle(
            color: Color(0xFFB91C1C),
            fontSize: 12,
          ),
          children: extra,
        ),
      ),
    );
  }
}

/// Info box (blue) for informational messages.
class AuthInfoBox extends StatelessWidget {
  final String message;

  const AuthInfoBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFF),
        border: Border.all(color: kPurpleBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: kPurple,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Language dropdown widget reused across auth screens.
class LanguageDropdown extends StatelessWidget {
  final String currentLang;
  final ValueChanged<String> onChanged;

  const LanguageDropdown({
    super.key,
    required this.currentLang,
    required this.onChanged,
  });

  static const _languages = [
    {'code': 'id', 'label': 'Indonesia'},
    {'code': 'en', 'label': 'English'},
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      offset: const Offset(0, -80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: kPurpleBorder, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _languages.firstWhere(
                  (l) => l['code'] == currentLang)['label']!,
              style: const TextStyle(
                color: kPurple,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 16, color: kPurple),
          ],
        ),
      ),
      itemBuilder: (_) => _languages
          .map((l) => PopupMenuItem<String>(
                value: l['code'],
                child: Text(
                  l['label']!,
                  style: TextStyle(
                    fontSize: 13,
                    color: l['code'] == currentLang
                        ? kPurple
                        : const Color(0xFF374151),
                    fontWeight: l['code'] == currentLang
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

/// Bottom bar with language dropdown + help link + copyright.
class AuthBottomBar extends StatelessWidget {
  final String lang;
  final ValueChanged<String> onLangChanged;
  final String helpLabel;

  const AuthBottomBar({
    super.key,
    required this.lang,
    required this.onLangChanged,
    required this.helpLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LanguageDropdown(currentLang: lang, onChanged: onLangChanged),
            Text(
              helpLabel,
              style: const TextStyle(
                color: kPurple,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 54),
        const Text(
          '\u00a9 Copyrights BOMA | All Rights Reserved',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF8F8F8F),
            fontSize: 10.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
