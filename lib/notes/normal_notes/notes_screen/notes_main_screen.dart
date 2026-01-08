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

class NotesMainScreen extends StatefulWidget {
  const NotesMainScreen({super.key});

  @override
  State<NotesMainScreen> createState() => _NotesMainScreenState();
}

class _NotesMainScreenState extends State<NotesMainScreen> {
  final List<String> dropDownOption = ["Date modified", "Date Created"];

  late String dropDownValue = dropDownOption.first;
  bool isDecending = true;
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
              builder: (context) {
                return ChangeNotifierProvider(
                  create: (_) => NewNoteController(),
                  child: const NewOrEditNoteScreen(isNewNote: true),
                );
              },
            ),
          );
        },
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          final List<Note> notes = notesProvider.notes;

          return notes.isEmpty && notesProvider.searchTerm.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/image.png', height: 370),
                    const Text(
                      'No notes yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SearchField(),
                      if (notes.isNotEmpty) ...[
                        const ViewOptions(),
                        Expanded(
                          child: isGrid
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
