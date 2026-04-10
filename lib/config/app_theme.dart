import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const purple = Color(0xFF6B257F);

  // Light mode
  static const lightBg = Color(0xFFF7FAFF);
  static const lightInk = Color(0xFF0F172A);
  static const lightMuted = Color(0xFF64748B);
  static const lightBorder = Color(0x1A0F172A);
  static const lightCard = Color(0xCCFFFFFF);
  static const lightTile = Color(0xFFF1F5F9);
  static const lightTileBorder = Color(0x110F172A);
  static const lightDivider = Color(0x110F172A);

  // Dark mode
  static const darkBg = Color(0xFF0B1220);
  static const darkInk = Color(0xFFE5E7EB);
  static const darkMuted = Color(0xFF94A3B8);
  static const darkBorder = Color(0x1FFFFFFF);
  static const darkCard = Color(0xCC0F172A);
  static const darkTile = Color(0xFF111827);
  static const darkTileBorder = Color(0x22FFFFFF);
  static const darkDivider = Color(0x14FFFFFF);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.purple,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightInk,
      ),
      cardColor: AppColors.lightCard,
      dividerColor: AppColors.lightDivider,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.lightInk,
        elevation: 0,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.purple,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkInk,
      ),
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkDivider,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: AppColors.darkInk,
        elevation: 0,
      ),
    );
  }
}
