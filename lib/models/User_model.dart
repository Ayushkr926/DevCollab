class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String location;
  final String? avatarUrl;
  final String experience;
  final List<String> skills;
  String? connectionStatus;
  final bool isAvailable;
  final double? rating;
  final String bio;
  final String linkedin;
  final String github;
  final String leetcode;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.location,
    this.avatarUrl,
    required this.experience,
    this.connectionStatus = "none",
    required this.skills,
    required this.isAvailable,
    this.rating,
    required this.bio,
    required this.linkedin,
    required this.github,
    required this.leetcode,
    required this.createdAt,
  });

  // Factory constructor
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: (json['headline'] ?? '').toString().isNotEmpty
          ? json['headline']
          : 'Developer',
      location: json['location'] ?? '',
      connectionStatus: json['connectionStatus'] ?? "none",
      avatarUrl: json['profileImage'],
      experience: json['experience']?.toString() ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      isAvailable: (json['availability'] ?? 'Available') == 'Available',
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      bio: json['bio'] ?? '',
      linkedin: json['socialLinks']?['linkedin'] ?? '',
      github: json['socialLinks']?['github'] ?? '',
      leetcode: json['socialLinks']?['leetcode'] ?? '',
        createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'headline': role,
      'location': location,
      'profileImage': avatarUrl,
      'experience': experience,
      'skills': skills,
      'availability': isAvailable ? 'Available' : 'Busy',
      'bio': bio,
      'socialLinks': {
        'linkedin': linkedin,
        'github': github,
        'leetcode': leetcode,
      },
    };
  }
}