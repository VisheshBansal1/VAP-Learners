import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';

class NotesLocalService {
  static final Box<Note> _notesBox = Hive.box<Note>('notesBox');

  // ================= READ =================

  static List<Note> getAllNotes() {
    final notes = _notesBox.values
        .where((n) => !n.isDeleted)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return notes;
  }

  // ================= CREATE =================

  static Future<Note> createNote({
    required String userId,
    required String title,
    String contentJson = '',
    List<String> tags = const [],
  }) async {
    final now = DateTime.now();

    final note = Note(
      id: const Uuid().v4(),
      userId: userId,
      title: title,
      contentJson: contentJson,
      createdAt: now,
      updatedAt: now,
      tags: tags,
      isSynced: false,
      isDeleted: false,
    );

    await _notesBox.put(note.id, note);
    return note;
  }

  // ================= UPDATE =================

  static Future<void> updateNote(Note note) async {
    note.isSynced = false;
    await note.save();
  }

  // ================= DELETE (SOFT) =================

  static Future<void> deleteNote(String noteId) async {
    final note = _notesBox.get(noteId);
    if (note == null) return;

    note
      ..isDeleted = true
      ..isSynced = false;

    await note.save();
  }
}
