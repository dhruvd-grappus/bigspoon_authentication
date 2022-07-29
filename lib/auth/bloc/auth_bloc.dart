import 'dart:async';
import 'package:bigspoon_authentication/auth/google_sign_in/google.dart';
import 'package:bigspoon_authentication/base/abstract_bloc.dart';
import 'package:bigspoon_authentication/base/action/navigation_action.dart';
import 'package:bigspoon_authentication/navigation/routes.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends AbstractBloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    FirebaseAuth.instance.authStateChanges().listen(((user) {
      if (user != null) {
        add(AutoSignIn(user));
      } else if (state is AuthenticatedState) {
        add(Logout());
      }
    }));
    on<Logout>(((event, emit) async {
      await FirebaseAuth.instance.signOut();
      emit(AuthInitial());
    }));
    on<AutoSignIn>((event, emit) {
      emit(AuthenticatedState(event.user));
    });

    on<InitiateGoogleSignIn>(
      onInitiateGoogleSignIn,
    );
  }

  final bigSpoonSocialSignIn = BigSpoonSocialSignIn();

  Future<void> onInitiateGoogleSignIn(event, emit) async {
    try {
      emit(AuthLoadingState());

      final googleUser = await bigSpoonSocialSignIn.signInWithGoogle();
      if (googleUser != null) {
        emit(AuthenticatedState(googleUser));
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
