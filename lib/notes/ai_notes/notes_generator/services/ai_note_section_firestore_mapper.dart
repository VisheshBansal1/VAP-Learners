import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnify/notes/ai_notes/notes_generator/model/ai_note_section.dart';

class AiNoteSectionFirestoreMapper {
  // ================= LOCAL → FIRESTORE =================

  static Map<String, dynamic> toFirestore(AiNoteSection section) {
    return {
      'topic': section.topic,
      'content': section.content,
      'createdAt': Timestamp.fromDate(section.createdAt),
      'isDeleted': section.isDeleted,
    };
  }

  // ================= FIRESTORE → LOCAL =================

  static AiNoteSection fromFirestore({
    required String docId,
    required String noteId,
    required Map<String, dynamic> json,
  }) {
    final createdTs = json['createdAt'];

    final DateTime createdAt =
        createdTs is Timestamp ? createdTs.toDate() : DateTime.now();

    return AiNoteSection(
      id: docId,
      noteId: noteId,
      topic: (json['topic'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      createdAt: createdAt,
      isDeleted: json['isDeleted'] == true,
      isSynced: true, // cloud is authoritative
    );
  }
}
