import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/notes/normal_notes/change_notifier/new_note_controller.dart';
import 'package:learnify/notes/normal_notes/change_notifier/notes_provider.dart';
import 'package:learnify/notes/normal_notes/models/note.dart';
import 'package:learnify/notes/normal_notes/notes_screen/new_or_edit_note_screen.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/my_floating_action_button.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/notes_grid.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/notes_list.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/seach_field.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/view_options.dart';
import 'package:provider/provider.dart';

class NotesMainScreen extends StatelessWidget {
  const NotesMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Notes Noter📝',
          style: TextStyle(
            color: MyColors.mainColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: MyFloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => NewNoteController(),
                child: const NewOrEditNoteScreen(isNewNote: true),
              ),
            ),
          );
        },
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, _) {
          final List<Note> notes = notesProvider.notes;

          if (notes.isEmpty && notesProvider.searchTerm.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/image.png', height: 370),
                const Text(
                  'No notes yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const SearchField(),
                if (notes.isNotEmpty) ...[
                  const ViewOptions(),
                  Expanded(
                    child: notesProvider.isGrid
                        ? NotesGrid(notes: notes)
                        : NotesList(notes: notes),
                  ),
                ] else
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No Notes found for your Search Query!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
