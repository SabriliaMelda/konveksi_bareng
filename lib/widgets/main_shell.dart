import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_bottom_nav.dart';

/// Persistent shell scaffold that keeps [AppBottomNav] alive across
/// all main tab routes (/home, /wishlist, /settings, /chat, /profile).
/// The [child] is swapped by GoRouter's ShellRoute without rebuilding this widget.
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  static int _activeIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/wishlist')) return 1;
    if (location.startsWith('/settings')) return 2;
    if (location.startsWith('/chat')) return 3;
    if (location.startsWith('/profile')) return 4;
    if (location.startsWith('/security-settings') ||
        location.startsWith('/language-settings') ||
        location.startsWith('/appearance-settings') ||
        location.startsWith('/help-center') ||
        location.startsWith('/privacy-policy') ||
        location.startsWith('/about-app')) {
      return -1;
    }
    if (location.startsWith('/purchase')) {
      return -1; // No active icon for purchase
    }
    return 0; // /home (default)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Let the body extend behind the bottom nav bar — the nav bar itself
      // adds a SizedBox for the system navigation bar inset.
      extendBody: true,
      bottomNavigationBar: AppBottomNav(activeIndex: _activeIndex(context)),
      body: child,
    );
  }
}
