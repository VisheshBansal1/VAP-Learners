import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnify/notes/change_notifier/new_note_controller.dart';
import 'package:learnify/notes/change_notifier/notes_provider.dart';
import 'package:learnify/notes/core/utils.dart';
import 'package:learnify/notes/models/note.dart';
import 'package:learnify/notes/notes_screen/new_or_edit_note_screen.dart';
import 'package:learnify/notes/notes_screen_widgets/conformation_dialog.dart';
import 'package:learnify/notes/notes_screen_widgets/dialog_card.dart';
import 'package:learnify/notes/notes_screen_widgets/note_tag.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.isInGrid, required this.note});

  final Note note;
  final bool isInGrid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider(
                create: (_) => NewNoteController()..note = note,
                child: NewOrEditNoteScreen(isNewNote: false),
              );
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(110, 108, 107, 0.34),
          border: Border.all(color: Colors.black54, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.white54, offset: Offset(4, 4))],
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.title != null) ...[
              Text(
                note.title!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey.shade900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
            ],
            if (note.tags != null) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    note.tags!.length,
                    (index) => NoteTag(label: note.tags![index]),
                  ),
                ),
              ),
              SizedBox(height: 4),
            ],
            if (note.content != null) ...[
              isInGrid
                  ? Expanded(
                      child: Text(
                        note.content!,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    )
                  : Text(
                      note.content!,
                      style: TextStyle(color: Colors.grey.shade700),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
            if (isInGrid) Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    toShortDate(note.dateModified),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final shouldDelete =
                        await showConfirmationDialog(context) ?? false;
                    if (shouldDelete && context.mounted) {
                      context.read<NotesProvider>().deleteNote(note);
                    }
                  },
                  child: FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.grey.shade500,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => const DialogCard(child: ConfirmationDialog()),
  );
}
