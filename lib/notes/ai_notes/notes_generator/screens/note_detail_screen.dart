import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learnify/notes/ai_notes/notes_generator/model/note.dart';
import 'package:learnify/notes/ai_notes/notes_generator/model/note_section_model.dart';
import 'package:learnify/notes/ai_notes/notes_generator/api/notes_api.dart';
import 'package:uuid/uuid.dart';

class NoteDetailScreen extends StatefulWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final TextEditingController topicCtrl = TextEditingController();
  bool loading = false;
  String? error;

  late Box<Note> notesBox;
  late Box<NoteSection> sectionsBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notesBox');
    sectionsBox = Hive.box<NoteSection>('sectionsBox');
  }

  Future<void> generateSection() async {
    final topic = topicCtrl.text.trim();
    if (topic.isEmpty || loading) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final content = await NotesApi.generateSection(topic);

      final section = NoteSection(
        id: const Uuid().v4(),
        noteId: widget.noteId,
        topic: topic,
        content: content,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      await sectionsBox.put(section.id, section);

      final note = notesBox.get(widget.noteId);
      if (note != null) {
        note
          ..updatedAt = DateTime.now()
          ..isSynced = false;
        await note.save();
      }

      topicCtrl.clear();
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    topicCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final note = notesBox.get(widget.noteId);

    return Scaffold(
      appBar: AppBar(title: Text(note?.title ?? 'Note')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: topicCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Enter topic',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: loading ? null : generateSection,
                  child: loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Generate'),
                ),
              ],
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: sectionsBox.listenable(),
              builder: (context, Box<NoteSection> box, _) {
                final sections = box.values
                    .where((s) => s.noteId == widget.noteId)
                    .toList()
                  ..sort(
                      (a, b) => b.createdAt.compareTo(a.createdAt));

                if (sections.isEmpty) {
                  return const Center(child: Text('No sections yet'));
                }

                return ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (_, index) {
                    final section = sections[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.topic,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(section.content),
                          ],
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
