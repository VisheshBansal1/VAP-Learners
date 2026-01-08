import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learnify/notes/ai_notes/notes_generator/model/note.dart';

import 'create_note_screen.dart';
import 'note_detail_screen.dart';

class NotesHomeScreen extends StatelessWidget {
  const NotesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesBox = Hive.box<Note>('notesBox');

    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateNoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }

          final notes = box.values.toList()
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (_, index) {
              final note = notes[index];

              return ListTile(
                title: Text(note.title),
                trailing: Icon(
                  note.isSynced ? Icons.cloud_done : Icons.cloud_off,
                  size: 18,
                  color: note.isSynced ? Colors.green : Colors.grey,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          NoteDetailScreen(noteId: note.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
