part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class VisibilityChanged extends AuthState {}


final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class MailSentSuccess extends AuthState {}


final class AuthFail extends AuthState {
  String error;
  AuthFail({required this.error});
}

final class MailSendFail extends AuthState {
  String error;
  MailSendFail({required this.error});
}
