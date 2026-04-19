import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = 'dark_mode';

  bool _darkMode = false;

  bool get darkMode => _darkMode;

  ThemeProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }

  // ── Theme tokens (used by screens that still read ThemeProvider directly) ──

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
