import 'package:flutter/material.dart';
import 'user_base.dart';
import 'constants.dart';
import 'helper.dart';
import 'loginScreen.dart';
import 'signUpScreen.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/login_required';

  final UserBase implementsUser;
  AuthScreen(this.implementsUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: Image.asset(
                MediaQuery.of(context).platformBrightness == Brightness.light ? 'assets/logo-full.png' : 'assets/logo-full-dark.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 32, right: 16, bottom: 8),
            child: Text(
              'Welcome!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: ElevatedButton(
                child: Text(
                  'Log In',
                ),
                onPressed: () => push(
                  context,
                  new LoginScreen(implementsUser),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: 40.0, left: 40.0, top: 20, bottom: 20
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: OutlinedButton(
                child: Text('Sign Up'),
                onPressed: () =>
                    push(context, new SignUpScreen(implementsUser)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
