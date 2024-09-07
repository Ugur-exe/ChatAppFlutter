

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final int messageId;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String messageText;
  final Timestamp timestamp;
  final bool isSeen;

  ChatMessageModel(
      {required this.messageId,
      required this.chatId,
      required this.senderId,
      required this.receiverId,
      required this.messageText,
      required this.timestamp,
      required this.isSeen});

  
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
        messageId: json["messageId"],
        chatId: json["chatId"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        messageText: json["messageText"],
        timestamp: json["timestamp"],
        isSeen: json["isSeen"]);
  }

  
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': messageText,
      'timestamp': timestamp,
      'isSeen': isSeen
    };
  }
}
