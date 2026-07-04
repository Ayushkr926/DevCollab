class MessageModel {
  final String id;
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
  });
}