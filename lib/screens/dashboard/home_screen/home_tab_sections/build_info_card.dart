import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnify/screens/profile/profile_screen_widget/info_card.dart';

/// ================= MAIN WIDGET =================

Widget buildInfoCards() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text("Not logged in", style: TextStyle(color: Colors.white)),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        Expanded(child: _learningStreakCard(user.uid)),
        const SizedBox(width: 12),
        Expanded(child: _ongoingCoursesCard(user.uid)),
      ],
    ),
  );
}

/// ================= LEARNING STREAK =================

Widget _learningStreakCard(String uid) {
  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const InfoCard(
          icon: Icons.local_fire_department,
          label: "Learning Streak",
          value: "...",
          iconColor: Colors.deepOrange,
        );
      }

      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const InfoCard(
          icon: Icons.local_fire_department,
          label: "Learning Streak",
          value: "0 Days",
          iconColor: Colors.deepOrange,
        );
      }

      final data = snapshot.data!.data()!;
      final int streakCount = (data['streakCount'] ?? 0) as int;

      return InfoCard(
        icon: Icons.local_fire_department,
        label: "Learning Streak",
        value: "$streakCount Days",
        iconColor: Colors.deepOrange,
      );
    },
  );
}

/// ================= ONGOING COURSES (REAL LOGIC) =================
/// Counts only ACTIVE enrollments
/// Video clicks WILL NOT affect this
Widget _ongoingCoursesCard(String uid) {
  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('courses')
        .where('progress', isLessThan: 100)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const InfoCard(
          icon: Icons.school_rounded,
          label: "Ongoing Courses",
          value: "...",
          iconColor: Colors.blueAccent,
        );
      }

      if (snapshot.hasError) {
        return const InfoCard(
          icon: Icons.school_rounded,
          label: "Ongoing Courses",
          value: "0",
          iconColor: Colors.blueAccent,
        );
      }

      final int ongoingCourses = snapshot.data?.docs.length ?? 0;

      return InfoCard(
        icon: Icons.school_rounded,
        label: "Ongoing Courses",
        value: ongoingCourses.toString(),
        iconColor: Colors.blueAccent,
      );
    },
  );
}
