import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:learnify/notes/ai_notes/notes_generator/services/ai_note_section_firestore_mapper.dart';

import '../model/ai_note.dart';
import '../model/ai_note_section.dart';
import '../services/ai_note_firestore_mapper.dart';

class AiNotesSyncService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const int _batchLimit = 400;

  static String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    return user.uid;
  }

  // ================= PUSH LOCAL → CLOUD =================

  static Future<void> backupToCloud() async {
    final aiNotesBox = Hive.box<AiNote>('aiNotesBox');
    final sectionsBox = Hive.box<AiNoteSection>('sectionsBox');

    final notes =
        aiNotesBox.values.where((n) => !n.isSynced).toList();

    final sections = sectionsBox.values
        .where(
          (s) =>
              !s.isSynced &&
              aiNotesBox.containsKey(s.noteId),
        )
        .toList();

    for (int i = 0;
        i < notes.length || i < sections.length;
        i += _batchLimit) {
      final batch = _db.batch();

      final noteChunk = notes.skip(i).take(_batchLimit);
      final sectionChunk = sections.skip(i).take(_batchLimit);

      // -------- NOTES --------
      for (final note in noteChunk) {
        final ref = _db
            .collection('users')
            .doc(_uid)
            .collection('ai_notes')
            .doc(note.id);

        if (note.isDeleted) {
          batch.delete(ref);
        } else {
          batch.set(
            ref,
            AiNoteFirestoreMapper.toFirestore(note),
            SetOptions(merge: true),
          );
        }
      }

      // -------- SECTIONS --------
      for (final section in sectionChunk) {
        final ref = _db
            .collection('users')
            .doc(_uid)
            .collection('ai_notes')
            .doc(section.noteId)
            .collection('sections')
            .doc(section.id);

        if (section.isDeleted) {
          batch.delete(ref);
        } else {
          batch.set(
            ref,
            AiNoteSectionFirestoreMapper.toFirestore(section),
            SetOptions(merge: true),
          );
        }
      }

      await batch.commit();

      // -------- MARK SYNCED --------
      for (final note in noteChunk) {
        note.isSynced = true;
        note.isDeleted
            ? await note.delete()
            : await note.save();
      }

      for (final section in sectionChunk) {
        section.isSynced = true;
        section.isDeleted
            ? await section.delete()
            : await section.save();
      }
    }
  }

  // ================= PULL CLOUD → LOCAL =================

  static Future<void> restoreFromCloud() async {
    final aiNotesBox = Hive.box<AiNote>('aiNotesBox');
    final sectionsBox = Hive.box<AiNoteSection>('sectionsBox');

    final notesSnap = await _db
        .collection('users')
        .doc(_uid)
        .collection('ai_notes')
        .get();

    for (final noteDoc in notesSnap.docs) {
      final remoteNote = AiNoteFirestoreMapper.fromFirestore(
        docId: noteDoc.id,
        userId: _uid,
        json: noteDoc.data(),
      );

      final localNote = aiNotesBox.get(remoteNote.id);

      // ✅ Notes: latest updatedAt wins
      if (localNote == null ||
          remoteNote.updatedAt.isAfter(localNote.updatedAt)) {
        if (remoteNote.isDeleted) {
          await localNote?.delete();
        } else {
          await aiNotesBox.put(remoteNote.id, remoteNote);
        }
      }

      // -------- SECTIONS --------
      final sectionsSnap =
          await noteDoc.reference.collection('sections').get();

      for (final sectionDoc in sectionsSnap.docs) {
        final remoteSection =
            AiNoteSectionFirestoreMapper.fromFirestore(
          docId: sectionDoc.id,
          noteId: remoteNote.id,
          json: sectionDoc.data(),
        );

        final localSection =
            sectionsBox.get(remoteSection.id);

        // ✅ No updatedAt → cloud always wins
        if (remoteSection.isDeleted) {
          await localSection?.delete();
        } else {
          await sectionsBox.put(
            remoteSection.id,
            remoteSection,
          );
        }
      }
    }
  }
}
