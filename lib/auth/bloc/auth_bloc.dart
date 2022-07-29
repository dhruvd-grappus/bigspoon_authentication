import 'dart:async';
import '../../base/abstract_bloc.dart';
import '../../base/action/navigation_action.dart';
import '../../navigation/routes.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../social_sign_in/social_sign_in.dart';

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

    on<InitiateSocialSignIn>(
      onInitiateSocialSignIn,
    );
  }

  final bigSpoonSocialSignIn = BigSpoonSocialSignIn();

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
