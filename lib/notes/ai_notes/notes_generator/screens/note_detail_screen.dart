import 'package:flutter/material.dart';
import 'package:learnify/notes/ai_notes/notes_generator/note_section.dart';
import 'package:learnify/notes/ai_notes/notes_generator/notes_api.dart';
import '../services/notes_firestore_service.dart';

class NoteDetailScreen extends StatefulWidget {
  final String noteId;
  final String noteTitle;

  const NoteDetailScreen({
    super.key,
    required this.noteId,
    required this.noteTitle,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final TextEditingController topicCtrl = TextEditingController();
  bool loading = false;
  String? error;

  // ================= GENERATE AI SECTION =================

  Future<void> generateSection() async {
    final topic = topicCtrl.text.trim();
    if (topic.isEmpty || loading) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      // 1️⃣ Call backend → AI text
      final content = await NotesApi.generateSection(topic);

      // 2️⃣ Persist via Firestore service
      await NotesFirestoreService.addSection(
        noteId: widget.noteId,
        topic: topic,
        content: content,
      );

      topicCtrl.clear();
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.noteTitle)),
      body: Column(
        children: [
          // ================= INPUT BAR =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: topicCtrl,
                    decoration: const InputDecoration(
                      hintText: "Enter topic (e.g. Widgets)",
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
                      : const Text("Generate"),
                ),
              ],
            ),
          ),

          if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // ================= SECTIONS LIST =================
          Expanded(
            child: StreamBuilder<List<NoteSection>>(
              stream:
                  NotesFirestoreService.sectionsStream(widget.noteId),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No sections yet"),
                  );
                }

                final sections = snapshot.data!;

                return ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
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
