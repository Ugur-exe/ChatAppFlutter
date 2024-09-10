import 'package:chatappwithflutter/service/firebase/user_status/cubit/user_status_cubit.dart';
import 'package:chatappwithflutter/ui/chat/cubit/cubit/chat_cubit_cubit.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottomButton = false;

  

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  final maxScrollExtent =
                      _scrollController.position.maxScrollExtent;
                  final currentScrollPosition = _scrollController.offset;
                  setState(() {
                    _showScrollToBottomButton =
                        currentScrollPosition < maxScrollExtent - 10;
                  });
                }
                return true;
              },
              child: BlocConsumer<ChatCubitCubit, ChatCubitState>(
                listener: (context, state) {
                  if (state is ChatLoadedMessage) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    });
                  }
                },
                builder: (context, state) {
                  if (state is ChatCubitInitial) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  } else if (state is ChatLoadedMessage) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.loadMessage.length,
                      itemBuilder: (context, index) {
                        final message = state.loadMessage[index];
                        bool isCurrentUser = message.senderId ==
                            FirebaseAuth.instance.currentUser!.uid;
                        return Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.blue[100]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(message.messageText),
                          ),
                        );
                      },
                    );
                  } else if (state is ChatLoadedMessageError) {
                    return Center(
                      child: Text('Hata Oluştu: ${state.errorMessage}'),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          if (_showScrollToBottomButton)
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(Icons.arrow_downward_outlined),
              ),
            ),
          _buildMessageInput(),
        ],
      ),
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
    if (_messageController.text.isNotEmpty) {
      final senderId = FirebaseAuth.instance.currentUser?.uid;
      if (senderId != null &&
          widget.receiverId != null &&
          widget.chatId != null) {
        BlocProvider.of<ChatCubitCubit>(context)
            .sendMessage(
          senderId,
          widget.receiverId!,
          widget.chatId!,
          _messageController.text,
        )
            .then((_) {
          // Mesaj gönderildikten sonra mesaj alanını temizle
          _messageController.clear();
          // Mesaj gönderildikten sonra en alta kaydır
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          });
        }).catchError((error) {
          print('Mesaj gönderilirken hata oluştu: $error');
        });
      }
    }
  }
}
