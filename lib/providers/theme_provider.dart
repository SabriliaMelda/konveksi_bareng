// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  // ===== Theme tokens =====
  Color get bg => _darkMode ? const Color(0xFF0F172A) : const Color(0xFFF7F7FB);

  Color get ink =>
      _darkMode ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);

  Color get muted =>
      _darkMode ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

  Color get border =>
      _darkMode ? const Color(0xFF1E293B) : const Color(0xFFE8ECF4);

  Color get card => _darkMode ? const Color(0xFF1E293B) : Colors.white;

  Color get tile =>
      _darkMode ? const Color(0xFF0F172A) : const Color(0xFFF3E8FF);

  Color get tileBorder =>
      _darkMode ? const Color(0xFF334155) : const Color(0xFFE8ECF4);

  Color get iconSurface => _darkMode ? const Color(0xFF1E293B) : Colors.white;
}
