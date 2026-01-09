import 'package:flutter/material.dart';
import 'package:learnify/notes/normal_notes/models/note.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/note_card.dart';

class NotesList extends StatelessWidget {
  const NotesList({super.key, required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: notes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return NoteCard(
          note: notes[index],
          isInGrid: false,
        );
      },
    );
  }
}
