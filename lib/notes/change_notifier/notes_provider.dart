import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:learnify/notes/core/extension.dart';
import 'package:learnify/notes/enums/order_option.dart';
import 'package:learnify/notes/models/note.dart';
import '../services/notes_firebase_service.dart';

class NotesProvider extends ChangeNotifier {
  final NotesFirebaseService _firebaseService = NotesFirebaseService();

  final List<Note> _notes = [];
  StreamSubscription<List<Note>>? _subscription;

  NotesProvider() {
    _listenToNotes();
  }

  // ================= FIREBASE LISTENER =================

  void _listenToNotes() {
    _subscription = _firebaseService.fetchNotes().listen(
      (notes) {
        _notes
          ..clear()
          ..addAll(notes);
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Notes stream error: $error');
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // ================= GETTERS =================

  List<Note> get notes {
    final filtered =
        _searchTerm.isEmpty ? _notes : _notes.where(_test).toList();
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
      final doc = Document.fromJson(jsonDecode(json));
      return doc.toPlainText().toLowerCase();
    } catch (_) {
      return '';
    }
  }

  // ================= SORT =================

  int _compare(Note a, Note b) {
    return orderBy == OrderOption.dateModified
        ? _isDescending
            ? b.dateModified.compareTo(a.dateModified)
            : a.dateModified.compareTo(b.dateModified)
        : _isDescending
            ? b.dateCreated.compareTo(a.dateCreated)
            : a.dateCreated.compareTo(b.dateCreated);
  }

  // ================= CRUD =================
  // Firestore is the source of truth

  Future<void> addNote(Note note) {
    return _firebaseService.addNote(note);
  }

  Future<void> updateNote(Note note) {
    return _firebaseService.updateNote(note);
  }

  Future<void> deleteNote(Note note) {
    return _firebaseService.deleteNote(note.id);
  }

  // ================= VIEW OPTIONS =================

  OrderOption _orderBy = OrderOption.dateModified;
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
