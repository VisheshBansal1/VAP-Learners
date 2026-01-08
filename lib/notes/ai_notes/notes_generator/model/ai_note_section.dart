import 'package:hive/hive.dart';

part 'ai_note_section.g.dart';

@HiveType(typeId: 2) // KEEP SAME typeId
class AiNoteSection extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String noteId;

  @HiveField(2)
  String topic;

  @HiveField(3)
  String content;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  bool isSynced;

  @HiveField(6)
  bool isDeleted;

  AiNoteSection({
    required this.id,
    required this.noteId,
    required this.topic,
    required this.content,
    required this.createdAt,
    this.isSynced = false,
    this.isDeleted = false,
  });
}
