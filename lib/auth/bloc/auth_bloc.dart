import 'dart:async';
import '../base/abstract_bloc.dart';
import '../base/action/navigation_action.dart';
import '../navigation/routes.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../social_sign_in/social_sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends AbstractBloc<AuthEvent, AuthState> {
  final FirebaseAuth firebaseAuth;
  AuthBloc({BigSpoonSocialSignIn? customSignIn, required this.firebaseAuth})
      : super(AuthInitial()) {
    bigSpoonSocialSignIn = customSignIn ?? BigSpoonSocialSignIn(firebaseAuth);
    firebaseAuth.authStateChanges().listen(((user) {
      if (user != null) {
        add(AutoSignIn(user));
      } else if (state is AuthenticatedState) {
        add(Logout());
      }
    }));
    on<EnterCode>(
      (event, emit) async {
        emit(VerifyingOTPState(otp: event.code));
        final credential = PhoneAuthProvider.credential(
            verificationId: event.verificationId, smsCode: event.code);

        await firebaseAuth.signInWithCredential(credential);
      },
    );
    on<EnterCredentialEvent>(
      (event, emit) async {
        emit(VerifyingOTPState(
            otp: (event.userCredential as PhoneAuthCredential).smsCode ?? ''));
        await Future.delayed(Duration(seconds: 1));
        await firebaseAuth.signInWithCredential(event.userCredential);
      },
    );
    on<EnterPhoneEvent>(
      _onEnterPhoneEvent,
    );

    on<Logout>(((event, emit) async {
      await FirebaseAuth.instance.signOut();
      emit(AuthInitial());
    }));
    on<AutoSignIn>((event, emit) {
      emit(AuthenticatedState(event.user));
    });

    on<InitiateSocialSignIn>(
      onInitiateSocialSignIn,
    );
  }

  FutureOr<void> _onEnterPhoneEvent(event, emit) async {
    emit(AuthLoadingState());

    /// See why there is a completer:
    ///
    /// https://github.com/felangel/bloc/issues/2961#issuecomment-1025144654
    Completer<AuthState> c = Completer<AuthState>();

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: '${event.phone}',

      verificationCompleted: (credential) async {
        debugPrint('Verification Completed');
        add(EnterCredentialEvent(credential));
      },
      verificationFailed: (authException) {
        // c.complete(FailureAuthState(authException.code));
      },
      codeSent: (String verificationId, _) {
        c.complete(CodeSentState(verificationId));
      },
      // ignore: no-empty-block
      codeAutoRetrievalTimeout: (_) {},
    );
    final stateToReturn = await c.future;
    emit(stateToReturn);
  }

  late BigSpoonSocialSignIn bigSpoonSocialSignIn;

  Future<void> onInitiateSocialSignIn(InitiateSocialSignIn event, emit) async {
    try {
      emit(AuthLoadingState());

      final socialUser = await bigSpoonSocialSignIn
          .signInWithSocialAccount(event.socialSignInType);
      if (socialUser != null) {
        emit(AuthenticatedState(socialUser));
        onNavigationAction(DisplayScreen(screenName: Routes.profilePage));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      debugPrint(e.toString());
      onNavigationAction(ToastAction(message: e.toString()));
      emit(AuthInitial());
    }
  }
}
