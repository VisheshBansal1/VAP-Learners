import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnify/notes/change_notifier/new_note_controller.dart';
import 'package:learnify/notes/core/utils.dart';
import 'package:learnify/notes/models/note.dart';
import 'package:learnify/notes/notes_screen_widgets/dialog_card.dart';
import 'package:learnify/notes/notes_screen_widgets/new_tag_dialog.dart';
import 'package:learnify/notes/notes_screen_widgets/note_tag.dart';
import 'package:provider/provider.dart';

class NotesMetadata extends StatefulWidget {
  const NotesMetadata({
    super.key,
    required this.note,
  });

  final Note? note;

  @override
  State<NotesMetadata> createState() => _NotesMetadataState();
}

class _NotesMetadataState extends State<NotesMetadata> {
  late final NewNoteController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<NewNoteController>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- DATE INFO ----------
        if (widget.note != null) ...[
          _dateRow('Last Modified', widget.note!.dateModified),
          const SizedBox(height: 4),
          _dateRow('Created', widget.note!.dateCreated),
          const SizedBox(height: 8),
        ],

        // ---------- TAGS ----------
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  const Text(
                    'Tags',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.circlePlus,
                      size: 16,
                    ),
                    onPressed: () async {
                      final String? tag =
                          await showDialog<String?>(
                        context: context,
                        builder: (_) =>
                            const DialogCard(child: NewTagDialog()),
                      );

                      if (tag != null && tag.trim().isNotEmpty) {
                        _controller.addTag(tag.trim());
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Selector<NewNoteController, List<String>>(
                selector: (_, ctrl) => ctrl.tags,
                builder: (_, tags, __) {
                  if (tags.isEmpty) {
                    return const Text(
                      'No tag added',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        tags.length,
                        (index) => NoteTag(
                          label: tags[index],
                          onClosed: () {
                            _controller.removeTag(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= HELPERS =================

  Widget _dateRow(String label, int timestamp) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            toLongDate(timestamp),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
