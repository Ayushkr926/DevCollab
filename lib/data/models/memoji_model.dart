/// Core data model matching the existing JSON schema:
/// person, gender, skinTone, mood, posture, imagePath.
class Memoji {
  final String id;
  final String person;
  final String gender; // "Male" | "Female"
  final String skinTone;
  final String mood;
  final String posture;
  final String imagePath;

  const Memoji({
    required this.id,
    required this.person,
    required this.gender,
    required this.skinTone,
    required this.mood,
    required this.posture,
    required this.imagePath,
  });

  factory Memoji.fromJson(Map<String, dynamic> json) {
    return Memoji(
      id: (json['id'] ?? json['imagePath'] ?? _IdGen.next()).toString(),
      person: json['person']?.toString() ?? 'Unknown',
      gender: json['gender']?.toString() ?? 'Unspecified',
      skinTone: json['skinTone']?.toString() ?? 'Medium',
      mood: json['mood']?.toString() ?? 'Happy',
      posture: json['posture']?.toString() ?? 'Standing',
      imagePath: json['path']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'person': person,
        'gender': gender,
        'skinTone': skinTone,
        'mood': mood,
        'posture': posture,
        'imagePath': imagePath,
      };

  Memoji copyWith({
    String? person,
    String? gender,
    String? skinTone,
    String? mood,
    String? posture,
    String? imagePath,
  }) {
    return Memoji(
      id: id,
      person: person ?? this.person,
      gender: gender ?? this.gender,
      skinTone: skinTone ?? this.skinTone,
      mood: mood ?? this.mood,
      posture: posture ?? this.posture,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  bool operator ==(Object other) => other is Memoji && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Small helper to generate a fallback id if the JSON has none.
class _IdGen {
  static int _counter = 0;
  static String next() => 'memoji_${_counter++}';
}
