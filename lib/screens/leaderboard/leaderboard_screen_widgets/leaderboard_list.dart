import 'package:flutter/material.dart';
import 'package:learnify/models/user.dart';
import 'leaderboard_tile.dart';

class LeaderboardList extends StatefulWidget {
  const LeaderboardList({super.key, required this.users});
  final List<AppUser> users;

  @override
  State<LeaderboardList> createState() => _LeaderboardListState();
}

class _LeaderboardListState extends State<LeaderboardList> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final users = widget.users;
    final canToggle = users.length > 4;
    final visible = !canToggle || showAll ? users.length : 4;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: visible,
            itemBuilder: (context, i) => LeaderboardTile(user: users[i]),
          ),
        ),
        if (canToggle)
          TextButton(
            onPressed: () => setState(() => showAll = !showAll),
            child: Text(
              showAll ? "Show less" : "Read more",
              style: const TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
