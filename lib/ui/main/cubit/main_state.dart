part of 'main_cubit.dart';

@immutable
sealed class MainState {}

final class MainInitial extends MainState {}

final class MainLoaded extends MainState {
  final List<UserModel> users;

  MainLoaded({required this.users});
}

final class MainError extends MainState {
  final String message = '';
  MainError({required message});
}

