import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AppThemeMode { light, dark, system }

class ThemeController extends ChangeNotifier {
  static const String _boxName = 'themeBox';
  static const String _key = 'themeMode';

  late Box<int> _box;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // ================= INIT =================

  Future<void> init() async {
    _box = await Hive.openBox<int>(_boxName);

    final storedIndex = _box.get(_key);
    _themeMode = _mapStoredValue(storedIndex);

    // 🔥 IMPORTANT: update UI on app start
    notifyListeners();
  }

  // ================= SET THEME =================

  void setTheme(AppThemeMode mode) {
    if (!_box.isOpen) return; // safety guard

    _themeMode = _mapToThemeMode(mode);
    _box.put(_key, mode.index); // storing enum index

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

  ThemeMode _mapStoredValue(int? index) {
    if (index != null &&
        index >= 0 &&
        index < AppThemeMode.values.length) {
      return _mapToThemeMode(AppThemeMode.values[index]);
    }
    return ThemeMode.system; // safe fallback
  }
}
