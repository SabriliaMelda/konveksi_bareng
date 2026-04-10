import 'package:flutter/material.dart';
import '../config/app_theme.dart';

enum FontSizeOption { small, medium, large }

class ThemeProvider extends ChangeNotifier {
  FontSizeOption _fontSize = FontSizeOption.medium;
  bool _darkMode = false;

  FontSizeOption get fontSize => _fontSize;
  bool get darkMode => _darkMode;

  double get fontScale {
    switch (_fontSize) {
      case FontSizeOption.small:
        return 0.9;
      case FontSizeOption.large:
        return 1.1;
      case FontSizeOption.medium:
        return 1.0;
    }
  }

  // Shortcut warna berdasarkan mode aktif
  Color get bg => _darkMode ? AppColors.darkBg : AppColors.lightBg;
  Color get ink => _darkMode ? AppColors.darkInk : AppColors.lightInk;
  Color get muted => _darkMode ? AppColors.darkMuted : AppColors.lightMuted;
  Color get border => _darkMode ? AppColors.darkBorder : AppColors.lightBorder;
  Color get card => _darkMode ? AppColors.darkCard : AppColors.lightCard;
  Color get tile => _darkMode ? AppColors.darkTile : AppColors.lightTile;
  Color get tileBorder =>
      _darkMode ? AppColors.darkTileBorder : AppColors.lightTileBorder;
  Color get divider =>
      _darkMode ? AppColors.darkDivider : AppColors.lightDivider;
  Color get iconSurface =>
      _darkMode ? const Color(0xFF0F172A) : Colors.white;
  Color get primary => AppColors.purple;

  void setFontSize(FontSizeOption size) {
    _fontSize = size;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}
