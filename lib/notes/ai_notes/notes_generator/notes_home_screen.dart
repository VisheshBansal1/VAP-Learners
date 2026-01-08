import 'package:flutter/material.dart';
import 'package:learnify/notes/ai_notes/notes_generator/model/data_model.dart';
import 'package:learnify/notes/ai_notes/notes_generator/screens/create_note_screen.dart';
import 'package:learnify/notes/ai_notes/notes_generator/screens/note_detail_screen.dart';
import 'package:learnify/notes/ai_notes/notes_generator/services/notes_firestore_service.dart';

class NotesHomeScreen extends StatelessWidget {
  const NotesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateNoteScreen(),
            ),
          );
        },
      ),
      body: StreamBuilder<List<NoteModel>>(
        stream: NotesFirestoreService.notesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No notes yet"),
            );
          }

          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return ListTile(
                title: Text(note.title),
                subtitle: Text(
                  "Last updated: ${note.updatedAt.toLocal()}",
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoteDetailScreen(
                        noteId: note.noteId,
                        noteTitle: note.title,
                      ),
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
