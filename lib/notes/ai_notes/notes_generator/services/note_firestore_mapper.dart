import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnify/notes/ai_notes/notes_generator/model/note.dart';

class NoteFirestoreMapper {
  static Map<String, dynamic> toFirestore(Note note) {
    return {
      'title': note.title,
      'createdAt': Timestamp.fromDate(note.createdAt),
      'updatedAt': Timestamp.fromDate(note.updatedAt),
    };
  }

  static Note fromFirestore({
    required String docId,
    required String userId,
    required Map<String, dynamic> json,
  }) {
    return Note(
      id: docId,
      userId: userId,
      title: json['title'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      isSynced: true, // cloud data is already synced
    );
  }
}
