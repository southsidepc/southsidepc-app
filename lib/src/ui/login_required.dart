import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:firebase_auth/firebase_auth.dart';

import "package:southsidepc/src/models/user_state.dart";

import 'package:southsidepc/src/ui/widgets/splash.dart';
import 'root.dart';

import 'package:southsidepc/instaflutter-login/ui/auth/authScreen.dart';

class LoginRequired extends StatefulWidget {
  static const routeName = '/';

  @override
  _LoginRequiredState createState() => _LoginRequiredState();
}

class _LoginRequiredState extends State<LoginRequired> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        redirect();
      },
    );
  }

  void redirect() async {
    // Does FirebaseAuth (local) think someone is logged in?
    if (FirebaseAuth.instance.currentUser == null) {
      print("FirebaseAuth user is null.");
      // no, so go to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthScreen(),
        ),
      );
      return;
    }
    print("FirebaseAuth user not null!");

    // Yes, so try to get UserState from Firebase (remote)
    var authUser = FirebaseAuth.instance.currentUser!;
    var user = await getCurrentUser(authUser.uid);
    if (user == null) {
      // output error and go to login page
      print("FirebaseAuth (local) thinks user '${authUser.email}'"
          " is logged in, but Firebase (remote) failed to retrieve them.");
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthScreen(),
        ),
      );
      return;
    }

    // user returned; all good
    print("FirebaseAuth user sync complete.");
    Navigator.pushReplacementNamed(context, NavUI.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Splash();
  }
}

Future<UserState?> getCurrentUser(String uid) async {
  /*DocumentSnapshot<Map<String, dynamic>> userDocument =
        await firestore.collection(USERS).doc(uid).get();
    if (userDocument.data() != null && userDocument.exists) {
      return User.fromJson(userDocument.data()!);
    } else {
      return null;
    }
  }*/
  return null;
}

class LoginSignUp extends StatefulWidget {
  static const routeName = "/login-signup";
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  _LoginSignUpState createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(LoginSignUp.routeName),
      onTap: () => Navigator.pop(context),
    );
  }
}
