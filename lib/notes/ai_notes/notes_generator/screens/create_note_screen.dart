import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:learnify/notes/ai_notes/notes_generator/model/ai_note.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  bool _isSaving = false;

  Future<void> _createNote() async {
    if (_isSaving) return;

    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showError('User not logged in');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notesBox = Hive.box<AiNote>('aiNotesBox');
      final now = DateTime.now();

      final aiNote = AiNote(
        id: const Uuid().v4(), // Firestore ID
        userId: user.uid,
        title: title,
        createdAt: now,
        updatedAt: now,
        isSynced: false,
        isDeleted: false,
      );

      // Hive key = same as Firestore ID
      await notesBox.put(aiNote.id, aiNote);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      _showError('Failed to create note');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New AI Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'Note title',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _createNote(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _createNote,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
