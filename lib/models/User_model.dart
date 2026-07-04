class UserModel {
  final String id;
  final String name;
  final String role;
  final String location;
  final String? avatarUrl;
  final String? experience;
  final List<String> skills;
  final bool isAvailable;
  final double? rating;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.location,
    this.avatarUrl,
    this.experience,
    this.skills = const [],
    this.isAvailable = true,
    this.rating,
  });

  // For demo data
  static List<UserModel> getDemoUsers() {
    return [
      UserModel(
        id: "1",
        name: "Akash Sharma",
        role: "Full Stack Developer",
        location: "Bangalore",
        experience: "5+ years",
        skills: ["Flutter", "Node.js", "React"],
        isAvailable: true,
        rating: 4.8,
      ),
      UserModel(
        id: "2",
        name: "Priya Singh",
        role: "Flutter Developer",
        location: "Noida",
        experience: "3+ years",
        skills: ["Flutter", "Dart", "Firebase"],
        isAvailable: true,
        rating: 4.9,
      ),
      // Add more as needed...
    ];
  }
}