import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learnify/notes/change_notifier/notes_provider.dart';
import 'package:learnify/notes/models/note.dart';
import 'package:provider/provider.dart';

class NewNoteController extends ChangeNotifier {
  Note? _note;

  set note(Note? value) {
    _note = value;
    if (_note == null) return;

    _title = _note!.title ?? '';
    _content = Document.fromJson(
      jsonDecode(_note!.contentJson),
    );
    _tags
      ..clear()
      ..addAll(_note!.tags ?? []);

    notifyListeners();
  }

  Note? get note => _note;

  // ================= READ ONLY =================

  bool _readOnly = false;
  set readOnly(bool value) {
    _readOnly = value;
    notifyListeners();
  }

  bool get readOnly => _readOnly;

  // ================= TITLE =================

  String _title = '';
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  String get title => _title.trim();

  // ================= CONTENT =================

  Document _content = Document();
  set content(Document value) {
    _content = value;
    notifyListeners();
  }

  Document get content => _content;

  // ================= TAGS =================

  final List<String> _tags = [];

  void addTags(String tag) {
    _tags.add(tag);
    notifyListeners();
  }

  List<String> get tags => [..._tags];

  void removeTag(int index) {
    _tags.removeAt(index);
    notifyListeners();
  }

  // ================= SAVE =================

  void saveNote(BuildContext context) {
    final String? newTitle = title.isNotEmpty ? title : null;
    final String? newContent = content.toPlainText().trim().isNotEmpty
        ? content.toPlainText().trim()
        : null;

    final String contentJson =
        jsonEncode(_content.toDelta().toJson());

    final int now = DateTime.now().microsecondsSinceEpoch;

    final Note newNote = Note(
      id: _note?.id, // 🔴 CRITICAL: preserve Firestore id
      title: newTitle,
      content: newContent,
      contentJson: contentJson,
      dateCreated: isNewNote ? now : _note!.dateCreated,
      dateModified: now,
      tags: tags,
    );

    final notesProvider = context.read<NotesProvider>();

    if (isNewNote) {
      notesProvider.addNote(newNote);
    } else {
      notesProvider.updateNote(newNote);
    }
  }

  // ================= HELPERS =================

  bool get isNewNote => _note == null;

  bool get canSaveNote {
    final String? newTitle = title.isNotEmpty ? title : null;
    final String? newContent = content.toPlainText().trim().isNotEmpty
        ? content.toPlainText().trim()
        : null;

    bool canSave = newTitle != null || newContent != null;

    final newContentJson =
        jsonEncode(content.toDelta().toJson());

    if (!isNewNote) {
      canSave =
          canSave &&
          (newTitle != note!.title ||
              newContentJson != note!.contentJson ||
              !listEquals(tags, note!.tags));
    }

    return canSave;
  }
}
