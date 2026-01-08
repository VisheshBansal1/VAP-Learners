import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnify/notes/normal_notes/change_notifier/new_note_controller.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/conformation_dialog.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/dialog_card.dart';
import 'package:learnify/notes/normal_notes/notes_screen_widgets/notes_metadata.dart';
import 'package:provider/provider.dart';

class NewOrEditNoteScreen extends StatefulWidget {
  const NewOrEditNoteScreen({super.key, required this.isNewNote});

  final bool isNewNote;

  @override
  State<NewOrEditNoteScreen> createState() => _NewOrEditNoteScreenState();
}

class _NewOrEditNoteScreenState extends State<NewOrEditNoteScreen> {
  late final NewNoteController newNoteController;
  late final TextEditingController titleController;
  QuillController _quillController = QuillController.basic();
  final ScrollController _scrollController = ScrollController();

  late final FocusNode focusNode;
  late bool readOnly = true;

  @override
  void initState() {
    super.initState();
    newNoteController = context.read<NewNoteController>();
    titleController = TextEditingController(text: newNoteController.title);

    _quillController = QuillController.basic()
      ..addListener(() {
        newNoteController.content = _quillController.document;
      });
    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.isNewNote) {
        focusNode.requestFocus();
        newNoteController.readOnly = false;
      } else {
        newNoteController.readOnly = true;
        _quillController.document = newNoteController.content;
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    _quillController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<bool> _handleExit() async {
    final shouldSave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const DialogCard(
        child: ConfirmationDialog(
          title: 'Save changes before leaving?',
          confirmLabel: 'Save',
          cancelLabel: 'Discard',
        ),
      ),
    );

    if (shouldSave == true) {
      await newNoteController.saveNote(context);
    }

    return true; // allow pop after handling
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (!newNoteController.canSaveNote) {
          Navigator.pop(context);
          return;
        }
        final shouldPop = await _handleExit();
        if (shouldPop && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isNewNote ? 'New Note' : 'Edit Note'),
          elevation: 1,
          leading: IconButton(
            onPressed: () async {
              if (!newNoteController.canSaveNote) {
                Navigator.pop(context);
                return;
              }
              final shouldPop = await _handleExit();
              if (shouldPop && mounted) Navigator.pop(context);
            },
            icon: const FaIcon(FontAwesomeIcons.chevronLeft),
          ),

          actions: [
            Selector<NewNoteController, bool>(
              selector: (context, newNoteController) =>
                  newNoteController.readOnly,
              builder: (context, readOnly, child) => IconButton(
                onPressed: () {
                  newNoteController.readOnly = !readOnly;
                  if (newNoteController.readOnly) {
                    FocusScope.of(context).unfocus();
                  } else {
                    focusNode.requestFocus();
                  }
                },
                icon: Icon(
                  readOnly ? FontAwesomeIcons.pen : FontAwesomeIcons.bookOpen,
                ),
              ),
            ),
            SizedBox(width: 15),
            Selector<NewNoteController, bool>(
              selector: (_, newNoteController) => newNoteController.canSaveNote,
              builder: (_, canSaveNote, __) => IconButton(
                onPressed: canSaveNote
                    ? () {
                        newNoteController.saveNote(context);
                        Navigator.pop(context);
                      }
                    : null,
                icon: Icon(FontAwesomeIcons.check),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // ---------- TITLE ----------
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title here',
                  labelStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (newValue) {
                  newNoteController.title = newValue;
                },
              ),

              // ---------- META DATA ----------
              NotesMetadata(note: newNoteController.note),

              const Divider(height: 30, thickness: 2),

              // ---------- MAIN EDITOR AREA ----------
              Expanded(
                child: Selector<NewNoteController, bool>(
                  selector: (_, ctrl) => ctrl.readOnly,
                  builder: (context, readOnly, _) {
                    return Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: _scrollController,
                            child: AbsorbPointer(
                              absorbing: readOnly,
                              child: QuillEditor.basic(
                                controller: _quillController,
                                focusNode: focusNode,
                                scrollController: _scrollController,
                                config: const QuillEditorConfig(
                                  placeholder: 'Note here...',
                                  expands: true,
                                  checkBoxReadOnly: false,
                                ),
                              ),
                            ),
                          ),
                        ),

                        if (!readOnly)
                          QuillSimpleToolbar(
                            controller: _quillController,
                            config: const QuillSimpleToolbarConfig(
                              multiRowsDisplay: false,
                              showAlignmentButtons: true,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black45,
                                    width: 2,
                                  ),
                                  left: BorderSide(
                                    color: Colors.black45,
                                    width: 2,
                                  ),
                                  right: BorderSide(
                                    color: Colors.black45,
                                    width: 2,
                                  ),
                                  top: BorderSide(
                                    color: Colors.black45,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
