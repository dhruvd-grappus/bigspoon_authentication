part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthenticatedState extends AuthState {
  final User user;

  const AuthenticatedState(this.user);
}

class AuthLoadingState extends AuthState {}
