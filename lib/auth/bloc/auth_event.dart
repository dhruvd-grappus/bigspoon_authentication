part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class InitiateGoogleSignIn extends AuthEvent {}

class AutoSignIn extends AuthEvent {
  final User user;
  const AutoSignIn(this.user);
}

class Logout extends AuthEvent {}
