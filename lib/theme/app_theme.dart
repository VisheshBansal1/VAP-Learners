import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF151022),
    primaryColor: const Color(0xFF6C63FF),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
    ),
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xFF6C63FF),
  );
}
