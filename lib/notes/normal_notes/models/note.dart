import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String title;

  // Quill delta JSON
  @HiveField(3)
  String contentJson;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  List<String> tags;

  @HiveField(7)
  bool isSynced;

  @HiveField(8)
  bool isDeleted; // ⭐ REQUIRED for sync

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.contentJson,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.isSynced = false,
    this.isDeleted = false,
  });

  // ================= HELPERS =================

  Note copyWith({
    String? title,
    String? contentJson,
    DateTime? updatedAt,
    List<String>? tags,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return Note(
      id: id,
      userId: userId,
      title: title ?? this.title,
      contentJson: contentJson ?? this.contentJson,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
