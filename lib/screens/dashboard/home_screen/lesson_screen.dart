import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  final String courseId;

  const LessonScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E1A),
      appBar: AppBar(
        title: const Text('Course'),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('courses')
            .doc(courseId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Course not found',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          final data = snapshot.data!.data()!;
          final progress = data['progress'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Progress: $progress%",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () async {
                    final newProgress = (progress + 10).clamp(0, 100);

                    await snapshot.data!.reference.update({
                      'progress': newProgress,
                      'updatedAt': FieldValue.serverTimestamp(),
                      'lastAccessed': FieldValue.serverTimestamp(),
                    });
                  },
                  child: const Text("Complete Lesson"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
