part of 'login_cubit.dart';

@immutable
sealed class LoginState {
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {}

final class AuthLoading extends LoginState {}

final class AuthAuthenticated extends LoginState {
  final User? user;

  AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

final class AuthError extends LoginState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
