// External imports
import "package:flutter/widgets.dart";
import 'package:firebase_core/firebase_core.dart';

// Internal imports
import 'root.dart';
import 'package:southsidepc/src/ui/widgets/splash.dart';

////////////////////////
// class SouthsideApp //
////////////////////////
class SouthsideApp extends StatelessWidget {
  // Data: Create the initilization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  /////////////
  // build() //
  /////////////
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Root();
        }

        // Otherwise, show something whilst waiting for
        // initialization to complete
        return Splash();
      },
    );
  }
} // class SouthsideApp
