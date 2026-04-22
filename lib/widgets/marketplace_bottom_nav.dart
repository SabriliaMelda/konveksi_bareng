import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _kPurple = Color(0xFF6B257F);

/// Bottom navigation used only inside the marketplace flow.
/// Pass the [activeIndex] matching the tab position:
///   0 = Beranda, 1 = Promo, 2 = My Order, 3 = Profile
class MarketplaceBottomNav extends StatelessWidget {
  final int activeIndex;
  final String? prevRoute;

  const MarketplaceBottomNav({super.key, required this.activeIndex, this.prevRoute});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? const Color(0xFF334155) : const Color(0xFFE8ECF4);
    final activeColor = isDark ? const Color(0xFFD8B4FE) : _kPurple;
    final inactiveColor =
        isDark ? const Color(0xFF64748B) : const Color(0xFFC9CBCE);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 62,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MarketplaceNavItem(
                  label: 'Beranda',
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_filled,
                  active: activeIndex == 0,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onTap: () {
                    if (activeIndex != 0) {
                      final route = prevRoute == null || prevRoute!.isEmpty
                          ? '/marketplace'
                          : '/marketplace?prev=${Uri.encodeComponent(prevRoute!)}';
                      context.push(route);
                    }
                  },
                ),
                _MarketplaceNavItem(
                  label: 'Promo',
                  icon: Icons.local_offer_outlined,
                  activeIcon: Icons.local_offer,
                  active: activeIndex == 1,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onTap: () {
                    if (activeIndex != 1) context.push('/promotion');
                  },
                ),
                _MarketplaceNavItem(
                  label: 'My Order',
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long,
                  active: activeIndex == 2,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onTap: () {
                    if (activeIndex != 2) {
                      final location = GoRouterState.of(context).uri;
                      context.push(
                        '/purchase?prev=${Uri.encodeComponent(location.toString())}',
                      );
                    }
                  },
                ),
                _MarketplaceNavItem(
                  label: 'Profile',
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  active: activeIndex == 3,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onTap: () {
                    if (activeIndex != 3) context.push('/profile');
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: bottomInset),
        ],
      ),
    );
  }
}

class _MarketplaceNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _MarketplaceNavItem({
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
