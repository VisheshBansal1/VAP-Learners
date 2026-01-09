import 'package:flutter/material.dart';
import 'package:learnify/notes/normal_notes/models/note.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/note_card.dart';

class NotesGrid extends StatelessWidget {
  const NotesGrid({super.key, required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        return NoteCard(
          note: notes[index],
          isInGrid: true,
        );
      },
    );
  }
}
