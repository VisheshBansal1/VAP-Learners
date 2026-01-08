import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:learnify/notes/ai_notes/notes_generator/model/ai_note.dart';
import 'package:learnify/notes/ai_notes/notes_generator/model/ai_note_section.dart';
import 'package:learnify/notes/ai_notes/notes_generator/api/notes_api.dart';

class NoteDetailScreen extends StatefulWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final TextEditingController _topicCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  late final Box<AiNote> _aiNotesBox;
  late final Box<AiNoteSection> _sectionsBox;

  @override
  void initState() {
    super.initState();
    _aiNotesBox = Hive.box<AiNote>('aiNotesBox');
    _sectionsBox = Hive.box<AiNoteSection>('sectionsBox'); // ✅ AI sections
  }

  Future<void> _generateSection() async {
    if (_loading) return;

    final topic = _topicCtrl.text.trim();
    if (topic.isEmpty) return;

    final aiNote = _aiNotesBox.get(widget.noteId);
    if (aiNote == null || aiNote.isDeleted) {
      setState(() {
        _error = 'This AI note no longer exists.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final content = await NotesApi.generateSection(topic);

      if (content.trim().isEmpty) {
        throw Exception('Empty AI response');
      }

      final section = AiNoteSection(
        id: const Uuid().v4(),
        noteId: widget.noteId,
        topic: topic,
        content: content,
        createdAt: DateTime.now(),
        isSynced: false,
        isDeleted: false,
      );

      await _sectionsBox.put(section.id, section);

      aiNote
        ..updatedAt = DateTime.now()
        ..isSynced = false;
      await aiNote.save();

      _topicCtrl.clear();
    } catch (e) {
      setState(() {
        _error = 'Failed to generate section. Try again.';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _deleteSection(AiNoteSection section) async {
    section
      ..isDeleted = true
      ..isSynced = false;
    await section.save();

    final aiNote = _aiNotesBox.get(widget.noteId);
    if (aiNote != null) {
      aiNote
        ..updatedAt = DateTime.now()
        ..isSynced = false;
      await aiNote.save();
    }
  }

  @override
  void dispose() {
    _topicCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aiNote = _aiNotesBox.get(widget.noteId);

    if (aiNote == null || aiNote.isDeleted) {
      return const Scaffold(
        body: Center(child: Text('AI note not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(aiNote.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _topicCtrl,
                    decoration: InputDecoration(
                      hintText:
                          _loading ? 'Generating…' : 'Enter topic',
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _generateSection(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _generateSection,
                  child: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Generate'),
                ),
              ],
            ),
          ),

          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          Expanded(
            child: ValueListenableBuilder<Box<AiNoteSection>>(
              valueListenable: _sectionsBox.listenable(),
              builder: (_, box, __) {
                final sections = box.values
                    .where(
                      (s) =>
                          s.noteId == widget.noteId &&
                          s.isDeleted == false,
                    )
                    .toList()
                  ..sort(
                    (a, b) =>
                        b.createdAt.compareTo(a.createdAt),
                  );

                if (sections.isEmpty) {
                  return const Center(
                      child: Text('No sections yet'));
                }

                return ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (_, index) {
                    final section = sections[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          section.topic,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(section.content),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _deleteSection(section),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
