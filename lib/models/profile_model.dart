class Profile {
  final String name;
  final String email;
  final String profileImage;
  final List<String> skills;
  final String bio;
  final String availability;
  final List<String> socialLinks;
  final String experience;
  final List<Connection> connections;
  final List<String> savedHackathons;
  final List<String> savedProjects;
  final List<String> registeredHackathons;
  final List<String> registeredProjects;
  final List<String> ongoingProjects;
  final List<String> hackathonsParticipated;
  final int hackathonsParticipatedCount;
  final int ongoingProjectsCount;
  final int connectionsCount;

  Profile({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.skills,
    required this.bio,
    required this.availability,
    required this.socialLinks,
    required this.experience,
    required this.connections,
    required this.savedHackathons,
    required this.savedProjects,
    required this.registeredHackathons,
    required this.registeredProjects,
    required this.ongoingProjects,
    required this.hackathonsParticipated,
    required this.hackathonsParticipatedCount,
    required this.ongoingProjectsCount,
    required this.connectionsCount,
  });

  // Factory constructor for creating Profile from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      bio: json['bio'] ?? '',
      availability: json['availability'] ?? '',
      socialLinks: List<String>.from(json['socialLinks'] ?? []),
      experience: json['experience'] ?? '',
      connections: (json['connections'] as List<dynamic>?)
          ?.map((e) => Connection.fromJson(e))
          .toList() ??
          [],
      savedHackathons: List<String>.from(json['savedHackathons'] ?? []),
      savedProjects: List<String>.from(json['savedProjects'] ?? []),
      registeredHackathons: List<String>.from(json['registeredHackathons'] ?? []),
      registeredProjects: List<String>.from(json['registeredProjects'] ?? []),
      ongoingProjects: List<String>.from(json['ongoingProjects'] ?? []),
      hackathonsParticipated: List<String>.from(json['hackathonsParticipated'] ?? []),
      hackathonsParticipatedCount: json['hackathonsParticipatedCount'] ?? 0,
      ongoingProjectsCount: json['ongoingProjectsCount'] ?? 0,
      connectionsCount: json['connectionsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'skills': skills,
      'bio': bio,
      'availability': availability,
      'socialLinks': socialLinks,
      'experience': experience,
      'connections': connections,
      'savedHackathons': savedHackathons,
      'savedProjects': savedProjects,
      'registeredHackathons': registeredHackathons,
      'registeredProjects': registeredProjects,
      'ongoingProjects': ongoingProjects,
      'hackathonsParticipated': hackathonsParticipated,
      'hackathonsParticipatedCount': hackathonsParticipatedCount,
      'ongoingProjectsCount': ongoingProjectsCount,
      'connectionsCount': connectionsCount,
    };
  }

  Profile copyWith({
    String? name,
    String? email,
    String? profileImage,
    List<String>? skills,
    String? bio,
    String? availability,
    List<String>? socialLinks,
    String? experience,
    List<Connection>? connections,
    List<String>? savedHackathons,
    List<String>? savedProjects,
    List<String>? registeredHackathons,
    List<String>? registeredProjects,
    List<String>? ongoingProjects,
    List<String>? hackathonsParticipated,
    int? hackathonsParticipatedCount,
    int? ongoingProjectsCount,
    int? connectionsCount,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      skills: skills ?? this.skills,
      bio: bio ?? this.bio,
      availability: availability ?? this.availability,
      socialLinks: socialLinks ?? this.socialLinks,
      experience: experience ?? this.experience,
      connections: connections ?? this.connections,
      savedHackathons: savedHackathons ?? this.savedHackathons,
      savedProjects: savedProjects ?? this.savedProjects,
      registeredHackathons: registeredHackathons ?? this.registeredHackathons,
      registeredProjects: registeredProjects ?? this.registeredProjects,
      ongoingProjects: ongoingProjects ?? this.ongoingProjects,
      hackathonsParticipated: hackathonsParticipated ?? this.hackathonsParticipated,
      hackathonsParticipatedCount: hackathonsParticipatedCount ?? this.hackathonsParticipatedCount,
      ongoingProjectsCount: ongoingProjectsCount ?? this.ongoingProjectsCount,
      connectionsCount: connectionsCount ?? this.connectionsCount,
    );
  }
}

class Connection{
  final String id;
  final String name;
  final String? avatarUrl;

  Connection({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
        id: json['id'] ?? '',
        name: json['name'] ?? ''
    );
  }
}

