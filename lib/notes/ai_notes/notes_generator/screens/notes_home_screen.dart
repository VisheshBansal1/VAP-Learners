import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:learnify/notes/ai_notes/notes_generator/model/ai_note.dart';

import 'create_note_screen.dart';
import 'note_detail_screen.dart';

class NotesHomeScreen extends StatelessWidget {
  const NotesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<AiNote> aiNotesBox = Hive.box<AiNote>('aiNotesBox');

    return Scaffold(
      appBar: AppBar(title: const Text('AI Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: aiNotesBox.listenable(),
        builder: (context, Box<AiNote> box, _) {
          final notes = box.values
              .where((n) => n.isDeleted == false)
              .toList()
            ..sort(
              (a, b) => b.updatedAt.compareTo(a.updatedAt),
            );

          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'No AI notes yet.\nTap + to create one.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (_, index) {
              final note = notes[index];

              return ListTile(
                title: Text(note.title),
                subtitle: Text(
                  note.isSynced ? 'Synced' : 'Not synced',
                  style: TextStyle(
                    fontSize: 12,
                    color: note.isSynced
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'delete') {
                      note
                        ..isDeleted = true
                        ..isSynced = false;
                      await note.save();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
                onTap: () {
                  if (note.isDeleted) return;

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
