import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/dashboard/courses/course_detail_screen/course_discussion_tab.dart';
import 'package:learnify/screens/dashboard/courses/course_detail_screen/course_lessons_tab.dart';
import 'package:learnify/screens/dashboard/courses/course_detail_screen/course_notes_tab.dart';
import 'package:learnify/screens/dashboard/courses/course_detail_screen/course_quiz_tab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  final Map<String, dynamic> course;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
    required this.course,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late YoutubePlayerController _controller;
  late List<String> playlist;

  int currentIndex = 0;
  int selectedTabIndex = 0;

  final noteController = TextEditingController();
  final commentController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;
  final firestore = FirebaseFirestore.instance;

  /// Example quizzes (you can later move this to Firestore)
  final Map<int, List<Map<String, dynamic>>> quizzes = {
    0: [
      {
        'question': "Flutter is used for?",
        'options': ["Backend", "Mobile Apps", "Databases", "DevOps"],
        'answer': "Mobile Apps",
      },
    ],
    1: [
      {
        'question': "Flutter language?",
        'options': ["Java", "Kotlin", "Dart", "Swift"],
        'answer': "Dart",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    playlist = List<String>.from(widget.course['playlist']);

    _controller = YoutubePlayerController(
      initialVideoId: playlist.first,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );

    _loadProgress();
  }

  // ---------------- LOAD SAVED PROGRESS ----------------

  Future<void> _loadProgress() async {
    final doc = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('courses')
        .doc(widget.courseId)
        .get();

    if (doc.exists && doc.data() != null) {
      final index = doc.data()!['currentIndex'] ?? 0;

      setState(() => currentIndex = index);
      _controller.load(playlist[index]);
    }
  }

  // ---------------- SAVE PROGRESS ----------------

  Future<void> _saveProgress(int index) async {
    final progress = (((index + 1) / playlist.length) * 100).round();

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('courses')
        .doc(widget.courseId)
        .set({
          'progress': progress,
          'currentIndex': index,
          'lastAccessed': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  void playNextVideo(int index) {
    setState(() {
      currentIndex = index;
      _controller.load(playlist[index]);
    });
    _saveProgress(index);
  }

  // ---------------- TABS ----------------

  Widget _tabButton(String text, int index) {
    final active = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.deepPurpleAccent : Colors.white60,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _getTab() {
    switch (selectedTabIndex) {
      case 0:
        return CourseLessonsTab(
          playlist: playlist,
          currentIndex: currentIndex,
          onVideoSelected: playNextVideo,
        );

      case 1:
        return CourseNotesTab(
          courseId: widget.courseId,
          lessonIndex: currentIndex,
          controller: noteController,
        );

      case 2:
        return CourseQuizTab(
          courseId: widget.courseId,
          lessonIndex: currentIndex,
        );

      case 3:
        return CourseDiscussionTab(
          courseId: widget.courseId,
          controller: commentController,
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: MyColors.mainColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(widget.course['title']),
          ),
          body: Column(
            children: [
              AspectRatio(aspectRatio: 16 / 9, child: player),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "by ${widget.course['creator'] ?? 'Unknown'}",
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _tabButton("Lessons", 0),
                  _tabButton("Notes", 1),
                  _tabButton("Quiz", 2),
                  _tabButton("Discussion", 3),
                ],
              ),

              const Divider(color: Colors.white24),
              Expanded(child: _getTab()),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    noteController.dispose();
    commentController.dispose();
    super.dispose();
  }
}
