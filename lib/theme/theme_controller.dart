import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AppThemeMode { light, dark, system }

class ThemeController extends ChangeNotifier {
  static const _boxName = 'themeBox';
  static const _key = 'themeMode';

  late Box _box;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    final saved = _box.get(_key, defaultValue: 'system');
    _themeMode = _fromString(saved);
  }

  void setTheme(AppThemeMode mode) {
    _themeMode = _toThemeMode(mode);
    _box.put(_key, mode.name);
    notifyListeners();
  }

  AppThemeMode get current {
    if (_themeMode == ThemeMode.dark) return AppThemeMode.dark;
    if (_themeMode == ThemeMode.light) return AppThemeMode.light;
    return AppThemeMode.system;
  }

  ThemeMode _toThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
      default:
        return ThemeMode.system;
    }
  }

  ThemeMode _fromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
