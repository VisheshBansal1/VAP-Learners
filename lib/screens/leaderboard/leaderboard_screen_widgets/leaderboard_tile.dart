import 'package:flutter/material.dart';
import 'package:learnify/models/user.dart';
import 'package:learnify/utils/format.dart';

class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({super.key, required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final isTop3 = user.rank <= 3;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 9),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2340),
        borderRadius: BorderRadius.circular(30),
        boxShadow: isTop3
            ? [
                BoxShadow(
                  color: user.trophyColor.withOpacity(0.7),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(user.avatarUrl),
                backgroundColor: Colors.grey.shade300,
              ),
              if (isTop3)
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: CircleAvatar(
                    backgroundColor: user.trophyColor,
                    radius: 12,
                    child: const Icon(
                      Icons.emoji_events_outlined,
                      size: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${fmtXp(user.xp)} XP",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            user.rank.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}