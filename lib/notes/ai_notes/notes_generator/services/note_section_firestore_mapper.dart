import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnify/notes/ai_notes/notes_generator/model/note_section_model.dart';

class NoteSectionFirestoreMapper {
  static Map<String, dynamic> toFirestore(NoteSection section) {
    return {
      'topic': section.topic,
      'content': section.content,
      'createdAt': Timestamp.fromDate(section.createdAt),
    };
  }

  static NoteSection fromFirestore({
    required String docId,
    required String noteId,
    required Map<String, dynamic> json,
  }) {
    return NoteSection(
      id: docId,
      noteId: noteId,
      topic: json['topic'] ?? '',
      content: json['content'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      isSynced: true, // restored from cloud
    );
  }
}
