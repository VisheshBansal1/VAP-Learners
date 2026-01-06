import 'package:flutter/material.dart';
import 'package:learnify/notes/models/note.dart';
import 'package:learnify/notes/notes_screen_widgets/note_card.dart';

class NotesGrid extends StatelessWidget {
  const NotesGrid({super.key, required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: notes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return NoteCard(isInGrid: true, note: notes[index],);
      },
    );
  }
}
