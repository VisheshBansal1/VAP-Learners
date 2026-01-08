import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../model/note.dart';
import '../model/note_section_model.dart';
import '../services/note_firestore_mapper.dart';
import '../services/note_section_firestore_mapper.dart';

class NotesSyncService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ================= BACKUP (LOCAL → CLOUD) =================

  static Future<void> backupToCloud() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final Box<Note> notesBox = Hive.box<Note>('notesBox');
    final Box<NoteSection> sectionsBox =
        Hive.box<NoteSection>('sectionsBox');

    // 🔹 Backup NOTES
    for (final note in notesBox.values.where((n) => !n.isSynced)) {
      final noteRef = _db
          .collection('users')
          .doc(user.uid)
          .collection('notes')
          .doc(note.id);

      await noteRef.set(
        NoteFirestoreMapper.toFirestore(note),
        SetOptions(merge: true),
      );

      note.isSynced = true;
      await note.save();
    }

    // 🔹 Backup SECTIONS
    for (final section
        in sectionsBox.values.where((s) => !s.isSynced)) {
      final sectionRef = _db
          .collection('users')
          .doc(user.uid)
          .collection('notes')
          .doc(section.noteId)
          .collection('sections')
          .doc(section.id);

      await sectionRef.set(
        NoteSectionFirestoreMapper.toFirestore(section),
        SetOptions(merge: true),
      );

      section.isSynced = true;
      await section.save();
    }
  }

  // ================= RESTORE (CLOUD → LOCAL) =================

  static Future<void> restoreFromCloud() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final Box<Note> notesBox = Hive.box<Note>('notesBox');
    final Box<NoteSection> sectionsBox =
        Hive.box<NoteSection>('sectionsBox');

    // ⚠️ Destructive restore (intentional)
    await notesBox.clear();
    await sectionsBox.clear();

    final notesSnap = await _db
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .get();

    for (final noteDoc in notesSnap.docs) {
      final data = noteDoc.data();

      final note = Note(
        id: noteDoc.id,
        userId: user.uid,
        title: data['title'] ?? '',
        createdAt: data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate()
            : DateTime.now(),
        updatedAt: data['updatedAt'] != null
            ? (data['updatedAt'] as Timestamp).toDate()
            : DateTime.now(),
        isSynced: true,
      );

      await notesBox.put(note.id, note);

      final sectionsSnap =
          await noteDoc.reference.collection('sections').get();

      for (final sectionDoc in sectionsSnap.docs) {
        final s = sectionDoc.data();

        final section = NoteSection(
          id: sectionDoc.id,
          noteId: note.id,
          topic: s['topic'] ?? '',
          content: s['content'] ?? '',
          createdAt: s['createdAt'] != null
              ? (s['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
          isSynced: true,
        );

        await sectionsBox.put(section.id, section);
      }
    }
  }
}
