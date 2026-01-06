import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/dashboard/ai_tutor/ai_tutor_screen.dart';
import 'package:learnify/screens/dashboard/courses/courses_screen.dart';
import 'package:learnify/screens/dashboard/home_screen/home_tab.dart';
import 'package:learnify/screens/leaderboard/leaderboard_screen.dart';
import 'package:learnify/screens/notification_screen.dart';
import 'package:learnify/screens/profile/profile_screen.dart';
import 'package:learnify/services/streak_service.dart';
import 'package:learnify/drawer/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  /// Run once on app open
  @override
  void initState() {
    super.initState();
    _initializeStreak();
  }

  Future<void> _initializeStreak() async {
    try {
      await StreakService().updateLoginStreak();
    } catch (e) {
      debugPrint('Streak update failed: $e');
    }
  }

  /// Navigation data (single source of truth)
  static const _navItems = [
    _NavItem(icon: Icons.home_outlined, label: 'Home'),
    _NavItem(icon: Icons.school_outlined, label: 'Courses'),
    _NavItem(icon: Icons.smart_toy_outlined, label: 'AI Tutor'),
    _NavItem(icon: Icons.leaderboard_outlined, label: 'Leaderboard'),
    _NavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  /// Screens (keep const where possible)
  final List<Widget> _screens = const [
    HomeTab(),
    CourseScreen(),
    AITutorScreen(),
    LeaderboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent accidental app exit
        return false;
      },
      child: Scaffold(
        backgroundColor: MyColors.mainColor,
        drawer: MyDrawer(),

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            _navItems[_selectedIndex].label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                );
              },
            ),
          ],
        ),

        body: SafeArea(child: _screens[_selectedIndex]),

        bottomNavigationBar: _BottomNavBar(
          currentIndex: _selectedIndex,
          items: _navItems,
          onTap: (index) {
            if (_selectedIndex == index) return;
            setState(() => _selectedIndex = index);
          },
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.deepPurpleAccent
                        : Colors.transparent,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.deepPurpleAccent.withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    items[index].icon,
                    color: isSelected ? Colors.white : Colors.white70,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  items[index].label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
