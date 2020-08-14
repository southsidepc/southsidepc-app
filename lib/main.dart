import 'package:flutter/material.dart';
import 'package:southsidepc/screens/Sermons.dart';
import 'package:southsidepc/screens/coffee.dart';
import 'package:southsidepc/screens/contactUs.dart';
import 'package:southsidepc/screens/home.dart';
import 'package:southsidepc/screens/magnification.dart';
import 'package:southsidepc/screens/navigatePodcast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor southsideNavy = MaterialColor(
      0xFF182943,
      <int, Color>{
        50:  const Color(0xFFE3E5E8),
        100: const Color(0xFFBABFC7),
        200: const Color(0xFF8C94A1),
        300: const Color(0xFF5D697B),
        400: const Color(0xFF3B495F),
        500: const Color(0xFF182943),
        600: const Color(0xFF15243D),
        700: const Color(0xFF111F34),
        800: const Color(0xFF0E192C),
        900: const Color(0xFF080F1E),
      },
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: southsideNavy,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String title = "Home";
  Widget _content = Home();

  void _setMagnification() {
    setState(() {
      title = "Magnification";
      _content = Magnification();
    });
  }

  void _setCoffee() {
    setState(() {
      title = "Coffee";
      _content = Coffee();
    });
  }

  void _setHome() {
    setState(() {
      title = "Home";
      _content = Home();
    });
  }

  void _setNavigatePodcast() {
    setState(() {
      title = "Navigate Podcast";
      _content = NavigatePodcast();
    });
  }

  void _setSermons() {
    setState(() {
      title = "Sermons";
      _content = Sermons();
    });
  }

  void _setContactUs() {
    setState(() {
      title = "Contact Us";
      _content = ContactUs();
    });
  }

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _content,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
              child: Center(
                child: Image(
                  image: AssetImage('assets/SP001-Logo-Icon-White.png'),
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                _setHome();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Magnification'),
              onTap: () {
                _setMagnification();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Navigate Podcast'),
              onTap: () {
                _setNavigatePodcast();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Sermons'),
              onTap: () {
                _setSermons();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Coffee'),
              onTap: () {
                _setCoffee();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Contact Us'),
              onTap: () {
                _setContactUs();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
