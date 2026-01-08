import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnify/notes/normal_notes/models/note_section.dart';

class NoteSectionFirestoreMapper {
  // ================= LOCAL → FIRESTORE =================

  static Map<String, dynamic> toFirestore(NoteSection section) {
    return {
      'noteId': section.noteId,
      'topic': section.topic,
      'content': section.content,
      'createdAt': Timestamp.fromDate(section.createdAt),
      'isDeleted': section.isDeleted,
    };
  }

  // ================= FIRESTORE → LOCAL =================

  static NoteSection fromFirestore({
    required String docId,
    required String noteId,
    required Map<String, dynamic> json,
  }) {
    final createdTs = json['createdAt'];

    final DateTime createdAt =
        createdTs is Timestamp ? createdTs.toDate() : DateTime.now();

    return NoteSection(
      id: docId,
      noteId: noteId,
      topic: (json['topic'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      createdAt: createdAt,
      isDeleted: json['isDeleted'] == true,
      isSynced: true,
    );
  }
}
