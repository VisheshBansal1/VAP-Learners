import 'package:flutter/material.dart';
import 'package:learnify/models/achievement.dart';
import 'package:learnify/models/user.dart';
import 'package:learnify/screens/leaderboard/leaderboard_screen_widgets/achievements_section.dart';
import 'package:learnify/screens/leaderboard/leaderboard_screen_widgets/leaderboard_list.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color bgColor = const Color(0xFF1C1527);
  final Color cardColor = const Color(0xFF2B2140);

  final List<AppUser> globalUsers = [
    AppUser(
      name: "Vishesh",
      xp: 15420,
      rank: 1,
      avatarUrl: 'https://randomuser.me/api/portraits/men/68.jpg',
      trophyColor: const Color(0xFFFFD700),
    ),
    AppUser(
      name: "Ankush", 
      xp: 14980,
      rank: 2,
      avatarUrl: 'https://randomuser.me/api/portraits/men/65.jpg',
      trophyColor: const Color(0xFFC0C0C0),
    ),
    AppUser(
      name: "Mayank",
      xp: 14500,
      rank: 3,
      avatarUrl: 'https://randomuser.me/api/portraits/men/12.jpg',
      trophyColor: const Color(0xFFCD7F32),
    ),
    AppUser(
      name: "Harkrit",
      xp: 14210,
      rank: 4,
      avatarUrl: 'https://randomuser.me/api/portraits/women/41.jpg',
    ),
    AppUser(
      name: "Sonia",
      xp: 13995,
      rank: 5,
      avatarUrl: 'https://randomuser.me/api/portraits/women/25.jpg',
    ),
    AppUser(
      name: "Sonu",
      xp: 12095,
      rank: 6,
      avatarUrl: 'https://randomuser.me/api/portraits/men/35.jpg',
    ),
    AppUser(
      name: "Soni",
      xp: 11195,
      rank: 7,
      avatarUrl: 'https://randomuser.me/api/portraits/women/35.jpg',
    ),
  ];

  final List<Achievement> achievements = const [  
    Achievement(
      icon: Icons.local_fire_department_outlined,
      label: "7-Day Streak",
      active: true,
    ),
    Achievement(
      icon: Icons.school_outlined,
      label: "Quiz Master",
      active: true,
    ),
    Achievement(
      icon: Icons.emoji_events_outlined,
      label: "Top Learner",
      active: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // 🌟 Custom AppBar View (Header)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF301C50), Color(0xFF1C1527)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Leaderboard 🏆",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TabBar(
                    controller: _tabController,
                    indicator: const UnderlineTabIndicator(
                      borderSide:
                          BorderSide(width: 4, color: Colors.purpleAccent),
                      insets: EdgeInsets.symmetric(horizontal: 80),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Color(0xFF908CB0),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    tabs: const [
                      Tab(text: "Global"),
                      Tab(text: "Friends"),
                    ],
                  ),
                ],
              ),
            ),

            // 🧾 Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGlobalLeaderboard(),
                  const Center(
                    child: Text(
                      "Friends Tab Content Coming Soon 👥",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalLeaderboard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        children: [
          _buildTopThree(globalUsers.take(3).toList()),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: AchievementsSection(achievements: achievements),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: LeaderboardList(users: globalUsers),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThree(List<AppUser> topUsers) {
    if (topUsers.length < 3) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D1B4A), Color(0xFF1E1633)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTopUser(topUsers[1], 70, 2),
          _buildTopUser(topUsers[0], 90, 1),
          _buildTopUser(topUsers[2], 70, 3),
        ],
      ),
    );
  }

  Widget _buildTopUser(AppUser user, double size, int rank) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: user.trophyColor ?? Colors.grey,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: size / 2,
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          "${user.xp} XP",
          style: const TextStyle(
            color: Colors.purpleAccent,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: user.trophyColor?.withOpacity(0.2) ?? Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "#$rank",
            style: TextStyle(
              color: user.trophyColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
