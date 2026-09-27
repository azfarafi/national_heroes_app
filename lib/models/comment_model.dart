class CommentModel {
  final int? id;
  final int heroId;
  final String author;
  final String content;
  final DateTime createdAt;

  CommentModel({
    this.id,
    required this.heroId,
    required this.author,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, Object?> map) {
    return CommentModel(
      id: map['id'] as int?,
      heroId: map['hero_id'] as int,
      author: map['author'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'hero_id': heroId,
      'author': author,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
