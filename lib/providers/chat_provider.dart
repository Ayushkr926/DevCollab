import 'package:flutter/material.dart';

import '../models/messagemodel.dart';

class ChatProvider with ChangeNotifier {
  List<MessageModel> _messages = [];
  bool _isTyping = false;

  List<MessageModel> get messages => _messages;
  bool get isTyping => _isTyping;

  ChatProvider() {
    _loadDemoMessages();
  }

  void _loadDemoMessages() {
    _messages = [
      MessageModel(
        id: "1",
        text: "Hey! Saw your Flutter work in the showcase. Impressive!",
        isSentByMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
      ),
      MessageModel(
        id: "2",
        text: "Thanks! Your ML visualizer was really clean too.",
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 33)),
      ),
      MessageModel(
        id: "3",
        text: "Want to team up for the HackIndia hackathon next week?",
        isSentByMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      MessageModel(
        id: "4",
        text: "100%! I can handle Flutter + UI, you take the ML backend?",
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
      ),
    ];
    notifyListeners();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    _messages.add(MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isSentByMe: true,
      timestamp: DateTime.now(),
    ));
    notifyListeners();

    // Simulate reply
    _simulateReply();
  }

  void _simulateReply() {
    _isTyping = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _isTyping = false;
      _messages.add(MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "Sounds good! Let's discuss details.",
        isSentByMe: false,
        timestamp: DateTime.now(),
      ));
      notifyListeners();
    });
  }
}