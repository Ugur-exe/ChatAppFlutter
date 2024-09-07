abstract class Chats {
  Future sendMessage(
      String senderId, String receiverId, String chatId, String messageText);
  Future getMessage(String chatId);
}
