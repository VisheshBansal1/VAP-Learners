import 'package:flutter/material.dart';
import 'note_button.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    this.confirmLabel = 'Yes',
    this.cancelLabel = 'No',
  });

  final String title;
  final String confirmLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            NoteButton(
              label: cancelLabel,
              isOutlined: true,
              onPressed: () => Navigator.pop(context, false),
            ),
            const SizedBox(width: 8),
            NoteButton(
              label: confirmLabel,
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ],
    );
  }
}
