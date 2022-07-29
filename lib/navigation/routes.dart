import 'package:bigspoon_authentication/profile.dart';
import 'package:flutter/material.dart';

import '../auth/auth_page.dart';

class Routes {
  static const String googleSignInPage = 'googleSignInPage';
  static const String profilePage = 'profilePage';
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Widget widget = Scaffold(
      body: Container(),
    );
    switch (settings.name) {
      case googleSignInPage:
        widget = const AuthPage(title: 'Google Sign In');

        break;
      case profilePage:
        widget = const ProfilePage();

        break;
      default:
    }
    return MaterialPageRoute(builder: (_) => widget);
  }
}
