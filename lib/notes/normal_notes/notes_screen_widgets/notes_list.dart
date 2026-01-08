import 'package:flutter/material.dart';
import 'package:learnify/notes/normal_notes/models/note.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/note_card.dart';

class NotesList extends StatelessWidget {
  const NotesList({super.key, required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: notes.length,
      clipBehavior: Clip.none,
      itemBuilder: (context, index) {
        return NoteCard(isInGrid: false, note: notes[index],);
      },
      separatorBuilder: (context, index) => SizedBox(height: 5),
    );
  }
}
