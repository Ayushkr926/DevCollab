
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

// lib/models/developer_story.dart

class DeveloperStory {
  final String userId;
  final String name;
  final String initials;
  final int colorIndex;
  final bool isOnline;
  final bool hasUnseenStory;

  const DeveloperStory({
    required this.userId,
    required this.name,
    required this.initials,
    required this.colorIndex,
    required this.isOnline,
    required this.hasUnseenStory,
  });

  factory DeveloperStory.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    return DeveloperStory(
      userId: json['_id'] as String,
      name: name,
      initials: _initials(name),
      colorIndex: json['colorIndex'] as int? ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
      hasUnseenStory: json['hasUnseenStory'] as bool? ?? false,
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
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