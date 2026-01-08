import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
  const NoteCard({
    super.key,
    required this.isInGrid,
    required this.note,
  });

  final Note note;
  final bool isInGrid;

  @override
  Widget build(BuildContext context) {
    final String plainText = _extractPlainText(note.contentJson);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => NewNoteController()..note = note,
              child: const NewOrEditNoteScreen(isNewNote: false),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(110, 108, 107, 0.34),
          border: Border.all(color: Colors.black54, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.white54,
              offset: Offset(4, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- TITLE ----------
            Text(
              note.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey.shade900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // ---------- TAGS ----------
            if (note.tags.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    note.tags.length,
                    (index) => NoteTag(label: note.tags[index]),
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],

            // ---------- CONTENT ----------
            if (plainText.isNotEmpty)
              isInGrid
                  ? Expanded(
                      child: Text(
                        plainText,
                        style:
                            TextStyle(color: Colors.grey.shade700),
                        overflow: TextOverflow.fade,
                      ),
                    )
                  : Text(
                      plainText,
                      style:
                          TextStyle(color: Colors.grey.shade700),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

            if (isInGrid) const Spacer(),

            // ---------- FOOTER ----------
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
                        await showConfirmationDialog(context) ??
                            false;
                    if (shouldDelete && context.mounted) {
                      context
                          .read<NotesProvider>()
                          .deleteNote(note);
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

  // ================= UTILS =================

  String _extractPlainText(String json) {
    try {
      final doc = Document.fromJson(jsonDecode(json));
      return doc.toPlainText().trim();
    } catch (_) {
      return '';
    }
  }
}

Future<bool?> showConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) =>
        const DialogCard(child: ConfirmationDialog()),
  );
}
