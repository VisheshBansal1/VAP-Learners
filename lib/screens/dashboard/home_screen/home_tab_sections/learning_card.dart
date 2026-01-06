import 'package:flutter/material.dart';

class LearningCard extends StatelessWidget {
  final String title;
  final int progress;
  final String imageUrl;
  final VoidCallback onTap;

  const LearningCard({
    super.key,
    required this.title,
    required this.progress,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              /// COURSE TITLE
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 8),

              /// PROGRESS BAR
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 6,
                  backgroundColor: Colors.white24,
                  valueColor:
                      const AlwaysStoppedAnimation(Colors.greenAccent),
                ),
              ),

              const SizedBox(height: 4),
              Text(
                "$progress% completed",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
