import 'package:hive/hive.dart';

part 'ai_note.g.dart';

@HiveType(typeId: 1)
class AiNote extends HiveObject {
  /// Firestore document ID
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String title;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  /// Sync flags
  @HiveField(5)
  bool isSynced;

  @HiveField(6)
  bool isDeleted; // ⭐ VERY IMPORTANT for sync

  AiNote({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  });
}
