import 'package:chatappwithflutter/service/firebase/user_status/cubit/user_status_cubit.dart';
import 'package:chatappwithflutter/ui/chat/cubit/cubit/chat_cubit_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatView extends HookWidget {
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
  Widget build(BuildContext context) {
    final _messageController = useTextEditingController();
    final _scrollController = useScrollController();
    final _showScrollToBottomButton =
        useState(false); // Hook ile state yönetimi

    final userStatusCubit = BlocProvider.of<UserStatusCubit>(context);
    userStatusCubit.readStatusInfo(receiverId!);
    String _status = '';
    useEffect(() {
      final chatCubit = BlocProvider.of<ChatCubitCubit>(context);
      void listener() {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final currentScrollPosition = _scrollController.offset;
        _showScrollToBottomButton.value =
            currentScrollPosition < maxScrollExtent - 10;
      }

      _scrollController.addListener(listener);
      return () {
        print('Dİnleyiciler Kapatıldı');
        _scrollController.removeListener(listener);
        chatCubit.stopListeningMessages();
      };
    }, [_scrollController]);

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
                    fullName ?? "Empty",
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
          if (_showScrollToBottomButton.value)
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
          _MessageInput(
              messageController: _messageController,
              scrollController: _scrollController,
              receiverId: receiverId!,
              chatId: chatId!)
        ],
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput(
      {required this.messageController,
      required this.scrollController,
      required this.receiverId,
      required this.chatId});
  final TextEditingController messageController;
  final ScrollController scrollController;
  final String receiverId;
  final String chatId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
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
              if (messageController.text.isNotEmpty) {
                context.read<ChatCubitCubit>().sendMessageWithUIUpdates(
                    messageController,
                    scrollController,
                    receiverId,
                    chatId,
                    context);
              }
            },
          ),
        ],
      ),
    );
  }
}
