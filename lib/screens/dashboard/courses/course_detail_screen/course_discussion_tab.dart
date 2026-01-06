import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseDiscussionTab extends StatelessWidget {
  final String courseId;
  final TextEditingController controller;

  const CourseDiscussionTab({
    super.key,
    required this.courseId,
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
                .collection('courses')
                .doc(courseId)
                .collection('discussions')
                .orderBy('createdAt')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No discussions yet",
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  return ListTile(
                    title: Text(
                      doc['message'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),

        /// ADD COMMENT
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Ask something...",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  if (controller.text.trim().isEmpty) return;

                  await FirebaseFirestore.instance
                      .collection('courses')
                      .doc(courseId)
                      .collection('discussions')
                      .add({
                    'uid': uid,
                    'message': controller.text.trim(),
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
