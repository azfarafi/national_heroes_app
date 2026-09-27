class HeroModel {
  final int? id;
  final String name;
  final String origin;
  final String lifeTime;
  final String description;
  final String imagePath;

  HeroModel({
    this.id,
    required this.name,
    required this.origin,
    required this.lifeTime,
    required this.description,
    required this.imagePath,
  });

  factory HeroModel.fromMap(Map<String, Object?> map) {
    return HeroModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      origin: map['origin'] as String,
      lifeTime: map['life_time'] as String,
      description: map['description'] as String,
      imagePath: map['image_path'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'origin': origin,
      'life_time': lifeTime,
      'description': description,
      'image_path': imagePath,
    };
  }

  HeroModel copyWith({
    int? id,
    String? name,
    String? origin,
    String? lifeTime,
    String? description,
    String? imagePath,
  }) {
    return HeroModel(
      id: id ?? this.id,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      lifeTime: lifeTime ?? this.lifeTime,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
