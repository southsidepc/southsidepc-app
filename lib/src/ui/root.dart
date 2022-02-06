import "package:flutter/material.dart";
import "package:community_material_icon/community_material_icon.dart";

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import 'package:southsidepc/login_required/login_required.dart';
import 'package:southsidepc/src/models/user_state.dart';

import '../locator.dart';

import "screens/home.dart";
import "screens/coffee.dart";
import 'screens/media.dart';
import "screens/connect.dart";
import "screens/profile.dart";
import 'screens/event.dart';
import 'screens/devotion.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor southsideNavy = const MaterialColor(
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

    MaterialColor southsideNavyDark = const MaterialColor(
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
          color: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: southsideNavy
          )
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedIconTheme: IconThemeData(
            color: Theme.of(context).iconTheme.color?.withAlpha(100),
          ),
          selectedIconTheme: IconThemeData(color: southsideNavy),
          selectedItemColor: southsideNavy,
        ),
        primarySwatch: southsideNavy,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),

            ),
              side: BorderSide(
                  color: southsideNavy,
                  width: 2
              ),
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(width: 2.0)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
        ),
      ),
      darkTheme: ThemeData(
        canvasColor: Color(0xFF101010),
        brightness: Brightness.dark,
        accentColor: southsideNavyDark,
        primarySwatch: southsideNavyDark,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: new Color(0xFF101010),
            iconTheme: IconThemeData(
                color: Colors.white
            )
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF212121),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withAlpha(100),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                padding: EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),

                ),
                side: BorderSide(
                    color: southsideNavyDark,
                    width: 2
                ),
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
            )
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.only(left: 16, right: 16),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                  width: 2.0,
                color: southsideNavyDark
              ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
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
  ////////////////////////
  // firebase messaging //
  ////////////////////////
  final _messaging = FirebaseMessaging.instance;

  /////////////////////////////////////////////////////////////////
  // const data: For each screen - label, widget, icon => navbar //
  /////////////////////////////////////////////////////////////////
  final List<String> _screenLabels = [
    "Home",
    //"Coffee",
    "Media",
    "Connect",
    "Profile",
  ];
  final List<Widget> _screenWidgets = [
    Home(),
    //Coffee(),
    Media(),
    Connect(),
    Profile(),
  ];
  final List<Icon> _screenIcons = [
    Icon(CommunityMaterialIcons.home_outline),
    //Icon(CommunityMaterialIcons.coffee_outline),
    Icon(CommunityMaterialIcons.music_note_outline),
    Icon(CommunityMaterialIcons.link_box_outline),
    Icon(CommunityMaterialIcons.account_outline),
  ];
  final List<BottomNavigationBarItem> _screenNavBars = [];

  /// _NavUIState()
  _NavUIState() {
    const numScreens = 4;

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

  Future<void> _requestMessagingPermission() async {
    locator.registerSingleton<NotificationSettings>(
        await _messaging.requestPermission());
  }

  /////////////////
  // initState() //
  /////////////////
  @override
  void initState() {
    super.initState();

    // get permission (run only once?)
    _requestMessagingPermission();

    // regular (foreground) message handler
    FirebaseMessaging.onMessage.listen(_onMessage);

    // background message handler
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    // subscribe to all topics
    // (message handlers will determine if it needs to be shown)
    _messaging.subscribeToTopic('events');
    _messaging.subscribeToTopic('devotions');
  }

  //////////////////
  // _onMessage() //
  //////////////////
  void _onMessage(RemoteMessage msg) {
    // debug
    print('onMessage()');
    print('category: ${msg.category}');
    print('from: ${msg.from}');
    print('messageId: ${msg.messageId}');
    print('messageType: ${msg.messageType}');
    print('notification: ${msg.notification}');
    print('senderId: ${msg.senderId}');
    print('sentTime: ${msg.sentTime}');
    print('data: ${msg.data}');

    // get topic, or error
    var result = msg.from?.split('/topics/');
    print('Split into ${result?.length} pieces: $result');
    var topic = result?[1];
    print('topic = $topic');
    if (topic == null) {
      print('Could not determine topic. Aborting.');
      return;
    } else if (topic != 'events' && topic != 'devotions') {
      print('I don\'t know how to process the topic $topic. Aborting.');
      return;
    }

    // is user subscribed to this topic?
    // (abort if user is null)
    var user = LoginRequired.currentUser as UserState?;
    if (user == null) {
      print('User is null. Weird. Aborting.');
      return;
    }
    if (!user.hasNotification(topic)) {
      print('User is not subscribed to this topic. Aborting.');
      return;
    }

    // get database key for resource (event or devotion)
    // or, error
    var key = msg.data['key'] ?? '';
    if (key == '') {
      print('Empty key. Aborting.');
      return;
    }

    // display snackbar
    showTopSnackBar(
      context,
      CustomSnackBar.info(
          message:
              'Southside: Click to check out a new item in the $topic feed!'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => topic == 'events' ? Event(key) : Devotion(key),
          ),
        );
      },
    );
  }
}

// Messaging background handler must be a top-level function.
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print('onBackgroundMessage: $message');
}



/*_messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Navigator.pushNamed(
          context,
          Event.routeName,
          arguments: EventArguments(message['data']['eventId']),
        );
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        if (message['data']['eventId'] != null &&
            message['data']['eventId'] != "" &&
            ModalRoute.of(context).settings.name != Event.routeName) {
          Navigator.pushNamed(
            context,
            Event.routeName,
            arguments: EventArguments(message['data']['eventId']),
          );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        if (message['data']['eventId'] != null &&
            message['data']['eventId'] != "" &&
            ModalRoute.of(context).settings.name != Event.routeName) {
          Navigator.pushNamed(
            context,
            Event.routeName,
            arguments: EventArguments(message['data']['eventId']),
          );
        }
      },
    );*/