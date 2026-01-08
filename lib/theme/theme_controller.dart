import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AppThemeMode { light, dark, system }

class ThemeController extends ChangeNotifier {
  static const _boxName = 'themeBox';
  static const _key = 'themeMode';

  late final Box _box;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // ================= INIT =================

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);

    final stored = _box.get(_key);
    _themeMode = _mapStoredValue(stored);
  }

  // ================= SET THEME =================

  void setTheme(AppThemeMode mode) {
    _themeMode = _mapToThemeMode(mode);
    _box.put(_key, mode.index); // 🔥 store enum index
    notifyListeners();
  }

  // ================= CURRENT MODE =================

  AppThemeMode get current {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
      case ThemeMode.system:
      default:
        return AppThemeMode.system;
    }
  }

  // ================= INTERNAL MAPPERS =================

  ThemeMode _mapToThemeMode(AppThemeMode mode) {
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

  ThemeMode _mapStoredValue(dynamic value) {
    if (value is int &&
        value >= 0 &&
        value < AppThemeMode.values.length) {
      return _mapToThemeMode(AppThemeMode.values[value]);
    }
    return ThemeMode.system; // safe fallback
  }
}
