class Note {
  final int? id;
  final String title;
  final String content;
  final List<String> tags;
  final String? imagePath;
  final DateTime modifiedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.tags,
    this.imagePath,
    required this.modifiedAt,
  });

  // Convert a Note into a Map. The keys must match the DB column names.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags.join(','), // Store tags as a comma-separated string
      'image_path': imagePath,
      'modified_at': modifiedAt.toIso8601String(),
    };
  }

  // Extract a Note object from a Map.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      tags: (map['tags'] as String).split(',').where((t) => t.isNotEmpty).toList(),
      imagePath: map['image_path'],
      modifiedAt: DateTime.parse(map['modified_at']),
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    List<String>? tags,
    String? imagePath,
    DateTime? modifiedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      imagePath: imagePath ?? this.imagePath,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }
}