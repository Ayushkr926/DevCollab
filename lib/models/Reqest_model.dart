class RequestModel {
  final String id;

  /// Requester Details
  final String requesterId;
  final String requesterName;
  final String requesterProfileImage;
  final String requesterHeadline;
  final int requesterHackathonsParticipatedCount;
  final int requesterOngoingProjectsCount;
  final int requesterConnectionsCount;

  /// Recipient Details
  final String recipientId;
  final String recipientName;
  final String recipientProfileImage;
  final String recipientHeadline;
  final int recipientHackathonsParticipatedCount;
  final int recipientOngoingProjectsCount;
  final int recipientConnectionsCount;

  /// Request Info
  final String message;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? respondedAt;

  const RequestModel({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    required this.requesterProfileImage,
    required this.requesterHeadline,
    required this.requesterHackathonsParticipatedCount,
    required this.requesterOngoingProjectsCount,
    required this.requesterConnectionsCount,
    required this.recipientId,
    required this.recipientName,
    required this.recipientProfileImage,
    required this.recipientHeadline,
    required this.recipientHackathonsParticipatedCount,
    required this.recipientOngoingProjectsCount,
    required this.recipientConnectionsCount,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.respondedAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    final requester = json['requester'] as Map<String, dynamic>? ?? {};
    final recipient = json['recipient'] as Map<String, dynamic>? ?? {};

    return RequestModel(
      id: json['_id']?.toString() ?? '',

      requesterId: requester['_id']?.toString() ?? '',
      requesterName: requester['name']?.toString() ?? '',
      requesterProfileImage: requester['profileImage']?.toString() ?? '',
      requesterHeadline: requester['headline']?.toString() ?? '',
      requesterHackathonsParticipatedCount:
      requester['hackathonsParticipatedCount'] ?? 0,
      requesterOngoingProjectsCount:
      requester['ongoingProjectsCount'] ?? 0,
      requesterConnectionsCount:
      requester['connectionsCount'] ?? 0,

      recipientId: recipient['_id']?.toString() ?? '',
      recipientName: recipient['name']?.toString() ?? '',
      recipientProfileImage: recipient['profileImage']?.toString() ?? '',
      recipientHeadline: recipient['headline']?.toString() ?? '',
      recipientHackathonsParticipatedCount:
      recipient['hackathonsParticipatedCount'] ?? 0,
      recipientOngoingProjectsCount:
      recipient['ongoingProjectsCount'] ?? 0,
      recipientConnectionsCount:
      recipient['connectionsCount'] ?? 0,

      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',

      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),

      updatedAt: DateTime.tryParse(
        json['updatedAt']?.toString() ?? '',
      ) ??
          DateTime.now(),

      respondedAt: json['respondedAt'] != null
          ? DateTime.tryParse(json['respondedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'requester': {
        '_id': requesterId,
        'name': requesterName,
        'profileImage': requesterProfileImage,
        'headline': requesterHeadline,
        'hackathonsParticipatedCount':
        requesterHackathonsParticipatedCount,
        'ongoingProjectsCount':
        requesterOngoingProjectsCount,
        'connectionsCount':
        requesterConnectionsCount,
      },
      'recipient': {
        '_id': recipientId,
        'name': recipientName,
        'profileImage': recipientProfileImage,
        'headline': recipientHeadline,
        'hackathonsParticipatedCount':
        recipientHackathonsParticipatedCount,
        'ongoingProjectsCount':
        recipientOngoingProjectsCount,
        'connectionsCount':
        recipientConnectionsCount,
      },
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
    };
  }

  RequestModel copyWith({
    String? id,
    String? requesterId,
    String? requesterName,
    String? requesterProfileImage,
    String? requesterHeadline,
    int? requesterHackathonsParticipatedCount,
    int? requesterOngoingProjectsCount,
    int? requesterConnectionsCount,
    String? recipientId,
    String? recipientName,
    String? recipientProfileImage,
    String? recipientHeadline,
    int? recipientHackathonsParticipatedCount,
    int? recipientOngoingProjectsCount,
    int? recipientConnectionsCount,
    String? message,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? respondedAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      requesterProfileImage:
      requesterProfileImage ?? this.requesterProfileImage,
      requesterHeadline:
      requesterHeadline ?? this.requesterHeadline,
      requesterHackathonsParticipatedCount:
      requesterHackathonsParticipatedCount ??
          this.requesterHackathonsParticipatedCount,
      requesterOngoingProjectsCount:
      requesterOngoingProjectsCount ??
          this.requesterOngoingProjectsCount,
      requesterConnectionsCount:
      requesterConnectionsCount ??
          this.requesterConnectionsCount,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      recipientProfileImage:
      recipientProfileImage ?? this.recipientProfileImage,
      recipientHeadline:
      recipientHeadline ?? this.recipientHeadline,
      recipientHackathonsParticipatedCount:
      recipientHackathonsParticipatedCount ??
          this.recipientHackathonsParticipatedCount,
      recipientOngoingProjectsCount:
      recipientOngoingProjectsCount ??
          this.recipientOngoingProjectsCount,
      recipientConnectionsCount:
      recipientConnectionsCount ??
          this.recipientConnectionsCount,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  @override
  String toString() {
    return 'RequestModel(id: $id, requester: $requesterName, recipient: $recipientName, status: $status)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RequestModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}