import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseQuizTab extends StatelessWidget {
  final String courseId;
  final int lessonIndex;

  const CourseQuizTab({
    super.key,
    required this.courseId,
    required this.lessonIndex,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('quizzes')
          .doc(lessonIndex.toString())
          .collection('questions')
          .snapshots(),
      builder: (context, snapshot) {
        // 🔄 loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
          );
        }

        // ❌ no quiz
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No quiz available for this lesson",
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        final questions = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final data = questions[index].data();
            final options = List<String>.from(data['options']);
            final answer = data['answer'];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.deepPurpleAccent.withOpacity(0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['question'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...options.map((option) {
                    final correct = option == answer;

                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.circle_outlined,
                        color: Colors.white54,
                        size: 18,
                      ),
                      title: Text(
                        option,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              correct
                                  ? "✅ Correct answer"
                                  : "❌ Wrong answer",
                            ),
                            backgroundColor:
                                correct ? Colors.green : Colors.redAccent,
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
