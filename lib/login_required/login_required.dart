///
/// login_required.dart and associated source code files are modifications
/// of parts of the repository https://github.com/instaflutter/
/// flutter-login-screen-firebase-auth-facebook-login by instaflutter.
/// The code in that repository is under an MIT license, as
/// specified by the licensing page https://www.instaflutter.com/licenses/,
/// noting that the source code is free.
///
/// Consequently the login_required code is also subject to the MIT license:
///
/// Copyright 2021 instaflutter.com
///
/// Permission is hereby granted, free of charge, to any person obtaining a
/// copy of this software and associated documentation files (the "Software"),
/// to deal in the Software without restriction, including without limitation
/// the rights to use, copy, modify, merge, publish, distribute, sublicense,
/// and/or sell copies of the Software, and to permit persons to whom the
/// Software is furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_to_background/move_to_background.dart';

import 'authenticate.dart';

import 'authScreen.dart';
import 'user_base.dart';

enum NavState {
  Startup,
  LoginRequired,

  Normal,
  NormalPaused,

  LoginPausedByBackButton,
  LoginPausedByHomeButton,
}

class LoginRequired<T extends UserBase> extends StatefulWidget {
  static late dynamic currentUser = null;
  static NavState navState = NavState.Startup;

  final Widget appRoot;
  final UserBase defaultUserData;

  LoginRequired({required this.appRoot, required T defaultUserData})
      : defaultUserData = defaultUserData;

  @override
  State<StatefulWidget> createState() => _LoginRequiredState<T>();

  static Map<String, WidgetBuilder> createRoutes<T extends UserBase>(
      String appRootRouteName, Widget appRootInstance, T defaultUserData) {
    return {
      appRootRouteName: (context) => LoginRequired<T>(
            defaultUserData: defaultUserData,
            appRoot: appRootInstance,
          ),
      AuthScreen.routeName: (context) => AuthScreen(defaultUserData)
    };
  }
}

class _LoginRequiredState<T extends UserBase> extends State<LoginRequired<T>>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    print("Observer added.");
    _printNavState();
    FirebaseAuth.instance.userChanges().listen((user) {
      print("I heard about a user change ...");
      print("$user");
      if (user == null) {
        print("User is null");
        LoginRequired.currentUser = null;
        LoginRequired.navState = NavState.LoginRequired;
        _printNavState();
      } else {
        if (LoginRequired.currentUser == null) {
          _syncCurrentUser();
          LoginRequired.navState = NavState.Normal;
          _printNavState();
        }
      }
      setState(() {});
    });
  }

  void _printNavState() {
    print("navState = ${LoginRequired.navState}");
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    print("Observer removed.");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("Observer noticed lifecycle state: $state");
    switch (state) {

      ///////////////
      // onPause() //
      ///////////////
      case AppLifecycleState.inactive:
        // LoginPauseByBackButton already taken care of
        if (LoginRequired.navState != NavState.LoginPausedByBackButton) {
          // What flow are we pausing?
          // either login flow or navigation flow
          LoginRequired.navState = LoginRequired.currentUser == null
              ? NavState.LoginPausedByHomeButton
              : NavState.NormalPaused;
        }
        _printNavState();
        break;

      ////////////////
      // onResume() //
      ////////////////
      case AppLifecycleState.resumed:
        switch (LoginRequired.navState) {
          case NavState.LoginPausedByHomeButton:
            LoginRequired.navState = NavState.LoginRequired;
            _printNavState();
            break;
          case NavState.LoginPausedByBackButton:
            setState(() {
              LoginRequired.navState = NavState.LoginRequired;
              _printNavState();
            });
            break;
          case NavState.NormalPaused:
            assert(LoginRequired.currentUser != null);
            print("Resumed from NormalPaused");
            LoginRequired.navState = NavState.Normal;
            _printNavState();
            break;
          default:
            throw Exception(
                "navState has value ${LoginRequired.navState}, which shouldn't occur when state = $state.");
        }
        break;
      default:
        break;
    }
  }

  void _loginFlow() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushNamed(context, AuthScreen.routeName,
              arguments: LoginRequired.currentUser)
          .then((value) {
        // set login state
        LoginRequired.currentUser = value as T?;

        // login was successful
        if (LoginRequired.currentUser != null) {
          print("_loginFlow() : Login succesful.");
          print("_loginFlow() : ${LoginRequired.currentUser}");
          setState(() {
            LoginRequired.navState = NavState.Normal;
            _printNavState();
          });
        }
        // user pressed BACK key on AuthScreen
        else {
          assert(Platform.isAndroid);
          LoginRequired.navState = NavState.LoginPausedByBackButton;
          print("_loginFlow() : Moving to background.");
          MoveToBackground.moveTaskToBack();
        }
      });
    });
  }

  Widget _buildChild() {
    return WillPopScope(
      onWillPop: () async {
        print("_buildChild() : Moving to background.");
        await MoveToBackground.moveTaskToBack();
        return false;
      },
      child: widget.appRoot,
    );
  }

  void _syncCurrentUser() async {
    var result = await FireStoreUtils.getCurrentUser(
        FirebaseAuth.instance.currentUser!.uid, widget.defaultUserData);
    if (result == null) {
      var user = FirebaseAuth.instance.currentUser!;
      print(
          "syncCurrentUser() : could not find user ${user.email} with uid ${user.uid}. This probably indicates that the user account is not configured correctly.");
      FirebaseAuth.instance.signOut();
    } else {
      print("syncCurrentUser() : success.");
      LoginRequired.currentUser = result as T;
      print("syncCurrentUser() : ${LoginRequired.currentUser}");
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (LoginRequired.navState) {
      // usual cases
      case NavState.Startup:
        break;
      case NavState.LoginRequired:
        _loginFlow();
        break;
      case NavState.Normal:
        break;

      // error cases
      case NavState.LoginPausedByBackButton:
      case NavState.LoginPausedByHomeButton:
      case NavState.NormalPaused:
      case NavState.Startup:
        throw Exception(
            "navState has value ${LoginRequired.navState}, which shouldn't occur in LoginRequired.build()");
      default:
        throw Exception("LoginRequired.build() not fully implemented.");
    }
    return _buildChild();
  }
}
