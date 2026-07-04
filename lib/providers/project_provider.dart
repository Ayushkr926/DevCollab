import 'package:flutter/material.dart';

enum JoinStatus { none, pending, joined }

class TeamMember {
  final String name;
  final String role;
  final bool isOwner;
  const TeamMember({required this.name, required this.role, this.isOwner = false});
}

class Comment {
  final String author;
  final String text;
  final String time;
  const Comment({required this.author, required this.text, required this.time});
}

class ProjectProvider extends ChangeNotifier {
  Map<String, dynamic> project;
  JoinStatus _joinStatus = JoinStatus.none;
  bool _isBookmarked = false;
  bool _descriptionExpanded = false;

  final List<TeamMember> team;
  final List<Comment> _comments = [
    const Comment(author: "Sara Iqbal", text: "Excited to be part of this!", time: "2h ago"),
    const Comment(author: "Devansh Roy", text: "Can we use Riverpod instead?", time: "5h ago"),
  ];

  ProjectProvider({required this.project})
      : team = [
    TeamMember(name: project['owner'] ?? 'Owner', role: "Project Lead", isOwner: true),
    const TeamMember(name: "Meera Nair", role: "UI Designer"),
    const TeamMember(name: "Karan Verma", role: "Flutter Dev"),
  ];

  JoinStatus get joinStatus => _joinStatus;
  bool get isBookmarked => _isBookmarked;
  bool get descriptionExpanded => _descriptionExpanded;
  List<Comment> get comments => List.unmodifiable(_comments);

  void toggleBookmark() {
    _isBookmarked = !_isBookmarked;
    notifyListeners();
  }

  void toggleDescription() {
    _descriptionExpanded = !_descriptionExpanded;
    notifyListeners();
  }

  Future<void> requestToJoin() async {
    if (_joinStatus != JoinStatus.none) return;
    _joinStatus = JoinStatus.pending;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 900));
    _joinStatus = JoinStatus.joined;
    notifyListeners();
  }

  void addComment(String text) {
    if (text.trim().isEmpty) return;
    _comments.insert(0, Comment(author: "You", text: text.trim(), time: "Just now"));
    notifyListeners();
  }
}