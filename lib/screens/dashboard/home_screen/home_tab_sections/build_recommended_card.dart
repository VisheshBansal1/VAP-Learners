import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recommended for you",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('recommendedCourses')
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              // ⏳ Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }

              // ❌ Empty
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text(
                  "No recommendations yet",
                  style: TextStyle(color: Colors.white54),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RecommendedCard(
                      tag: data['tag'] ?? 'COURSE',
                      tagColor: Color(data['tagColor'] ?? 0xFF6C63FF),
                      title: data['title'] ?? 'Untitled',
                      subtitle: data['subtitle'] ?? '',
                      backgroundColor:
                          Color(data['bgColor'] ?? 0xFF1C1A2E),
                      imagePlaceholderColor:
                          Color(data['imageColor'] ?? 0xFF3A3A5A),
                      onTap: () {
                        // 👉 You can navigate to course preview / enroll screen here
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecommendedCard extends StatelessWidget {
  final String tag;
  final Color tagColor;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color imagePlaceholderColor;
  final VoidCallback onTap;

  const RecommendedCard({
    super.key,
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.imagePlaceholderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: imagePlaceholderColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.book_rounded,
                color: Colors.white70,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white30,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
