import 'package:flutter/material.dart';
import '../models/chatmodel.dart';

class ChatsProvider with ChangeNotifier {
  List<ChatModel> _chats = [];
  bool _isLoading = false;

  List<ChatModel> get chats => _chats;
  bool get isLoading => _isLoading;

  ChatsProvider() {
    _loadDemoChats();
  }

  void _loadDemoChats() {
    _isLoading = true;
    notifyListeners();

    _chats = [
      ChatModel(
        id: "1",
        name: "Sneha Rao",
        role: "Flutter Developer",
        lastMessage: "100%! I can handle Flutter + UI...",
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 12)),
        unreadCount: 2,
        isOnline: true,
      ),
      ChatModel(
        id: "2",
        name: "Akash Sharma",
        role: "Full Stack Developer",
        lastMessage: "When can we schedule the call?",
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 0,
        isOnline: false,
      ),
      ChatModel(
        id: "3",
        name: "Priya Singh",
        role: "UI/UX Designer",
        lastMessage: "I sent you the latest design files",
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 7)),
        unreadCount: 1,
        isOnline: true,
      ),
      ChatModel(
        id: "4",
        name: "Rahul Verma",
        role: "Backend Engineer",
        lastMessage: "Thanks for the collaboration!",
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: false,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void markAsRead(String chatId) {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      _chats[index] = ChatModel(
        id: _chats[index].id,
        name: _chats[index].name,
        role: _chats[index].role,
        avatarUrl: _chats[index].avatarUrl,
        lastMessage: _chats[index].lastMessage,
        lastMessageTime: _chats[index].lastMessageTime,
        unreadCount: 0,
        isOnline: _chats[index].isOnline,
      );
      notifyListeners();
    }
  }
}