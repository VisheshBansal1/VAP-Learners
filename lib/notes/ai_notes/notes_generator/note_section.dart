import 'package:cloud_firestore/cloud_firestore.dart';

class NoteSection {
  final String sectionId;
  final String topic;
  final String content;
  final String source;
  final DateTime createdAt;

  NoteSection({
    required this.sectionId,
    required this.topic,
    required this.content,
    required this.source,
    required this.createdAt,
  });

  factory NoteSection.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) {
    return NoteSection(
      sectionId: docId,
      topic: json['topic'],
      content: json['content'],
      source: json['source'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
