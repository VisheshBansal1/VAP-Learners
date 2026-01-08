import 'package:flutter/material.dart';
import 'note_button.dart';
import 'note_form_field.dart';

class NewTagDialog extends StatefulWidget {
  const NewTagDialog({super.key});

  @override
  State<NewTagDialog> createState() => _NewTagDialogState();
}

class _NewTagDialogState extends State<NewTagDialog> {
  late final TextEditingController _tagController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController();
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tag',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          NoteFormField(
            controller: _tagController,
            hintText: 'Write your tag',
            autofocus: true,
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) {
                return 'Tag cannot be empty';
              }
              if (text.length > 16) {
                return 'Max 16 characters allowed';
              }
              return null;
            },
          ),
          const SizedBox(height: 22),
          NoteButton(
            label: 'Add',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                Navigator.pop(context, _tagController.text.trim());
              }
            },
          ),
        ],
      ),
    );
  }
}
