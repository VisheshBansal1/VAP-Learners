import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/notes/notes_screen_widgets/note_button.dart';
import 'package:learnify/notes/notes_screen_widgets/note_form_field.dart';

class NewTagDialog extends StatefulWidget {
  const NewTagDialog({super.key});

  @override
  State<NewTagDialog> createState() => _NewTagDialogState();
}

class _NewTagDialogState extends State<NewTagDialog> {
  late final TextEditingController tagController;

  late final GlobalKey<FormFieldState> tagKey;

  @override
  void initState() {
    super.initState();
    tagController = TextEditingController();
    tagKey = GlobalKey();
  }

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Tag',
          style: TextStyle(
            color: MyColors.mainColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        NoteFormField(
          key: tagKey,
          controller: tagController,
          hintText: 'Write your tag',
          validator: (value) {
            if (value!.trim().isEmpty) {
              return 'No tags added';
            } else if (value.length > 16) {
              return 'Tags should not be more than 16 characters';
            }
            return null;
          },
          onChanged: (newValue) {
            tagKey.currentState?.validate();
          },
          autofocus: true,
        ),
        SizedBox(height: 22),
        NoteButton(
          label: 'Add',
          onPressed: () {
            if (tagKey.currentState?.validate() ?? false) {
              Navigator.pop(context, tagController.text.trim());
            }
          },
        ),
      ],
    );
  }
}
