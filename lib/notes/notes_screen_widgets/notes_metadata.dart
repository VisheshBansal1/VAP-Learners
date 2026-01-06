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
  const NotesMetadata({super.key, required this.note});

  final Note? note;
  @override
  State<NotesMetadata> createState() => _NotesMetadataState();
}

class _NotesMetadataState extends State<NotesMetadata> {
  late final NewNoteController newNoteController;

  @override
  void initState() {
    super.initState();

    newNoteController = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.note != null) ...[
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Last Modified',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  toLongDate(widget.note!.dateModified),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Created',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  toLongDate(widget.note!.dateCreated),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],

        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Text(
                    'Tags',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final String? tag = await showDialog<String?>(
                        context: context,
                        builder: (context) {
                          return const DialogCard(child: NewTagDialog());
                        },
                      );
                      if (tag != null) {
                        newNoteController.addTags(tag);
                      }
                    },
                    icon: FaIcon(FontAwesomeIcons.circlePlus, size: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Selector<NewNoteController, List<String>>(
                selector: (_, newNoteController) {
                  return newNoteController.tags;
                },
                builder: (_, tags, __) => tags.isEmpty
                    ? Text(
                        'No tag added',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            tags.length,
                            (index) => NoteTag(
                              label: tags[index],
                              onClosed: () {
                                newNoteController.removeTag(index);
                              },
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
