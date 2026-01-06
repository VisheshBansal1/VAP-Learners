class Note {
  final String? id; // 🔴 REQUIRED for Firestore update/delete
  final String? title;
  final String? content;
  final String contentJson;
  final int dateCreated;
  final int dateModified;
  final List<String>? tags;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.contentJson,
    required this.dateCreated,
    required this.dateModified,
    required this.tags,
  });

  // ================= FIRESTORE → MODEL =================
  factory Note.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return Note(
      id: id,
      title: json['title'] as String?,
      content: json['content'] as String?,
      contentJson: json['contentJson'] as String,
      dateCreated: json['dateCreated'] as int,
      dateModified: json['dateModified'] as int,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : null,
    );
  }

  // ================= MODEL → FIRESTORE =================
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'contentJson': contentJson,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
      'tags': tags,
    };
  }
}
