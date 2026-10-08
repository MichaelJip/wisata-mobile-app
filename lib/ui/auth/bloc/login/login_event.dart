part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final LoginRequestModel request;
  LoginSubmitted(this.request);
}
