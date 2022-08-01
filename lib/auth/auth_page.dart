import 'package:sms_autofill/sms_autofill.dart';

import 'base/abstract_bloc_listener.dart';
import 'base/action/navigation_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'navigation/routes.dart';
import 'bloc/auth_bloc.dart';
import 'package:pinput/pinput.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController otpController = TextEditingController();
  var smsAutoFill = SmsAutoFill();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication Page'),
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
            if (state is VerifyingOTPState) {
              otpController.text = state.otp;
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return state is AuthLoadingState
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: phoneController,
                          decoration:
                              InputDecoration(hintText: '+919000000000'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            await smsAutoFill.listenForCode();

                            context.read<AuthBloc>().add(
                                EnterPhoneEvent(phone: phoneController.text));
                          },
                          child: Text('Send OTP'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        state is CodeSentState
                            ? Column(
                                children: [
                                  Pinput(
                                    length: 6,
                                    controller: otpController,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.read<AuthBloc>().add(EnterCode(
                                            verificationId:
                                                state.verificationID,
                                            code: otpController.text,
                                          ));
                                    },
                                    child: Text('Verify OTP'),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            context.read<AuthBloc>().add(InitiateSocialSignIn(
                                  socialSignInType: SocialSignInType.google,
                                ));
                          },
                          child: Text(
                            'Sign In With Google',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(color: Colors.blue),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
