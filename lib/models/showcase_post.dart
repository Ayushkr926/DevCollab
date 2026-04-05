
class ShowcasePost {
  final String id;
  final String title;
  final String imageUrl;
  final String techStack;
  final String authorId;
  final String authorName;
  final String authorInitials;
  final int authorColorIndex;
  final int likes;
  final bool isLikedByMe;
  final bool isTrending;
  final String timeAgo;
  final int viewCount;

  const ShowcasePost({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.techStack,
    required this.authorId,
    required this.authorName,
    required this.authorInitials,
    required this.authorColorIndex,
    required this.likes,
    required this.isLikedByMe,
    required this.isTrending,
    required this.timeAgo,
    required this.viewCount,
  });

  factory ShowcasePost.fromJson(Map<String, dynamic> json) {
    return ShowcasePost(
      id: json['_id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      techStack: json['techStack'] as String? ?? '',
      authorId: (json['author'] as Map<String, dynamic>)['_id'] as String,
      authorName: (json['author'] as Map<String, dynamic>)['name'] as String,
      authorInitials: _initials(
          (json['author'] as Map<String, dynamic>)['name'] as String),
      authorColorIndex:
      (json['author'] as Map<String, dynamic>)['colorIndex'] as int? ?? 0,
      likes: json['likeCount'] as int? ?? 0,
      isLikedByMe: json['isLikedByMe'] as bool? ?? false,
      isTrending: json['isTrending'] as bool? ?? false,
      timeAgo: json['timeAgo'] as String? ?? '',
      viewCount: json['viewCount'] as int? ?? 0,
    );
  }

  ShowcasePost copyWith({bool? isLikedByMe, int? likes}) {
    return ShowcasePost(
      id: id,
      title: title,
      imageUrl: imageUrl,
      techStack: techStack,
      authorId: authorId,
      authorName: authorName,
      authorInitials: authorInitials,
      authorColorIndex: authorColorIndex,
      likes: likes ?? this.likes,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      isTrending: isTrending,
      timeAgo: timeAgo,
      viewCount: viewCount,
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }
}