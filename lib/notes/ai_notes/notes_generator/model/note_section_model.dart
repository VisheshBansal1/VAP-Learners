import 'package:hive/hive.dart';

part 'note_section_model.g.dart';

@HiveType(typeId: 1)
class NoteSection extends HiveObject {
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

  NoteSection({
    required this.id,
    required this.noteId,
    required this.topic,
    required this.content,
    required this.createdAt,
    this.isSynced = false,
  });
}
