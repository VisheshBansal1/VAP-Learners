import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NotesFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _notesRef =>
      _firestore
          .collection('users')
          .doc(uid)
          .collection('notes');

  // ================= READ (REAL-TIME) =================

  Stream<List<Note>> fetchNotes() {
    return _notesRef
        .orderBy('dateModified', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Note.fromJson(
              doc.data(),
              doc.id,
            );
          }).toList();
        });
  }

  // ================= CREATE =================

  Future<void> addNote(Note note) async {
    await _notesRef.add(note.toJson());
  }

  // ================= UPDATE =================

  Future<void> updateNote(Note note) async {
    if (note.id.isEmpty) {
      throw Exception('Cannot update note without id');
    }

    await _notesRef.doc(note.id).update(note.toJson());
  }

  // ================= DELETE =================

  Future<void> deleteNote(String id) async {
    await _notesRef.doc(id).delete();
  }
}
