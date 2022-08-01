// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'package:bigspoon_authentication/auth/bloc/auth_bloc.dart';

void main() {
  var mockFirebaseAuth = MockFirebaseAuth(signedIn: false);
  var authBloc = AuthBloc(firebaseAuth: mockFirebaseAuth);
  blocTest<AuthBloc, AuthState>(
    'Test to enter phone and auto read sms for otp',
    build: () {
      return authBloc;
    },
    seed: () => AuthInitial(),
    act: (bloc) async {
      bloc.add(const EnterPhoneEvent(phone: '+91111111111'));
      await Future.delayed(const Duration(milliseconds: 500));
      bloc.add(EnterCode(code: '000000', verificationId: 'verification-id'));
    },
    expect: () => [
      AuthLoadingState(),
      isA<CodeSentState>(),
      isA<VerifyingOTPState>(),
      isA<AuthenticatedState>()
    ],
  );



   blocTest<AuthBloc, AuthState>(
    'Test to emit Invalid phone for <10 digit phone number',
    build: () {
      return authBloc;
    },
   
    act: (bloc) async {
      bloc.add(const EnterPhoneEvent(phone: '+9111111'));
     
    },
    expect: () => [
      AuthLoadingState(),
      isA<InvalidPhoneState>(),
      
    ],
  );
}

class InvalidPhoneState extends AuthState8888888888888888888888888 {
}
