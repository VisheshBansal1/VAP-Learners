import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/drawer/drawer_widget/header_section.dart';
import 'package:learnify/drawer/drawer_widget/section1.dart';
import 'package:learnify/drawer/drawer_widget/section2.dart';
import 'package:learnify/drawer/drawer_widget/section3.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String name = '';
  String email = '';
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        name = data['name'] ?? 'No Name';
        email = user.email ?? 'No Email';
        imagePath = data['profileImage'];
      });
    } else {
      // If no user document, create a new one
      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? 'New User',
        'email': user.email,
        'profileImage': null,
      });
      _loadUserData();
    }
  }

  void updateProfile(String newName, String newEmail, String? newImage) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'name': newName,
      'profileImage': newImage,
    });

    setState(() {
      name = newName;
      // email = user.email ?? newEmail;
      imagePath = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [MyColors.mainColor, Colors.blueGrey, Colors.black38],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: ListView(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                ),
                HeaderSection(
                  name: name.isEmpty ? 'Loading...' : name,
                  email: email.isEmpty ? 'Loading...' : email,
                  imagePath: imagePath,
                  onProfileUpdated: updateProfile,
                ),
                const SizedBox(height: 20),
                const Section1(),
                const Divider(color: Colors.white, indent: 20, endIndent: 20),
                const Section2(),
                const Divider(color: Colors.white, indent: 20, endIndent: 20),
                const Section3(),
                const Divider(color: Colors.white, indent: 20, endIndent: 20),
                const SizedBox(height: 10),
                const Center(child: Text('App Version: 0.0.1')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
