import 'package:flutter/material.dart';
import 'package:learnify/notes/core/extension.dart';
import 'package:learnify/notes/enums/order_option.dart';
import 'package:learnify/notes/models/note.dart';
import '../services/notes_firebase_service.dart';

class NotesProvider extends ChangeNotifier {
  final NotesFirebaseService _firebaseService =
      NotesFirebaseService();

  final List<Note> _notes = [];

  // ================= LOAD FROM FIREBASE =================

  Future<void> loadNotes() async {
    final fetchedNotes = await _firebaseService.fetchNotes();
    _notes
      ..clear()
      ..addAll(fetchedNotes);
    notifyListeners();
  }

  // ================= GETTERS =================

  List<Note> get notes =>
      [..._searchTerm.isEmpty ? _notes : _notes.where(_test)]
        ..sort(_compare);

  // ================= SEARCH =================

  bool _test(Note note) {
    final term = _searchTerm.toLowerCase().trim();
    final title = note.title?.toLowerCase() ?? '';
    final content = note.content?.toLowerCase() ?? '';
    final tags =
        note.tags?.map((e) => e.toLowerCase()).toList() ?? [];

    return title.contains(term) ||
        content.contains(term) ||
        tags.deepContains(term);
  }

  // ================= SORT =================

  int _compare(Note note1, Note note2) {
    return orderBy == OrderOption.dateModified
        ? _isDecending
            ? note2.dateModified.compareTo(note1.dateModified)
            : note1.dateModified.compareTo(note2.dateModified)
        : _isDecending
            ? note2.dateCreated.compareTo(note1.dateCreated)
            : note1.dateCreated.compareTo(note2.dateCreated);
  }

  // ================= CRUD =================

  Future<void> addNote(Note note) async {
    await _firebaseService.addNote(note);
    _notes.add(note);
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    final index = _notes.indexWhere(
      (element) => element.id == note.id,
    );

    if (index == -1) return;

    await _firebaseService.updateNote(note);

    _notes[index] = note;
    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    await _firebaseService.deleteNote(note.id);
    _notes.remove(note);
    notifyListeners();
  }

  // ================= VIEW OPTIONS =================

  OrderOption _orderBy = OrderOption.dateModified;
  set orderBy(OrderOption value) {
    _orderBy = value;
    notifyListeners();
  }

  OrderOption get orderBy => _orderBy;

  bool _isDecending = true;
  set isDescending(bool value) {
    _isDecending = value;
    notifyListeners();
  }

  bool get isDescending => _isDecending;

  bool _isGrid = true;
  set isGrid(bool value) {
    _isGrid = value;
    notifyListeners();
  }

  bool get isGrid => _isGrid;

  // ================= SEARCH TERM =================

  String _searchTerm = '';
  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  String get searchTerm => _searchTerm;
}
