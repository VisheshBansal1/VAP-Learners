import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildTopSection(BuildContext context) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final user = auth.currentUser;

  // ---- NOT LOGGED IN ----
  if (user == null) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Hello, Guest!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---- USER STREAM ----
  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    stream: firestore.collection('users').doc(user.uid).snapshots(),
    builder: (context, snapshot) {
      // ---- LOADING ----
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(radius: 22, backgroundColor: Colors.grey),
              SizedBox(width: 12),
              Text(
                'Loading...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        );
      }

      // ---- NO DATA ----
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Hello, User!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }

      final data = snapshot.data!.data()!;
      final String name = data['name'] ?? 'User';
      final String? imagePath = data['profileImage'];

      ImageProvider avatarImage;

      // ---- IMAGE DECISION (SAFE) ----
      if (imagePath != null && imagePath.isNotEmpty) {
        if (imagePath.startsWith('http')) {
          avatarImage = NetworkImage(imagePath);
        } else {
          avatarImage = FileImage(File(imagePath));
        }
      } else {
        avatarImage = const NetworkImage(
          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade800,
              backgroundImage: avatarImage,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Hello, ${name.split(' ').first}!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
