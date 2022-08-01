# bigspoon_authentication

Test module for SMS Auto Read Authentication and Google Sign In using ```bloc```


Uses a test Firebase project:https://console.firebase.google.com/u/0/project/bigspoon-test/overview

## Usage

- Use ```AuthPage``` widget in  ```auth_page.dart``` to test SMS Auto Read and Google Sign in Features

- Use ```AbstractBloc``` and ```AbstractBlocListener``` to handle authentication state changes.

---
## Steps to use OTP Auto Read


### Prerequisites For Firebase (works only For Android)
- Add the sha-1 and sha-256 key from google play app-signing in play console
- Enable device check API in cloud console
- Enable mobile authentication in Firebase console

 Firebase has custom messages and has auto read otp, ***in built in the plugin.***
 ```dart
 await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${event.phone}',
      /// Auto Read and verify OTP
      verificationCompleted: (credential) async {
        debugPrint('Verification Completed');
        add(EnterCredentialEvent(credential));
      },
     
    )
```
- Use ```credential.smsCode``` to access the auto-read OTP.


### Other SMS API
- This **requires** App Signature, which is mandatory in an sms .
- Follow this guide to use and send App Signature to API:https://pub.dev/packages/pinput#android


### Pinput

- Use pinput:https://pub.dev/packages/pinput, a Widget to auto read sms OTPs

```dart
Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      validator: (s) {
        return s == '2222' ? null : 'Pin is incorrect';
      },
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: (pin) => print(pin),
    )
```

---

## Steps to Integrate Google Sign In for a New App

1. Create a Firebase Project.
2. Add app to firebase project.
3. Enable Authentication + Google Authentication.
4. Add SHA keys.
5. Add Firebase dependencies in App.
5. Run flutterfire configure.


- Use 
```BigSpoonSocialLogin().signInWithGoogle()```
 to only open a dialog to choose a Google Account,
 
- Use
```dart
context.read<AuthBloc>.add(
    InitiateSocialSignIn(
        socialSignInType:SocialSignInType.google,
        )
    );
``` 
to execute the Google Sign In flow for a widget.



- Press back to sign out.


