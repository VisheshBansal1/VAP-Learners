import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnify/drawer/drawer_widget/header_section.dart';
import 'package:learnify/notes/ai_notes/notes_generator/services/notes_sync_service.dart';
import 'package:provider/provider.dart';

import 'package:learnify/auth/user/screens/login_screen.dart';
import 'package:learnify/screens/profile/profile_screen_widget/info_card.dart';
import 'package:learnify/screens/profile/profile_screen_widget/current_user_progress.dart';
import 'package:learnify/screens/profile/profile_screen_widget/menu_item_tile.dart';
import 'package:learnify/screens/profile/profile_screen_widget/logout_tile.dart';
import 'package:learnify/screens/profile/profile_screen_widget/language_screen.dart';
import 'package:learnify/screens/profile/profile_screen_widget/certificates_screen.dart';

import 'package:learnify/theme/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = context.watch<ThemeController>();

    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Profile not found"));
          }

          final data = snapshot.data!.data()!;

          final name = data['name'] ?? 'User';
          final email = data['email'] ?? user.email ?? '';
          final imagePath = data['profileImage'];
          final xp = data['xp'] ?? 0;
          final streak = data['streakCount'] ?? 0;
          final language = data['language'] ?? 'English';

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              /// 🔥 HEADER
              HeaderSection(
                name: name,
                email: email,
                imagePath: imagePath,
                onProfileUpdated: (n, e, img) async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({
                        'name': n,
                        'profileImage': img,
                        'updatedAt': FieldValue.serverTimestamp(),
                      });
                },
              ),

              const SizedBox(height: 20),

              /// 🔥 INFO CARDS
              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      icon: Icons.star,
                      label: "XP Points",
                      value: xp.toString(),
                      iconColor: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCard(
                      icon: Icons.local_fire_department,
                      label: "Streak",
                      value: "$streak Days",
                      iconColor: Colors.deepOrange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔥 PROGRESS
              const CurrentUserProgress(),

              const SizedBox(height: 30),

              /// 🔥 SETTINGS
              const Text(
                "Settings",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              /// 🎨 THEME (Hive)
              MenuItemTile(
                icon: Icons.palette,
                title: "Theme",
                trailingText: theme.current.name.toUpperCase(),
                onTap: () => _showThemeSheet(context),
              ),

              /// 🌐 LANGUAGE (Firestore)
              MenuItemTile(
                icon: Icons.language,
                title: "Language",
                trailingText: language,
                onTap: () async {
                  final selected = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LanguageScreen()),
                  );

                  if (selected != null) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .update({'language': selected});
                  }
                },
              ),

              /// 🎓 CERTIFICATES
              MenuItemTile(
                icon: Icons.card_membership,
                title: "My Certificates",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CertificatesScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              const SizedBox(height: 30),

              /// 🔥 NOTES SYNC
              const Text(
                "Notes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              /// ☁️ BACKUP NOTES
              MenuItemTile(
                icon: Icons.cloud_upload,
                title: "Backup notes to cloud",
                onTap: () async {
                  final confirm = await _confirmDialog(
                    context,
                    title: "Backup Notes",
                    message:
                        "This will upload all unsynced notes to the cloud. Continue?",
                  );

                  if (confirm) {
                    _showLoading(context);
                    try {
                      await NotesSyncService.backupToCloud();
                      Navigator.pop(context); // close loader
                      _showSnack(context, "Notes backed up successfully");
                    } catch (e) {
                      Navigator.pop(context);
                      _showSnack(context, "Backup failed");
                    }
                  }
                },
              ),

              /// 🔄 RESTORE NOTES
              MenuItemTile(
                icon: Icons.cloud_download,
                title: "Restore notes from cloud",
                onTap: () async {
                  final confirm = await _confirmDialog(
                    context,
                    title: "Restore Notes",
                    message:
                        "This will DELETE all local notes and restore from cloud. Continue?",
                  );

                  if (confirm) {
                    _showLoading(context);
                    try {
                      await NotesSyncService.restoreFromCloud();
                      Navigator.pop(context);
                      _showSnack(context, "Notes restored successfully");
                    } catch (e) {
                      Navigator.pop(context);
                      _showSnack(context, "Restore failed");
                    }
                  }
                },
              ),

              /// 🚪 LOGOUT
              LogoutTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const UserLoginScreen()),
                    (_) => false,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // ---------------- THEME CHOOSER ----------------

  void _showThemeSheet(BuildContext context) {
    final theme = context.read<ThemeController>();

    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: AppThemeMode.values.map((mode) {
          return RadioListTile<AppThemeMode>(
            title: Text(mode.name.toUpperCase()),
            value: mode,
            groupValue: theme.current,
            onChanged: (val) {
              if (val != null) {
                theme.setTheme(val);
                Navigator.pop(context);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

Future<bool> _confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Continue"),
            ),
          ],
        ),
      ) ??
      false;
}

void _showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
