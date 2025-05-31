import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../constants/themes.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final String _themeKey = 'isDarkMode';
  late Box _box;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;

  Future<void> _loadTheme() async {
    _box = await Hive.openBox('settings');
    _isDarkMode = _box.get(_themeKey, defaultValue: false) as bool;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _box.put(_themeKey, _isDarkMode);
    notifyListeners();
  }
}