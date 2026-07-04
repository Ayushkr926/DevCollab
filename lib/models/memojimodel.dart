class Memoji {
  final String person;
  final String gender;
  final String skinTone;
  final int posture;
  final String mood;
  final String path;

  Memoji({
    required this.person,
    required this.gender,
    required this.skinTone,
    required this.posture,
    required this.mood,
    required this.path,
  });

  factory Memoji.fromJson(Map<String, dynamic> json) {
    return Memoji(
      person: json["person"],
      gender: json["gender"],
      skinTone: json["skinTone"],
      posture: json["posture"],
      mood: json["mood"],
      path: json["path"],
    );
  }
}