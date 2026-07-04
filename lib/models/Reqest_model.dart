class RequestModel {
  final String id;
  final String name;
  final String role;
  final String? company;
  final String? avatarUrl;
  final String? message;
  final String status;
  final bool isUnread;
  final bool isVerified;
  final bool isOnline;
  final int mutualConnections;
  final List<String> skills;
  final DateTime createdAt;
  final DateTime? respondedAt;

  const RequestModel({
    required this.id,
    required this.name,
    required this.role,
    this.company,
    this.avatarUrl,
    this.message,
    this.status = "Pending",
    this.isUnread = false,
    this.isVerified = false,
    this.isOnline = false,
    this.mutualConnections = 0,
    this.skills = const [],
    required this.createdAt,
    this.respondedAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      company: json['company']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      message: json['message']?.toString(),
      status: json['status']?.toString() ?? 'Pending',
      isUnread: json['isUnread'] == true,
      isVerified: json['isVerified'] == true,
      isOnline: json['isOnline'] == true,
      mutualConnections: json['mutualConnections'] is int
          ? json['mutualConnections'] as int
          : int.tryParse(json['mutualConnections']?.toString() ?? '') ?? 0,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
      respondedAt: json['respondedAt'] != null
          ? DateTime.tryParse(json['respondedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'company': company,
      'avatarUrl': avatarUrl,
      'message': message,
      'status': status,
      'isUnread': isUnread,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'mutualConnections': mutualConnections,
      'skills': skills,
      'createdAt': createdAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
    };
  }

  RequestModel copyWith({
    String? id,
    String? name,
    String? role,
    String? company,
    String? avatarUrl,
    String? message,
    String? status,
    bool? isUnread,
    bool? isVerified,
    bool? isOnline,
    int? mutualConnections,
    List<String>? skills,
    DateTime? createdAt,
    DateTime? respondedAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      company: company ?? this.company,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      message: message ?? this.message,
      status: status ?? this.status,
      isUnread: isUnread ?? this.isUnread,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      mutualConnections: mutualConnections ?? this.mutualConnections,
      skills: skills ?? this.skills,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  @override
  String toString() {
    return 'RequestModel(id: $id, name: $name, role: $role, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RequestModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}