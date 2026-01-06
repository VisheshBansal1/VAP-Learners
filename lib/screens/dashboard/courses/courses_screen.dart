import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'course_detail_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final categories = ['All', 'Tech', 'Design', 'Growth'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 SEARCH
            TextField(
              onChanged: (v) => setState(() => searchQuery = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search courses...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🏷️ CATEGORIES
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final selected = cat == selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.deepPurpleAccent
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.white70,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            /// 📚 COURSES
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    FirebaseFirestore.instance.collection('courses').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  final filtered = snapshot.data!.docs.where((doc) {
                    final data = doc.data();
                    final title =
                        data['title'].toString().toLowerCase();
                    final category = data['category'];

                    return title.contains(searchQuery.toLowerCase()) &&
                        (selectedCategory == 'All' ||
                            category == selectedCategory);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "No courses found",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  return GridView.builder(
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final doc = filtered[index];
                      final data = doc.data();

                      return GestureDetector(
                        onTap: () async {
                          final uid =
                              FirebaseAuth.instance.currentUser!.uid;

                          /// 🔥 CREATE USER PROGRESS IF NOT EXISTS
                          final userCourseRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection('courses')
                              .doc(doc.id);

                          if (!(await userCourseRef.get()).exists) {
                            await userCourseRef.set({
                              'progress': 0,
                              'currentIndex': 0,
                              'completedLectures': [],
                              'startedAt':
                                  FieldValue.serverTimestamp(),
                              'lastAccessed':
                                  FieldValue.serverTimestamp(),
                            });
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailScreen(
                                courseId: doc.id,
                                course: data,
                              ),
                            ),
                          );
                        },
                        child: _CourseCard(data),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _CourseCard(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              data['thumbnail'],
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['instructor'],
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
