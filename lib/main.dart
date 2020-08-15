import 'package:flutter/material.dart';
import 'package:southsidepc/screens/Sermons.dart';
import 'package:southsidepc/screens/coffee.dart';
import 'package:southsidepc/screens/contactUs.dart';
import 'package:southsidepc/screens/home.dart';
import 'package:southsidepc/screens/magnification.dart';
import 'package:southsidepc/screens/navigatePodcast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

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

enum MagnificationEnum { spotify }
enum SermonsEnum { spotify, soundcloud, podcast }
enum NavigateEnum { spotify, podcast }

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String title = "Home";
  Widget _content = Home();
  List<Widget> _action;

  void _setMagnification() {
    setState(() {
      title = "Magnification";
      _content = Magnification();
      _action = <Widget>[
        PopupMenuButton<MagnificationEnum>(
          onSelected: (MagnificationEnum result) async {
            String url = 'https://open.spotify.com/playlist/5p0cw0WFvC5Bmkf5vyR4bG?si=-oj_dClxRUeeOUOWbg091g';

            if (result == MagnificationEnum.spotify) {
              url = 'https://open.spotify.com/playlist/5p0cw0WFvC5Bmkf5vyR4bG?si=-oj_dClxRUeeOUOWbg091g';
            }

            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MagnificationEnum>>[
            const PopupMenuItem<MagnificationEnum>(
              value: MagnificationEnum.spotify,
              child: Text('Open Spotify'),
            ),
          ],
        )
      ];
    });
  }

  void _setCoffee() {
    setState(() {
      title = "Coffee";
      _content = Coffee();
      _action = null;
    });
  }

  void _setHome() {
    setState(() {
      title = "Home";
      _content = Home();
      _action = null;
    });
  }

  void _setNavigatePodcast() {
    setState(() {
      title = "Navigate Podcast";
      _content = NavigatePodcast();
      _action = <Widget>[
        PopupMenuButton<NavigateEnum>(
          onSelected: (NavigateEnum result) async {
            String url = 'https://open.spotify.com/show/0PRkJlUMpq0dhBoUMhFsyQ';

            if (result == NavigateEnum.spotify) {
              url = 'https://open.spotify.com/show/0PRkJlUMpq0dhBoUMhFsyQ';
            } else if (result == NavigateEnum.podcast) {
              url = 'pcast://feed.podbean.com/navigate/feed.xml';
            }

            if (await canLaunch(url)) {
              await launch(url);
            } else {

            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<NavigateEnum>>[
            PopupMenuItem<NavigateEnum>(
              value: NavigateEnum.spotify,
              child: Text('Open Spotify'),
            ),
            PopupMenuItem<NavigateEnum>(
              value: NavigateEnum.podcast,
              child: Text('Open Podcast'),
            ),
          ],
        )
      ];
    });
  }

  void _setSermons() {
    setState(() {
      title = "Sermons";
      _content = Sermons();
      _action = <Widget>[
        PopupMenuButton<SermonsEnum>(
          onSelected: (SermonsEnum result) async {
            String url = 'https://open.spotify.com/show/0HrMcpDD9YDdyMfOyojmFe?si=NUvzGQUwTrCxijZHAkSvcg';

            if (result == SermonsEnum.spotify) {
              url = 'https://open.spotify.com/show/0HrMcpDD9YDdyMfOyojmFe?si=NUvzGQUwTrCxijZHAkSvcg';
            } else if (result == SermonsEnum.podcast) {
              url = 'pcast://feeds.soundcloud.com/users/soundcloud:users:212248612/sounds.rss';
            }

            if (await canLaunch(url)) {
              await launch(url);
            } else {

            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SermonsEnum>>[
            PopupMenuItem<SermonsEnum>(
              value: SermonsEnum.spotify,
              child: Text('Open Spotify'),
            ),
            PopupMenuItem<SermonsEnum>(
              value: SermonsEnum.podcast,
              child: Text('Open Podcast'),
            ),
          ],
        )
      ];
    });
  }

  void _setContactUs() {
    setState(() {
      title = "Contact Us";
      _content = ContactUs();
      _action = null;
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
        actions: _action,
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
