// External imports
import "package:flutter/widgets.dart";

// Internal imports
import "package:southsidepc/SouthsideApp/SouthsideApp.dart";

////////////
// main() //
////////////
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SouthsideApp());
}

//////////////////
// Global enums //
//////////////////
enum MagnificationEnum { spotify }
enum SermonsEnum { spotify, soundcloud, podcast }
enum NavigateEnum { spotify, podcast }

/*Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print("onBackgroundMessage: $message");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}*/
