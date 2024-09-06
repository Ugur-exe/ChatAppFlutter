class ChatModel {
  final String chatId; 
  final String receiverId;
  final String senderId; 
  final String lastMessage; 
  final String lastMessageTimestamp; 
  final bool isGroupChat; 

  
  ChatModel({
    this.chatId = "",
    this.receiverId = "",
    this.senderId = "",
    this.lastMessage = "",
    this.lastMessageTimestamp = "",
    this.isGroupChat = false,
  });

  
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chatId'] ?? "",
      receiverId: json['receiverId'] ?? "",
      senderId: json['senderId'] ?? "",
      lastMessage: json['lastMessage'] ?? "",
      lastMessageTimestamp: json['lastMessageTimestamp'] ?? "",
      isGroupChat: json['isGroupChat'] ?? false,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'receiverId': receiverId,
      'senderId': senderId,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp,
      'isGroupChat': isGroupChat,
    };
  }
}
