import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southsidepc/screens/Sermons.dart';
import 'package:southsidepc/screens/coffee.dart';
import 'package:southsidepc/screens/contactUs.dart';
import 'package:southsidepc/screens/home.dart';
import 'package:southsidepc/screens/magnification.dart';
import 'package:southsidepc/screens/navigatePodcast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:southsidepc/screens/resources.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:southsidepc/screens/connect.dart';

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
        50: const Color(0xFFE3E5E8),
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
        canvasColor: Colors.white,
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
      darkTheme: ThemeData(
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
      themeMode: ThemeMode.system,
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

enum MagnificationEnum { spotify }
enum SermonsEnum { spotify, soundcloud, podcast }
enum NavigateEnum { spotify, podcast }

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int _selectedIndex = 0;

  List<Widget> _screens = <Widget>[
    Home(),
    Coffee(),
    Resources(),
    Connect(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
    List<AppBar> _appbars = <AppBar>[
      null,
      AppBar(
        title: Text(
          "Coffee",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      AppBar(
        title: Text(
          "Media",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      AppBar(
        title: Text(
          "Connect",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
    ];

    return Scaffold(
      appBar: _appbars.elementAt(_selectedIndex),
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: IconThemeData(color: Theme.of(context).iconTheme.color.withAlpha(100)),
        selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        selectedItemColor: Theme.of(context).primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.home_outline), title: Text('Home')),
          BottomNavigationBarItem(
            icon: Icon(CommunityMaterialIcons.coffee_outline),
            title: Text('Coffee'),
          ),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.music_note_outline), title: Text('Media')),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.link_box_outline), title: Text('Connect'))
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
