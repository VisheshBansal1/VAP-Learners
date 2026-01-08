import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/note.dart';
import '../enums/order_option.dart';
import '../core/extension.dart';

class NotesProvider extends ChangeNotifier {
  late final Box<Note> _notesBox;

  NotesProvider() {
    _notesBox = Hive.box<Note>('notesBox');
    _notesBox.listenable().addListener(_onNotesChanged);
  }

  void _onNotesChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _notesBox.listenable().removeListener(_onNotesChanged);
    super.dispose();
  }

  // ================= RAW NOTES =================

  List<Note> get _allNotes =>
      _notesBox.values.where((n) => !n.isDeleted).toList();

  // ================= FILTERED NOTES =================

  List<Note> get notes {
    final filtered =
        _searchTerm.isEmpty ? _allNotes : _allNotes.where(_test).toList();
    filtered.sort(_compare);
    return filtered;
  }

  // ================= SEARCH =================

  bool _test(Note note) {
    final term = _searchTerm.toLowerCase().trim();
    if (term.isEmpty) return true;

    final title = note.title.toLowerCase();
    final content = _extractPlainText(note.contentJson);
    final tags = note.tags.map((e) => e.toLowerCase()).toList();

    return title.contains(term) ||
        content.contains(term) ||
        tags.deepContains(term);
  }

  String _extractPlainText(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) {
        final doc = Document.fromJson(decoded);
        return doc.toPlainText().toLowerCase();
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  // ================= SORT =================

  int _compare(Note a, Note b) {
    return orderBy == OrderOption.updatedAt
        ? _isDescending
            ? b.updatedAt.compareTo(a.updatedAt)
            : a.updatedAt.compareTo(b.updatedAt)
        : _isDescending
            ? b.createdAt.compareTo(a.createdAt)
            : a.createdAt.compareTo(b.createdAt);
  }

  // ================= CRUD (HIVE ONLY) =================

  Future<void> addNote(Note note) async {
    note.isSynced = false;
    await _notesBox.put(note.id, note);
  }

  Future<void> updateNote(Note note) async {
    note.isSynced = false;
    await note.save();
  }

  Future<void> deleteNote(Note note) async {
    note
      ..isDeleted = true
      ..isSynced = false;
    await note.save();
  }

  // ================= VIEW OPTIONS =================

  OrderOption _orderBy = OrderOption.updatedAt;
  OrderOption get orderBy => _orderBy;

  set orderBy(OrderOption value) {
    if (_orderBy == value) return;
    _orderBy = value;
    notifyListeners();
  }

  bool _isDescending = true;
  bool get isDescending => _isDescending;

  set isDescending(bool value) {
    if (_isDescending == value) return;
    _isDescending = value;
    notifyListeners();
  }

  bool _isGrid = true;
  bool get isGrid => _isGrid;

  set isGrid(bool value) {
    if (_isGrid == value) return;
    _isGrid = value;
    notifyListeners();
  }

  // ================= SEARCH TERM =================

  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  set searchTerm(String value) {
    if (_searchTerm == value) return;
    _searchTerm = value;
    notifyListeners();
  }
}
