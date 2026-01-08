import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteFirestoreMapper {
  // ================= LOCAL → FIRESTORE =================

  static Map<String, dynamic> toFirestore(Note note) {
    return {
      'userId': note.userId,
      'title': note.title,
      'contentJson': note.contentJson, // store as-is
      'createdAt': Timestamp.fromDate(note.createdAt),
      'updatedAt': Timestamp.fromDate(note.updatedAt),
      'tags': note.tags,
      'isDeleted': note.isDeleted,
    };
  }

  // ================= FIRESTORE → LOCAL =================

  static Note fromFirestore({
    required String docId,
    required String userId,
    required Map<String, dynamic> json,
  }) {
    final createdTs = json['createdAt'];
    final updatedTs = json['updatedAt'];

    final DateTime createdAt =
        createdTs is Timestamp ? createdTs.toDate() : DateTime.now();

    final DateTime updatedAt =
        updatedTs is Timestamp ? updatedTs.toDate() : createdAt;

    final List<String> tags = (json['tags'] is List)
        ? (json['tags'] as List)
            .whereType<String>()
            .toSet() // prevent duplicates
            .toList()
        : <String>[];

    return Note(
      id: docId,
      userId: userId,
      title: (json['title'] ?? '').toString(),
      contentJson: json['contentJson'] ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags,
      isDeleted: json['isDeleted'] == true,
      isSynced: true, // cloud always authoritative
    );
  }
}
