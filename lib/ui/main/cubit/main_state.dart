part of 'main_cubit.dart';

@immutable
sealed class MainState {
  List<Object?> get props => [];
}

final class MainInitial extends MainState {}

final class MainLoaded extends MainState {
  final List<UserModel> users;

  MainLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

final class MainError extends MainState {
  final String message = '';
  MainError({required message});
}

final class CreateChatId extends MainState {
  final String chatId;
  CreateChatId({required this.chatId});
}
