import '../profile.dart';
import 'package:flutter/material.dart';

import '../auth_page.dart';

class Routes {
  static const String googleSignInPage = 'googleSignInPage';
  static const String profilePage = 'profilePage';
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Widget widget = Scaffold(
      body: Container(),
    );
    switch (settings.name) {
      case googleSignInPage:
        widget =  AuthPage();

        break;
      case profilePage:
        widget = const ProfilePage();

        break;
      default:
    }
    return MaterialPageRoute(builder: (_) => widget);
  }
}
