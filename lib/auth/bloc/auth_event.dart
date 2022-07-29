// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

enum SocialSignInType {
  google,
  facebook,
  twitter,
}

class InitiateSocialSignIn extends AuthEvent {
  SocialSignInType socialSignInType;
  InitiateSocialSignIn({
    required this.socialSignInType,
  });
}

class AutoSignIn extends AuthEvent {
  final User user;
  const AutoSignIn(this.user);
}

class Logout extends AuthEvent {}
