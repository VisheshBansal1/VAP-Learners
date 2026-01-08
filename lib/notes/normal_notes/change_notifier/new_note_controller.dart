import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../change_notifier/notes_provider.dart';
import '../models/note.dart';

class NewNoteController extends ChangeNotifier {
  Note? _note;

  // ================= INIT NOTE =================

  set note(Note? value) {
    _note = value;

    if (_note == null) {
      _title = '';
      _content = Document();
      _tags.clear();
      notifyListeners();
      return;
    }

    _title = _note!.title;
    _content = _decodeContent(_note!.contentJson);
    _tags
      ..clear()
      ..addAll(_note!.tags);

    notifyListeners();
  }

  Note? get note => _note;

  // ================= READ ONLY =================

  bool _readOnly = false;
  bool get readOnly => _readOnly;

  set readOnly(bool value) {
    _readOnly = value;
    notifyListeners();
  }

  // ================= TITLE =================

  String _title = '';
  String get title => _title.trim();

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  // ================= CONTENT =================

  Document _content = Document();
  Document get content => _content;

  set content(Document value) {
    _content = value;
    notifyListeners();
  }

  // ================= TAGS =================

  final List<String> _tags = [];
  List<String> get tags => List.unmodifiable(_tags);

  void addTag(String tag) {
    final t = tag.trim();
    if (t.isEmpty || _tags.contains(t)) return;
    _tags.add(t);
    notifyListeners();
  }

  void removeTag(int index) {
    if (index < 0 || index >= _tags.length) return;
    _tags.removeAt(index);
    notifyListeners();
  }

  // ================= SAVE =================

  Future<void> saveNote(BuildContext context) async {
    if (!canSaveNote) return;

    final now = DateTime.now();
    final notesProvider = context.read<NotesProvider>();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final contentJson = _encodeContent(_content);

    if (isNewNote) {
      final newNote = Note(
        id: const Uuid().v4(),
        userId: user.uid,
        title: title,
        contentJson: contentJson,
        createdAt: now,
        updatedAt: now,
        tags: tags,
        isSynced: false,
        isDeleted: false,
      );

      await notesProvider.addNote(newNote);
      _note = newNote;
    } else {
      final updated = _note!.copyWith(
        title: title,
        contentJson: contentJson,
        updatedAt: now,
        tags: tags,
        isSynced: false,
      );

      await notesProvider.updateNote(updated);
      _note = updated;
    }

    notifyListeners();
  }

  // ================= DELETE =================

  Future<void> deleteNote(BuildContext context) async {
    if (_note == null) return;

    final notesProvider = context.read<NotesProvider>();

    _note!
      ..isDeleted = true
      ..isSynced = false;

    await notesProvider.updateNote(_note!);
    notifyListeners();
  }

  // ================= HELPERS =================

  bool get isNewNote => _note == null;

  bool get canSaveNote {
    if (title.isEmpty && _content.toPlainText().trim().isEmpty) {
      return false;
    }

    if (isNewNote) return true;

    final newContentJson = _encodeContent(_content);

    return title != _note!.title ||
        newContentJson != _note!.contentJson ||
        !listEquals(tags, _note!.tags);
  }

  // ================= UTILS =================

  Document _decodeContent(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) {
        return Document.fromJson(decoded);
      }
      return Document();
    } catch (_) {
      // corrupted content → reset safely
      return Document();
    }
  }

  String _encodeContent(Document doc) {
    return jsonEncode(doc.toDelta().toJson());
  }
}
