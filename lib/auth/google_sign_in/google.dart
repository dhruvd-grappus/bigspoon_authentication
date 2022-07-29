import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class BigSpoonSocialSignIn {
  final googleSignIn = GoogleSignIn();

  /// Returns a Firebase [User] upon success
  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow

    try {
      await googleSignIn.disconnect();

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Sign in failed
        return null;
      }
      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
