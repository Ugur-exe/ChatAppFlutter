part of 'user_status_cubit.dart';

@immutable
sealed class UserStatusState {}

final class UserStatusInitial extends UserStatusState {}

final class UserStatusUpdated extends UserStatusState {
  final String userStatus;
  UserStatusUpdated({required this.userStatus});
}

final class UserStatusLoaded extends UserStatusState {
  final String userStatus;
  UserStatusLoaded({required this.userStatus});
}

final class UserStatusError extends UserStatusState {
  final String errorMessage;
  UserStatusError({required this.errorMessage});
}
