import 'package:bloc/bloc.dart';
import 'package:chatappwithflutter/model/chat_message_model.dart';
import 'package:chatappwithflutter/repository/firebase/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'chat_cubit_state.dart';

class ChatCubitCubit extends Cubit<ChatCubitState> implements Chats {
  ChatCubitCubit() : super(ChatCubitInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late String currentChatId;

  void initializeChat(String receiverId) {
    currentChatId = createChatId(receiverId);
    getMessage();
  }
  String createChatId(String receiverId) {
    final ids = [_currentUserId, receiverId]..sort();
    print('ChatId: ${ids[0]}_${ids[1]}');
    return "${ids[0]}_${ids[1]}";
  }

  @override
  Future getMessage() async {
    _firestore
        .collection('chats')
        .doc(currentChatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      final List<ChatMessageModel> userList = snapshot.docs.map(
        (doc) {
          final data = doc.data();
          return ChatMessageModel(
            chatId: data['chatId'],
            seen: data['seen'],
            messageId: data['messageId'],
            messageText: data['messageText'],
            receiverId: data['receiverId'],
            senderId: data['senderId'],
            timestamp: data['timestamp'] as Timestamp,
          );
        },
      ).toList();

      emit(ChatLoadedMessage(loadMessage: userList));
    }, onError: (e) {
      emit(ChatLoadedMessageError(errorMessage: e.toString()));
    });
  }

  @override
  Future sendMessage(String senderId, String receiverId, String chatId,
      String messageText) async {
    try {
      final message = ChatMessageModel(
        messageId: 0, // ID Firestore tarafından otomatik verilecek
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        messageText: messageText,
        timestamp: Timestamp.now(),
        seen: false,
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'chatId': message.chatId,
        'messageId': message.messageId,
        'messageText': message.messageText,
        'receiverId': message.receiverId,
        'senderId': message.senderId,
        'seen': message.seen,
        'timestamp': message.timestamp,
      });

      // Mesaj gönderildikten sonra, getMessage'i çağırarak yeni mesajları almak
      getMessage(); // Burada chatId ile getMessage çağrılır
    } catch (e) {
      emit(ChatSendMessageError(
          messageError: 'Mesaj gönderilirken bir hata oluştu: $e'));
    }
  }

  
}
