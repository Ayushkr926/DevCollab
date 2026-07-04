
class Hackathon {
  final String id;
  final String title;
  final String subtitle;
  final List<String> techTags;
  final String prize;
  final String type;
  final DateTime deadline;
  final bool isMatchingSkills;
  final int registeredCount;
  final String status;

  const Hackathon({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.techTags,
    required this.prize,
    required this.type,
    required this.deadline,
    required this.isMatchingSkills,
    required this.registeredCount,
    required this.status,
  });

  factory Hackathon.fromJson(Map<String, dynamic> json) {
    return Hackathon(
      id: json['_id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      techTags: List<String>.from(json['techTags'] as List? ?? []),
      prize: json['prize'] as String? ?? '',
      type: json['type'] as String? ?? 'hackathon',
      deadline: DateTime.parse(json['deadline'] as String),
      isMatchingSkills: json['isMatchingSkills'] as bool? ?? false,
      registeredCount: json['registeredCount'] as int? ?? 0,
      status: json['status'] as String? ?? 'open',
    );
  }

  Duration get timeRemaining => deadline.difference(DateTime.now());

  bool get isOpen => status == 'open' && timeRemaining.isNegative == false;

  // Countdown parts
  int get daysLeft => timeRemaining.inDays.clamp(0, 999);
  int get hoursLeft => (timeRemaining.inHours % 24).clamp(0, 23);
  int get minutesLeft => (timeRemaining.inMinutes % 60).clamp(0, 59);
  int get secondsLeft => (timeRemaining.inSeconds % 60).clamp(0, 59);
}


class DeveloperStory {
  final String userId;
  final String name;
  final String initials;

  /// Profile image
  final String profileImage;

  /// Story media (image/video)
  final String storyUrl;

  /// true = video, false = image
  final bool isVideo;

  /// Story viewed by current user
  final bool hasSeen;

  /// Border colors
  final String seenBorderColor;
  final String unseenBorderColor;

  const DeveloperStory({
    required this.userId,
    required this.name,
    required this.initials,
    required this.profileImage,
    required this.storyUrl,
    required this.isVideo,
    required this.hasSeen,
    required this.seenBorderColor,
    required this.unseenBorderColor,
  });

  factory DeveloperStory.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? '';

    return DeveloperStory(
      userId: json['_id'] ?? '',
      name: name,
      initials: _initials(name),

      profileImage: json['profileImage'] ?? '',
      storyUrl: json['storyUrl'] ?? '',

      isVideo: json['isVideo'] ?? false,
      hasSeen: json['hasSeen'] ?? false,

      seenBorderColor: json['seenBorderColor'] ?? '#9E9E9E',
      unseenBorderColor: json['unseenBorderColor'] ?? '#FF2D55',
    );
  }

  static String _initials(String name) {
    if (name.trim().isEmpty) return '';

    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'name': name,
      'profileImage': profileImage,
      'storyUrl': storyUrl,
      'isVideo': isVideo,
      'hasSeen': hasSeen,
      'seenBorderColor': seenBorderColor,
      'unseenBorderColor': unseenBorderColor,
    };
  }
}
// lib/models/home_user.dart

class HomeUser {
  final String id;
  final String name;
  final String initials;
  final int colorIndex;
  final int unreadNotifications;
  final int unreadMessages;

  const HomeUser({
    required this.id,
    required this.name,
    required this.initials,
    required this.colorIndex,
    required this.unreadNotifications,
    required this.unreadMessages,
  });

  factory HomeUser.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    return HomeUser(
      id: json['_id'] as String,
      name: name,
      initials: _initials(name),
      colorIndex: json['colorIndex'] as int? ?? 0,
      unreadNotifications: json['unreadNotifications'] as int? ?? 0,
      unreadMessages: json['unreadMessages'] as int? ?? 0,
    );
  }

  String get firstName => name.split(' ').first;

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }
}