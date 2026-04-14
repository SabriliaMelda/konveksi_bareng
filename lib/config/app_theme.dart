import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';

const _kPurple = Color(0xFF6B257F);
const _kPurpleSeed = Color(0xFF6B257F);

// ── Light theme ───────────────────────────────────────────────────────────────

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _kPurpleSeed,
    brightness: Brightness.light,
  ),
  extensions: [AppColors.light],
  scaffoldBackgroundColor: const Color(0xFFF7F7FB),
  cardColor: Colors.white,
  dividerColor: const Color(0xFFE8ECF4),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF0F172A),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      color: Color(0xFF0F172A),
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    iconTheme: IconThemeData(color: Color(0xFF0F172A)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: _kPurple,
    unselectedItemColor: Color(0xFFC9CBCE),
    elevation: 0,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: const Color(0xFFF3E4FF),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(fontFamily: 'Poppins', fontSize: 10),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kPurple, width: 1.5),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _kPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle:
          const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _kPurple,
      side: BorderSide(color: _kPurple),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? _kPurple : Colors.white),
    trackColor: WidgetStateProperty.resolveWith((s) =>
        s.contains(WidgetState.selected)
            ? Color(0xFFD8B4FE)
            : Color(0xFFE2E8F0)),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF0F172A)),
    bodyMedium: TextStyle(color: Color(0xFF0F172A)),
    bodySmall: TextStyle(color: Color(0xFF6B7280)),
    titleLarge:
        TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700),
    titleMedium:
        TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
  ),
);

// ── Dark theme ────────────────────────────────────────────────────────────────

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _kPurpleSeed,
    brightness: Brightness.dark,
  ),
  extensions: [AppColors.dark],
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  cardColor: const Color(0xFF1E293B),
  dividerColor: const Color(0xFF1E293B),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E293B),
    foregroundColor: Color(0xFFF1F5F9),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      color: Color(0xFFF1F5F9),
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    iconTheme: IconThemeData(color: Color(0xFFF1F5F9)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E293B),
    selectedItemColor: Color(0xFFD8B4FE),
    unselectedItemColor: Color(0xFF64748B),
    elevation: 0,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: const Color(0xFF1E293B),
    indicatorColor: const Color(0xFF4C1D95),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(fontFamily: 'Poppins', fontSize: 10),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E293B),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF334155)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF334155)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFD8B4FE), width: 1.5),
    ),
    hintStyle: const TextStyle(color: Color(0xFF64748B)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF7C3AED),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle:
          const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFD8B4FE),
      side: const BorderSide(color: Color(0xFFD8B4FE)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle:
          const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((s) =>
        s.contains(WidgetState.selected)
            ? const Color(0xFFD8B4FE)
            : const Color(0xFF64748B)),
    trackColor: WidgetStateProperty.resolveWith((s) =>
        s.contains(WidgetState.selected)
            ? const Color(0xFF4C1D95)
            : const Color(0xFF1E293B)),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFF1F5F9)),
    bodyMedium: TextStyle(color: Color(0xFFF1F5F9)),
    bodySmall: TextStyle(color: Color(0xFF94A3B8)),
    titleLarge:
        TextStyle(color: Color(0xFFF1F5F9), fontWeight: FontWeight.w700),
    titleMedium:
        TextStyle(color: Color(0xFFF1F5F9), fontWeight: FontWeight.w600),
  ),
);
