import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learnify/auth/user/screens/login_screen.dart';

class Section3 extends StatefulWidget {
  const Section3({super.key});

  @override
  State<Section3> createState() => _Section3State();
}

class _Section3State extends State<Section3> {
  Future<void> _signOut(BuildContext context) async {
    try {
      // 🔹 Always sign out from Firebase first
      await FirebaseAuth.instance.signOut();

      // 🔹 Try signing out from Google, but ignore if not signed in via Google
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        try {
          await googleSignIn.signOut();
          await googleSignIn.disconnect();
        } catch (e) {
          debugPrint('⚠ Google sign-out skipped: $e');
        }
      }

      // 🔹 Navigate back to login screen no matter what
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const UserLoginScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.logout_outlined),
          title: Text('Log Out'),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          onTap: () {
            _signOut(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return UserLoginScreen();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}