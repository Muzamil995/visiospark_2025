import 'package:flutter/material.dart';
import '../core/constants/constants.dart';
import '../services/cache_service.dart';
import '../core/utils/logger.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    AppLogger.debug('Loading saved theme');
    final savedTheme = CacheService.getString(AppConstants.themeKey);
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
      AppLogger.info('Theme loaded: $_themeMode');
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    AppLogger.info('Setting theme: $mode');
    _themeMode = mode;
    await CacheService.setString(AppConstants.themeKey, mode.name);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}
