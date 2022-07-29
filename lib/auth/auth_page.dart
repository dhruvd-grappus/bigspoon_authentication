import 'package:bigspoon_authentication/base/abstract_bloc_listener.dart';
import 'package:bigspoon_authentication/base/action/navigation_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../navigation/routes.dart';
import 'bloc/auth_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: AbstractBlocListener<AuthBloc, AuthEvent, AuthState>(
          onNavigationAction: (action) {
            if (action is DisplayScreen) {
              Navigator.pushReplacementNamed(context, action.screenName);
            } else if (action is ToastAction) {
              Fluttertoast.showToast(msg: action.message);
            }
          },
          listener: (context, state) {
            if (state is AuthenticatedState) {
              Navigator.pushReplacementNamed(context, Routes.profilePage);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return state is AuthLoadingState
                  ? const CircularProgressIndicator()
                  : InkWell(
                      onTap: () {
                        context.read<AuthBloc>().add(InitiateGoogleSignIn());
                      },
                      child: Text(
                        'Sign In With Google',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.blue),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
