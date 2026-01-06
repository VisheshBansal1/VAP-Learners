import 'package:flutter/material.dart';

class Achievement {
  final IconData icon;
  final String label;
  final bool active;

  const Achievement({
    required this.icon,
    required this.label,
    this.active = false,
  });
}
