import "package:flutter/material.dart";
import "package:community_material_icon/community_material_icon.dart";

import 'package:southsidepc/login_required/login_required.dart';
import 'package:southsidepc/src/models/user_state.dart';

import "screens/home.dart";
//import "screens/event.dart";
import "screens/coffee.dart";
import 'screens/media.dart';
import "screens/connect.dart";
import "screens/profile.dart";

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
        ...LoginRequired.createRoutes(NavUI.routeName, NavUI(), UserState()),
        ...{
          //Event.routeName: (context) => Event(),
        }
      },
      theme: ThemeData(
        canvasColor: Colors.white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedIconTheme: IconThemeData(
            color: Theme.of(context).iconTheme.color?.withAlpha(100),
          ),
          selectedIconTheme: IconThemeData(color: southsideNavy),
          selectedItemColor: southsideNavy,
        ),
        primarySwatch: southsideNavy,
        buttonColor: southsideNavy,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: southsideNavyDark,
        accentColor: southsideNavyDark,
        appBarTheme: AppBarTheme(
          elevation: 0,
          brightness: Brightness.dark,
        ),
        buttonColor: southsideNavyDark,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF212121),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withAlpha(100),
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}

/// class NavUI
class NavUI extends StatefulWidget {
  static const routeName = '/';

  @override
  _NavUIState createState() => _NavUIState();
}

/// class _NavUI
class _NavUIState extends State<NavUI> {
  /////////////////////////////////////////////////////////////////
  // const data: For each screen - label, widget, icon => navbar //
  /////////////////////////////////////////////////////////////////
  final List<String> _screenLabels = [
    "Home",
    "Coffee",
    "Media",
    "Connect",
    "Profile",
  ];
  final List<Widget> _screenWidgets = [
    Home(),
    Coffee(),
    Media(),
    Connect(),
    Profile(),
  ];
  final List<Icon> _screenIcons = [
    Icon(CommunityMaterialIcons.home_outline),
    Icon(CommunityMaterialIcons.coffee_outline),
    Icon(CommunityMaterialIcons.music_note_outline),
    Icon(CommunityMaterialIcons.link_box_outline),
    Icon(CommunityMaterialIcons.account_outline),
  ];
  final List<BottomNavigationBarItem> _screenNavBars = [];

  /// _NavUIState()
  _NavUIState() {
    const numScreens = 5;

    // _screenNavBars
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
              title: Text(
                _screenLabels.elementAt(_selectedIndex),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
              //centerTitle: true,
            ),
      body: _screenWidgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _screenNavBars,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /////////////////
  // initState() //
  /////////////////
  /*@override
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
  }*/
}
