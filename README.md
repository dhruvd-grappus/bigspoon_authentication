# bigspoon_authentication

Test app for SMS Auto Read Authentication and Google Sign In

## Steps to Integrate Google Sign In for a New App

1. Create a Firebase Project.
2. Add app to firebase project.
3. Enable Authentication + Google Authentication.
4. Add SHA keys.
5. Add Firebase dependencies in App.
5. Run flutterfire configure.


## Usage


- Use ```AbstractBloc``` and ```AbstractBlocListener``` to handle authentication state changes.

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


