part of 'chat_cubit_cubit.dart';

@immutable
sealed class ChatCubitState {
 
}

final class ChatCubitInitial extends ChatCubitState {}

final class ChatLoadedMessage extends ChatCubitState {
   final List<ChatMessageModel> loadMessage;

  ChatLoadedMessage({required this.loadMessage});
}

final class ChatLoadedMessageError extends ChatCubitState {
  final String errorMessage;
  ChatLoadedMessageError({required this.errorMessage});
}

final class ChatSendMessage extends ChatCubitState {
  final List<ChatMessageModel> sendMessage;

  ChatSendMessage({required this.sendMessage});
}

final class ChatSendMessageError extends ChatCubitState {
  final String messageError;

  ChatSendMessageError({required this.messageError});
}
