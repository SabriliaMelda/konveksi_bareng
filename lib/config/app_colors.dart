import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';

/// Theme extension — access via `Theme.of(context).appColors`
/// or the shorthand `context.appColors`.
class AppColors extends ThemeExtension<AppColors> {
  final Color bg;
  final Color card;
  final Color ink;
  final Color muted;
  final Color subtle;
  final Color border;
  final Color purple;
  final Color purpleLight;
  final Color purpleButton;
  final Color inputFill;
  final Color iconSurface;
  final Color divider;
  final Color danger;
  final Color success;
  final Color warning;

  AppColors({
    required this.bg,
    required this.card,
    required this.ink,
    required this.muted,
    required this.subtle,
    required this.border,
    required this.purple,
    required this.purpleLight,
    required this.purpleButton,
    required this.inputFill,
    required this.iconSurface,
    required this.divider,
    required this.danger,
    required this.success,
    required this.warning,
  });

  // ── Light ──────────────────────────────────────────────────────────────────
  static final light = AppColors(
    bg: const Color(0xFFF7F7FB),
    card: Colors.white,
    ink: const Color(0xFF1E232C),
    muted: const Color(0xFF6B7280),
    subtle: const Color(0xFF9CA3AF),
    border: const Color(0xFFE8ECF4),
    purple: const Color(0xFF6B257F),
    purpleLight: const Color(0xFFF3E4FF),
    purpleButton: const Color(0xFF742C92),
    inputFill: Colors.white,
    iconSurface: const Color(0xFFF6F4F0),
    divider: const Color(0xFFEEEEEE),
    danger: const Color(0xFFDC2626),
    success: const Color(0xFF16A34A),
    warning: const Color(0xFFF59E0B),
  );

  // ── Dark ───────────────────────────────────────────────────────────────────
  static final dark = AppColors(
    bg: const Color(0xFF0F172A),
    card: const Color(0xFF1E293B),
    ink: const Color(0xFFF1F5F9),
    muted: const Color(0xFF94A3B8),
    subtle: const Color(0xFF64748B),
    border: const Color(0xFF334155),
    purple: const Color(0xFFD8B4FE),
    purpleLight: const Color(0xFF4C1D95),
    purpleButton: const Color(0xFF7C3AED),
    inputFill: const Color(0xFF1E293B),
    iconSurface: const Color(0xFF1E293B),
    divider: const Color(0xFF1E293B),
    danger: const Color(0xFFF87171),
    success: const Color(0xFF4ADE80),
    warning: const Color(0xFFFBBF24),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? card,
    Color? ink,
    Color? muted,
    Color? subtle,
    Color? border,
    Color? purple,
    Color? purpleLight,
    Color? purpleButton,
    Color? inputFill,
    Color? iconSurface,
    Color? divider,
    Color? danger,
    Color? success,
    Color? warning,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      card: card ?? this.card,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      subtle: subtle ?? this.subtle,
      border: border ?? this.border,
      purple: purple ?? this.purple,
      purpleLight: purpleLight ?? this.purpleLight,
      purpleButton: purpleButton ?? this.purpleButton,
      inputFill: inputFill ?? this.inputFill,
      iconSurface: iconSurface ?? this.iconSurface,
      divider: divider ?? this.divider,
      danger: danger ?? this.danger,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      card: Color.lerp(card, other.card, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      subtle: Color.lerp(subtle, other.subtle, t)!,
      border: Color.lerp(border, other.border, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      purpleLight: Color.lerp(purpleLight, other.purpleLight, t)!,
      purpleButton: Color.lerp(purpleButton, other.purpleButton, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      iconSurface: Color.lerp(iconSurface, other.iconSurface, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

/// Shorthand: `Theme.of(context).appColors`
extension AppColorsX on ThemeData {
  AppColors get appColors => extension<AppColors>() ?? AppColors.light;
}

/// Even shorter: `context.appColors`
extension AppColorsBuildContextX on BuildContext {
  AppColors get appColors => Theme.of(this).appColors;
}
