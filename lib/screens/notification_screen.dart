import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _EmptyNotificationState(),
        ],
      ),
    );
  }
}

/// 🔕 EMPTY STATE (when no notifications)
class _EmptyNotificationState extends StatelessWidget {
  const _EmptyNotificationState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 80),

        Icon(
          Icons.notifications_off_outlined,
          size: 80,
          color: isDark ? Colors.white30 : Colors.black26,
        ),

        const SizedBox(height: 20),

        Text(
          'No notifications yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'You’ll see updates about courses,\nstreaks, and achievements here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white38 : Colors.black54,
          ),
        ),
      ],
    );
  }
}
