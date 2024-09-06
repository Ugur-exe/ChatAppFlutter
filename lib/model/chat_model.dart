class ChatModel {
  final String chatId; // Benzersiz chat ID'si
  final String receiverId;
  final String senderId; // Sohbete katılan kullanıcı ID'leri
  final String lastMessage; // Son mesajın metni
  final String lastMessageTimestamp; // Son mesajın gönderim zamanı
  final bool isGroupChat; // Grup sohbeti olup olmadığı bilgisi

  // Constructor
  ChatModel({
    this.chatId = "",
    this.receiverId = "",
    this.senderId = "",
    this.lastMessage = "",
    this.lastMessageTimestamp = "",
    this.isGroupChat = false,
  });

  // JSON'dan ChatModel nesnesi oluşturmak için
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

  // ChatModel nesnesini JSON'a dönüştürmek için
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
