import 'package:flutter/material.dart';

class AppTheme {
  // ================= COLORS =================

  // Primary (calm, premium, not flashy)
  static const Color _primary = Color(0xFF4F46E5); // Indigo
  static const Color _primarySoft = Color(0xFF6366F1);

  // Light theme
  static const Color _lightBg = Color(0xFFF9FAFB);
  static const Color _lightSurface = Colors.white;
  static const Color _lightText = Color(0xFF111827);

  // Dark theme
  static const Color _darkBg = Color(0xFF0F172A);
  static const Color _darkSurface = Color(0xFF1E293B);
  static const Color _darkText = Colors.white70;

  // ================= LIGHT THEME =================

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: _primary,
      secondary: _primarySoft,
      background: _lightBg,
      surface: _lightSurface,
      onPrimary: Colors.white,
      onBackground: _lightText,
      onSurface: _lightText,
    ),

    scaffoldBackgroundColor: _lightBg,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: _lightText,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: _lightSurface,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(_primary),
      trackColor: MaterialStateProperty.all(_primary.withOpacity(0.35)),
    ),
  );

  // ================= DARK THEME =================

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: _primarySoft,
      secondary: _primary,
      background: _darkBg,
      surface: _darkSurface,
      onPrimary: Colors.white,
      onBackground: _darkText,
      onSurface: _darkText,
    ),

    scaffoldBackgroundColor: _darkBg,

    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBg,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: _darkSurface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primarySoft,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primarySoft,
      foregroundColor: Colors.white,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(_primarySoft),
      trackColor: MaterialStateProperty.all(_primarySoft.withOpacity(0.4)),
    ),
  );
}
