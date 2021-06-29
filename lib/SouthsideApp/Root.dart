import "package:flutter/material.dart";
import "package:community_material_icon/community_material_icon.dart";

import "package:southsidepc/SouthsideApp/screens/home.dart";
import "package:southsidepc/SouthsideApp/screens/event.dart";
import "package:southsidepc/SouthsideApp/screens/checkin.dart";
import "package:southsidepc/SouthsideApp/screens/coffee.dart";
import "package:southsidepc/SouthsideApp/screens/resources.dart";
import "package:southsidepc/SouthsideApp/screens/connect.dart";
import "package:southsidepc/SouthsideApp/screens/profile.dart";

class Root extends StatelessWidget {
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
        PageController.routeName: (context) => PageController(),
        Event.routeName: (context) => Event()
      },
      initialRoute: PageController.routeName,
      theme: ThemeData(
          canvasColor: Colors.white,
          appBarTheme:
              AppBarTheme(brightness: Brightness.dark, color: Colors.white),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            unselectedIconTheme: IconThemeData(
              color: Theme.of(context).iconTheme.color?.withAlpha(100),
            ),
            selectedIconTheme: IconThemeData(color: southsideNavy),
            selectedItemColor: southsideNavy,
          ),
          primarySwatch: southsideNavy,
          buttonColor: southsideNavy),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: southsideNavyDark,
          accentColor: southsideNavyDark,
          appBarTheme: AppBarTheme(elevation: 0, brightness: Brightness.dark),
          buttonColor: southsideNavyDark,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF212121),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withAlpha(100))),
      themeMode: ThemeMode.system,
      home: PageController(),
    );
  }
}

/// class PageController
class PageController extends StatefulWidget {
  static const routeName = '/home';

  @override
  _PageControllerState createState() => _PageControllerState();
}

/// class _PageControllerState
class _PageControllerState extends State<PageController> {
  /////////////////////////////////////////////////////////////////
  // const data: For each screen - label, widget, icon => navbar //
  /////////////////////////////////////////////////////////////////
  final List<String> _screenLabels = [
    "Home",
    "Check in",
    "Coffee",
    "Media",
    "Connect",
    "Profile",
  ];
  final List<Widget> _screenWidgets = [
    Home(),
    CheckIn(),
    Coffee(),
    Resources(),
    Connect(),
    Profile(),
  ];
  final List<Icon> _screenIcons = [
    Icon(CommunityMaterialIcons.home_outline),
    Icon(CommunityMaterialIcons.qrcode),
    Icon(CommunityMaterialIcons.coffee_outline),
    Icon(CommunityMaterialIcons.music_note_outline),
    Icon(CommunityMaterialIcons.link_box_outline),
    Icon(CommunityMaterialIcons.account_outline),
  ];
  final List<BottomNavigationBarItem> _screenNavBars = [];

  /// _PageControllerState()
  _PageControllerState() {
    const numScreens = 6;

    // navbars
    for (var i = 0; i < numScreens; ++i) {
      _screenNavBars.add(
        BottomNavigationBarItem(
          icon: _screenIcons.elementAt(i),
          label: _screenLabels.elementAt(i),
        ),
      );
    }
  }

  /////////////////////////////////
  // Mutable state: navbar index //
  /////////////////////////////////
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /////////////
  // build() //
  /////////////
  @override
  Widget build(BuildContext context) {
    final appBars = _screenLabels
        .map<AppBar?>(
          (String str) => AppBar(
            title: Text(
              str,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color),
            ),
            //centerTitle: true,
          ),
        )
        .toList();
    appBars.first = null; // first tab has no AppBar

    return Scaffold(
      appBar: appBars.elementAt(_selectedIndex),
      body: _screenWidgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _screenNavBars,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /////////////////
  // initState() //
  /////////////////
  @override
  void initState() {
    super.initState();

    /*_firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        */ /*Navigator.pushNamed(
          context,
          Event.routeName,
          arguments: EventArguments(
              message['data']['eventId']
          ),
        );*/ /*
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
}
