import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum AppTheme { system, light, dark }

class ThemeService extends ChangeNotifier {
  final _box = Hive.box('settings');
  static const _key = 'app_theme';

  AppTheme get theme {
    final value = _box.get(_key, defaultValue: AppTheme.system.name);
    return AppTheme.values.firstWhere((e) => e.name == value);
  }

  ThemeMode get themeMode {
    switch (theme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
      default:
        return ThemeMode.system;
    }
  }

  void setTheme(AppTheme theme) {
    _box.put(_key, theme.name);
    notifyListeners();
  }
}
