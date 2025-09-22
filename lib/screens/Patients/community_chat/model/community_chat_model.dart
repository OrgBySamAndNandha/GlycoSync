import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderName;
  final String senderId;
  final String text;
  final Timestamp timestamp;

  ChatMessage({
    required this.senderName,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  // Factory constructor to create a ChatMessage from a Firestore document
  factory ChatMessage.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      senderName: data['senderName'] ?? 'Anonymous',
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}

