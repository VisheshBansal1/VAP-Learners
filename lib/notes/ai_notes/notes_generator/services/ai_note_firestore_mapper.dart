import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnify/notes/ai_notes/notes_generator/model/ai_note.dart';

class AiNoteFirestoreMapper {
  // ================= LOCAL → FIRESTORE =================

  static Map<String, dynamic> toFirestore(AiNote note) {
    return {
      'title': note.title,
      'createdAt': Timestamp.fromDate(note.createdAt),
      'updatedAt': Timestamp.fromDate(note.updatedAt),
      'isDeleted': note.isDeleted,
    };
  }

  // ================= FIRESTORE → LOCAL =================

  static AiNote fromFirestore({
    required String docId,
    required String userId,
    required Map<String, dynamic> json,
  }) {
    final Timestamp? createdTs = json['createdAt'] as Timestamp?;
    final Timestamp? updatedTs = json['updatedAt'] as Timestamp?;

    return AiNote(
      id: docId,
      userId: userId,
      title: (json['title'] ?? '').toString(),
      createdAt: createdTs?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: updatedTs?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isDeleted: json['isDeleted'] == true,
      isSynced: true,
    );
  }
}
