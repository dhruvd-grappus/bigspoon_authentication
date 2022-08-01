// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class CodeSentState extends AuthState {
  final String verificationID;
  CodeSentState(this.verificationID);
}

class VerifyingOTPState extends AuthState{
  final String phone;
  final String otp;
  VerifyingOTPState({
    this.phone = '',
    this.otp = '',
  });
  
}
