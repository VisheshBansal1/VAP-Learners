class Note {
  final String id; // Firestore document ID
  final String title;
  final String contentJson; // Quill Delta JSON (String)
  final int dateCreated; // millisecondsSinceEpoch
  final int dateModified; // millisecondsSinceEpoch
  final List<String> tags;

  Note({
    required this.id,
    required this.title,
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
      title: json['title'] ?? '',
      contentJson: json['contentJson'] ?? '',
      dateCreated: json['dateCreated'] ?? 0,
      dateModified: json['dateModified'] ?? 0,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : <String>[],
    );
  }

  // ================= MODEL → FIRESTORE =================
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'contentJson': contentJson,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
      'tags': tags,
    };
  }

  // ================= HELPERS =================
  Note copyWith({
    String? title,
    String? contentJson,
    int? dateModified,
    List<String>? tags,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      contentJson: contentJson ?? this.contentJson,
      dateCreated: dateCreated,
      dateModified: dateModified ?? this.dateModified,
      tags: tags ?? this.tags,
    );
  }
}
