import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF6C63FF);
  static const _darkBg = Color(0xFF151022);

  // ================= LIGHT THEME =================

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.light(
      primary: _primary,
      secondary: _primary.withOpacity(0.8),
      surface: Colors.white,
      background: Colors.white,
      onPrimary: Colors.white,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
    ),

    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1E1A2E),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(_primary),
      trackColor: MaterialStateProperty.all(_primary.withOpacity(0.4)),
    ),
  );

  // ================= DARK THEME =================

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.dark(
      primary: _primary,
      secondary: _primary.withOpacity(0.8),
      background: _darkBg,
      surface: const Color(0xFF1E1A2E),
      onPrimary: Colors.white,
      onSurface: Colors.white70,
      onBackground: Colors.white70,
    ),

    scaffoldBackgroundColor: _darkBg,

    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBg,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1E1A2E),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1A2E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(_primary),
      trackColor: MaterialStateProperty.all(_primary.withOpacity(0.4)),
    ),
  );
}
