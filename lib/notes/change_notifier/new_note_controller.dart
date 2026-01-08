import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learnify/notes/change_notifier/notes_provider.dart';
import 'package:learnify/notes/models/note.dart';
import 'package:provider/provider.dart';

class NewNoteController extends ChangeNotifier {
  Note? _note;

  // ================= INIT NOTE =================

  set note(Note? value) {
    _note = value;

    if (_note == null) {
      _title = '';
      _content = Document();
      _tags.clear();
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
    if (tag.trim().isEmpty) return;
    _tags.add(tag.trim());
    notifyListeners();
  }

  void removeTag(int index) {
    if (index < 0 || index >= _tags.length) return;
    _tags.removeAt(index);
    notifyListeners();
  }

  // ================= SAVE =================

  Future<void> saveNote(BuildContext context) async {
    final int now = DateTime.now().millisecondsSinceEpoch;

    final Note newNote = Note(
      id: _note?.id ?? '', // empty → Firestore will create
      title: title,
      contentJson: _encodeContent(_content),
      dateCreated: isNewNote ? now : _note!.dateCreated,
      dateModified: now,
      tags: tags,
    );

    final notesProvider = context.read<NotesProvider>();

    if (isNewNote) {
      await notesProvider.addNote(newNote);
    } else {
      await notesProvider.updateNote(newNote);
    }
  }

  // ================= HELPERS =================

  bool get isNewNote => _note == null;

  bool get canSaveNote {
    if (title.isEmpty && _content.toPlainText().trim().isEmpty) {
      return false;
    }

    if (isNewNote) return true;

    final String newContentJson = _encodeContent(_content);

    return title != _note!.title ||
        newContentJson != _note!.contentJson ||
        !listEquals(tags, _note!.tags);
  }

  // ================= UTILS =================

  Document _decodeContent(String json) {
    try {
      return Document.fromJson(jsonDecode(json));
    } catch (_) {
      return Document();
    }
  }

  String _encodeContent(Document doc) {
    return jsonEncode(doc.toDelta().toJson());
  }
}
