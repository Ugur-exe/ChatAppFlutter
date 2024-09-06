import 'package:chatappwithflutter/model/chat_message_model.dart';
import 'package:chatappwithflutter/service/firebase/user_status/cubit/user_status_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    this.fullName,
    this.imageUrl,
    this.chatId,
    this.receiverId,
  });
  final String? fullName;
  final String? imageUrl;
  final String? chatId;
  final String? receiverId;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<ChatMessageModel> chatList = [
    ChatMessageModel(
        messageId: 1,
        chatId: '123',
        senderId: '321',
        receiverId: '123',
        messageText: 'Merhaba, nasılsın?',
        timestamp: '3.45 PM',
        isSeen: true),
    ChatMessageModel(
        messageId: 2,
        chatId: '123',
        senderId: '123',
        receiverId: '321',
        messageText: 'İyiyim, teşekkür ederim!',
        timestamp: '3.46 PM',
        isSeen: true),
  ];

  String currentUserId = '321';

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userStatusCubit = BlocProvider.of<UserStatusCubit>(context);
    userStatusCubit.readStatusInfo(widget.receiverId!);
    String _status = '';
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: ListTile(
                  leading: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(Icons.person_2_outlined),
                  ),
                  title: Text(
                    widget.fullName ?? "Empty",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: BlocConsumer<UserStatusCubit, UserStatusState>(
                    listener: (context, state) {
                      if (state is UserStatusLoaded) {
                        _status = state.userStatus;
                      } else if (state is UserStatusError) {
                        _status = state.errorMessage;
                      }
                    },
                    builder: (context, state) {
                      return Text(_status);
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call_outlined),
                color: Colors.blue,
                iconSize: 25,
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildChatList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        bool isCurrentUser = chatList[index].senderId == currentUserId;
        return Align(
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(chatList[index].messageText),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Mesaj yazın...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                _sendMessage();
              }
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    print("Mesaj gönderildi: ${_messageController.text}");

    _messageController.clear();
  }
}
