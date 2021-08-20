import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southsidepc/screens/checkIn.dart';
import 'package:southsidepc/screens/coffee.dart';
import 'package:southsidepc/screens/event.dart';
import 'package:southsidepc/screens/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:southsidepc/screens/profile.dart';
import 'package:southsidepc/screens/resources.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:southsidepc/screens/connect.dart';
import 'package:firebase_core/firebase_core.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
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
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new App());
}

class App extends StatelessWidget {
  // Create the initilization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

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
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/Home.png'), fit: BoxFit.cover)
          ),
        );
      },
    );
  }
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

    MaterialColor southsideNavyDark = MaterialColor(
      0xFF8a899a,
      <int, Color>{
        50: const Color(0xFF8a899a),
        100: const Color(0xFF8a899a),
        200: const Color(0xFF8a899a),
        300: const Color(0xFF8a899a),
        400: const Color(0xFF8a899a),
        500: const Color(0xFF8a899a),
        600: const Color(0xFF8a899a),
        700: const Color(0xFF8a899a),
        800: const Color(0xFF8a899a),
        900: const Color(0xFF8a899a),
      },
    );

    return MaterialApp(
      title: 'Southside',
      routes: {
        MyHomePage.routeName: (context) => MyHomePage(),
        Event.routeName: (context) => Event()
      },
      initialRoute: MyHomePage.routeName,
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
        appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            color: Colors.white
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            unselectedIconTheme: IconThemeData(
                color: Theme.of(context).iconTheme.color.withAlpha(100)),
            selectedIconTheme: IconThemeData(color: southsideNavy),
            selectedItemColor: southsideNavy,
            ),
        primarySwatch: southsideNavy,
        buttonColor: southsideNavy
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: southsideNavyDark,
          accentColor: southsideNavyDark,
          appBarTheme: AppBarTheme(elevation: 0, brightness: Brightness.dark),
          buttonColor: southsideNavyDark,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF212121),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withAlpha(100))),
      themeMode: ThemeMode.system,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  static const routeName = '/home';

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum MagnificationEnum { spotify }
enum SermonsEnum { spotify, soundcloud, podcast }
enum NavigateEnum { spotify, podcast }

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> _screens = <Widget>[
    Home(),
    CheckIn(),
    Coffee(),
    Resources(),
    Connect(),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    /*_firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        *//*Navigator.pushNamed(
          context,
          Event.routeName,
          arguments: EventArguments(
              message['data']['eventId']
          ),
        );*//*
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        if (message['data']['eventId'] != null && message['data']['eventId'] != "" && ModalRoute.of(context).settings.name != Event.routeName) {
          Navigator.pushNamed(
            context,
            Event.routeName,
            arguments: EventArguments(
                message['data']['eventId']
            ),
          );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        if (message['data']['eventId'] != null && message['data']['eventId'] != "" && ModalRoute.of(context).settings.name != Event.routeName) {
          Navigator.pushNamed(
            context,
            Event.routeName,
            arguments: EventArguments(
                message['data']['eventId']
            ),
          );
        }
      },
    );
    
    _firebaseMessaging.subscribeToTopic('events');*/
  }

  @override
  Widget build(BuildContext context) {
    List<AppBar> _appbars = <AppBar>[
      null,
      AppBar(
        title: Text(
          "Check In",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
      ),
      AppBar(
        title: Text(
          "Coffee",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
      ),
      AppBar(
        title: Text(
          "Media",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
      ),
      AppBar(
        title: Text(
          "Connect",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
      ),
      AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
      ),
    ];

    return Scaffold(
      appBar: _appbars.elementAt(_selectedIndex),
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.home_outline),
              label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(CommunityMaterialIcons.qrcode),
            label: 'Check In',
          ),
          BottomNavigationBarItem(
            icon: Icon(CommunityMaterialIcons.coffee_outline),
            label: 'Coffee',
          ),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.music_note_outline),
              label: 'Media'),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.link_box_outline),
              label: 'Connect'),
          BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.account_outline),
              label: 'Profile')
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
