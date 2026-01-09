import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/conformation_dialog.dart';
import 'package:provider/provider.dart';

import '../change_notifier/new_note_controller.dart';
import '../change_notifier/notes_provider.dart';
import '../core/utils.dart';
import '../models/note.dart';
import '../notes_screen/new_or_edit_note_screen.dart';
import '../notes_screen_widgets/dialog_card.dart';
import '../notes_screen_widgets/note_tag.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.isInGrid, required this.note});

  final Note note;
  final bool isInGrid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String plainText = _extractPlainText(note.contentJson);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
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
          color: Color(0xFF1E293B),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.2),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- TITLE ----------
            Text(
              note.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
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
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.fade,
                      ),
                    )
                  : Text(
                      plainText,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

            if (isInGrid) const Spacer(),

            // ---------- FOOTER ----------
            Row(
              children: [
                Expanded(
                  child: Text(
                    toShortDate(note.updatedAt),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.trash, size: 16),
                  color: theme.colorScheme.error,
                  onPressed: () async {
                    final shouldDelete = await showConfirmationDialog(context);

                    if (shouldDelete && context.mounted) {
                      context.read<NotesProvider>().deleteNote(note);
                    }
                  },
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

// ================= DIALOG =================

Future<bool> showConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => const DialogCard(
      child: ConfirmationDialog(
        title: 'Delete this note permanently?',
        confirmLabel: 'Delete',
        cancelLabel: 'Cancel',
      ),
    ),
  );

  return result ?? false;
}
