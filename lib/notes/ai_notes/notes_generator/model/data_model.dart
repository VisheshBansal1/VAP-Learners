import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String noteId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteModel({
    required this.noteId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Firestore → Model
  factory NoteModel.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) {
    return NoteModel(
      noteId: docId,
      title: json['title'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Model → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
