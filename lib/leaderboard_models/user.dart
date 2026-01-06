import 'package:flutter/material.dart';

class User {
  final String name;
  final int xp;
  final int rank;
  final String avatarUrl;
  final Color trophyColor;

  const User({
    required this.name,
    required this.xp,
    required this.rank,
    required this.avatarUrl,
    this.trophyColor = Colors.transparent,
  });
}
