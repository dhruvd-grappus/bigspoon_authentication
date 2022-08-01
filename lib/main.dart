import 'package:firebase_auth/firebase_auth.dart';

import 'auth/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth_page.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/navigation/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign In Demo',
      home: BlocProvider(
        lazy: false,
        create: (context) => AuthBloc(firebaseAuth: FirebaseAuth.instance),
        child: MaterialApp(routes: {
          Routes.googleSignInPage: (context) =>
               AuthPage(),
          Routes.profilePage: (context) => const ProfilePage(),
        }, home:  AuthPage()),
      ),
    );
  }
}
