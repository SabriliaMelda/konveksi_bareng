import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _kPurple = Color(0xFF6B257F);

/// Shared bottom navigation bar used across all main screens.
/// Pass the [activeIndex] matching the tab position:
///   0 = Home, 1 = Wishlist, 2 = Settings, 3 = Chat, 4 = Profile
class AppBottomNav extends StatelessWidget {
  final int activeIndex;

  AppBottomNav({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? const Color(0xFF334155) : const Color(0xFFE8ECF4);
    final activeColor = isDark ? const Color(0xFFD8B4FE) : _kPurple;
    final inactiveColor =
        isDark ? const Color(0xFF64748B) : const Color(0xFFC9CBCE);

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            label: 'Home',
            icon: Icons.home_outlined,
            activeIcon: Icons.home_filled,
            active: activeIndex == 0,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (activeIndex != 0) context.go('/home');
            },
          ),
          _NavItem(
            label: 'Wishlist',
            icon: Icons.favorite_border,
            activeIcon: Icons.favorite,
            active: activeIndex == 1,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (activeIndex != 1) context.push('/wishlist');
            },
          ),
          _NavItem(
            label: 'Settings',
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            active: activeIndex == 2,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (activeIndex != 2) context.push('/settings');
            },
          ),
          _NavItem(
            label: 'Chat',
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            active: activeIndex == 3,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (activeIndex != 3) context.push('/chat');
            },
          ),
          _NavItem(
            label: 'Profile',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            active: activeIndex == 4,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () {
              if (activeIndex != 4) context.push('/profile');
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    this.activeIcon,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? activeColor : inactiveColor;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                active ? (activeIcon ?? icon) : icon,
                key: ValueKey(active),
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
