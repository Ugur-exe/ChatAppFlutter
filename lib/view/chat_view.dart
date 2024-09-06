import 'package:chatappwithflutter/model/chat_message_model.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key, this.fullName, this.status, this.imageUrl, this.chatId});
  final String? fullName;
  final String? status;
  final String? imageUrl;
  final String? chatId;

  List<ChatMessageModel> chatList = [
    ChatMessageModel(
        messageId: 1,
        chatId: '123',
        senderId: '321',
        receiverId: '123',
        messageText: 'Deneme',
        timestamp: '3.45 PM',
        isSeen: true)
  ];

  @override
  Widget build(BuildContext context) {
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
                  leading: Container(
                    width: 42,
                    height: 42,
                    child: Icon(Icons.person_2_outlined),
                  ),
                  title: Text(
                    fullName ?? "Empty",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(status ?? "-"),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.call_outlined),
                color: Colors.blue,
                iconSize: 25,
              )
            ],
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [Expanded(child: _buildChatList())],
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        return Row(
          children: [Text(chatList[index].messageText)],
        );
      },
    );
  }
}
