import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginState { loggedOut, loggedIn }

class UserState extends ChangeNotifier {
  LoginState _loginState = LoginState.loggedOut;
  LoginState get loginState => _loginState;

  UserState() {
    //init();
  }

  ////////////
  // init() //
  ////////////
  Future<void> init() async {
    print("Initialising FirebaseAuth ...");
    FirebaseAuth.instance.userChanges().listen(
      (event) {
        _loginState =
            event != null ? LoginState.loggedIn : LoginState.loggedOut;
        notifyListeners();
      },
    );
    print("Initialising FirebaseAuth ... done.");
  }

  void createAccount() async {
    try {
      print("Creating account ...");
      var credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "horatius@bonar.com",
        password: "gummybear",
      );
      print("Creating account ... done.");
      print("Updating display name ...");
      await credential.user!.updateDisplayName("Horatius Bonar");
      print("Updating display name ... done.");
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void logout() {
    print("Logging out ...");
    FirebaseAuth.instance.signOut();
    print("Logging out ... done.");
  }
}
