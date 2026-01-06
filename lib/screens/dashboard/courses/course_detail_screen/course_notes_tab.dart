import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseNotesTab extends StatelessWidget {
  final String courseId;
  final int lessonIndex;
  final TextEditingController controller;

  const CourseNotesTab({
    super.key,
    required this.courseId,
    required this.lessonIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('courseNotes')
                .where('courseId', isEqualTo: courseId)
                .where('lessonIndex', isEqualTo: lessonIndex)
                .orderBy('createdAt')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No notes yet",
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  return ListTile(
                    title: Text(
                      doc['text'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),

        /// ADD NOTE
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Write a note...",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  if (controller.text.trim().isEmpty) return;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('courseNotes')
                      .add({
                    'courseId': courseId,
                    'lessonIndex': lessonIndex,
                    'text': controller.text.trim(),
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  controller.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
