import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnify/notes/ai_notes/notes_generator/model/data_model.dart';
import 'package:learnify/notes/ai_notes/notes_generator/note_section.dart';

class NotesFirestoreService {
  static FirebaseFirestore get _db => FirebaseFirestore.instance;

  static String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return user.uid;
  }

  // ================= CREATE NOTE =================

  static Future<String> createNote(String title) async {
    final doc = await _db
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .add({
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  // ================= RENAME NOTE =================

  static Future<void> renameNote({
    required String noteId,
    required String newTitle,
  }) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .doc(noteId)
        .update({
      'title': newTitle,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= ADD SECTION =================

  static Future<void> addSection({
    required String noteId,
    required String topic,
    required String content,
  }) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .doc(noteId)
        .collection('sections')
        .add({
      'topic': topic,
      'content': content,
      'source': 'groq',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _db
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .doc(noteId)
        .update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= DELETE SECTION =================

  static Future<void> deleteSection({
    required String noteId,
    required String sectionId,
  }) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .doc(noteId)
        .collection('sections')
        .doc(sectionId)
        .delete();
  }

  // ================= STREAM NOTES =================

  static Stream<List<NoteModel>> notesStream() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => NoteModel.fromFirestore(d.data(), d.id))
              .toList(),
        );
  }

  // ================= STREAM SECTIONS =================

  static Stream<List<NoteSection>> sectionsStream(String noteId) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .doc(noteId)
        .collection('sections')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => NoteSection.fromFirestore(d.data(), d.id))
              .toList(),
        );
  }
}
