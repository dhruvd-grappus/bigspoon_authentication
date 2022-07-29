import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/bloc/auth_bloc.dart';
import 'navigation/routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AuthBloc>().add(Logout());
        Navigator.pushReplacementNamed(context, Routes.googleSignInPage);
        return false;
      },
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Center(
              child: state is AuthenticatedState
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          const Text('Signed in!'),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(state.user.displayName.toString()),
                          Text(state.user.email.toString()),
                          Text(state.user.phoneNumber.toString())
                        ])
                  : const Text('Signed Out'),
            );
          },
        ),
      ),
    );
  }
}
