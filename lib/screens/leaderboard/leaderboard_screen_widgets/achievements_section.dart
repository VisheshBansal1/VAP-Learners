import 'package:flutter/material.dart';
import 'package:learnify/models/achievement.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key, required this.achievements});
  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Achievements",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: achievements
              .map(
                (a) => Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: a.active
                          ? Colors.deepPurple
                          : Colors.grey.shade700,
                      radius: 28,
                      child: Icon(
                        a.icon,
                        size: 28,
                        color: a.active ? Colors.purpleAccent : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      a.label,
                      style: TextStyle(
                        color: a.active ? Colors.white : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}