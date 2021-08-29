import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:southsidepc/src/ui/widgets/podcast_player.dart';
import 'package:southsidepc/src/models/devotion_data.dart';
import 'package:url_launcher/link.dart';

class Devotion extends StatefulWidget {
  static const routeName = '/devotion';
  final String id;

  Devotion(this.id, {Key? key}) : super(key: key);

  @override
  _DevotionState createState() => _DevotionState();
}

class _DevotionState extends State<Devotion> {
  // mp3 filenames obtained from https://feed.podbean.com/navigate/feed.xml

  Widget build(BuildContext context) {
    DocumentReference<Map<String, dynamic>> devotion =
        FirebaseFirestore.instance.collection('devotions').doc(widget.id);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: devotion.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Devotion Error"),
            ),
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Loading Devotion"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        var dbEntry = snapshot.data?.data();
        if (dbEntry == null) {
          return _dbError();
        }
        var devotionData = DevotionData.fromDB(dbEntry);

        double? height;
        if (devotionData.imageName != '') {
          height = 250;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Navigate Podcast',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  devotionData.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Text(
                  devotionData.toLocalDateTime().toString(),
                  style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                ),
                Divider(),
                Text(
                  'Read',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Link(
                  uri: Uri.parse(devotionData.verseURL),
                  builder: (context, handler) => ElevatedButton(
                    onPressed: handler,
                    child: Text(
                      devotionData.verseText,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                Divider(),
                Text(
                  'Listen',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: PodcastPlayer(url: devotionData.listenURL),
                ),
                Divider(),
                Text(
                  'Pray',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  devotionData.prayerPoints,
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        );

        /*Widget? bottomSheet;
        if (devotionData.link != '') {
          bottomSheet = Container(
            height: 50,
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: SizedBox.expand(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21.0),
                  ),
                  elevation: 0,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    launch(devotionData.link);
                  },
                  child: Text("Visit Website"),
                ),
              ),
            ),
          );
        }*/

        /*DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parse(devotionData.date, true)
            .toLocal();
        var formattedDate = DateFormat('d MMMM yyyy').format(date);*/

        /*return Scaffold(
          bottomSheet: bottomSheet,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                iconTheme: IconThemeData(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
                expandedHeight: height,
                flexibleSpace: FlexibleSpaceBar(
                  ///////////
                  // title //
                  ///////////
                  title: Text(
                    devotionData.title,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1?.color),
                  ),
                  background: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        //////////////////////
                        // background image //
                        //////////////////////
                        Image.network(
                          devotionData.imageURL,
                          fit: BoxFit.cover,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Theme.of(context).canvasColor,
                                  Colors.transparent
                                ],
                              ),
                            ),
                            height: 250,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 250,
                            height: 250,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment.topLeft,
                                  colors: [
                                    Theme.of(context).canvasColor,
                                    Colors.transparent
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverSafeArea(
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        //////////
                        // date //
                        //////////
                        child: Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: Divider(),
                      ),
                      ///////////////
                      // verseText //
                      ///////////////
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Text(devotionData.verseText),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(
                              url: Uri.https(
                                  'navigatedevotional.com', 'unencodedPath')),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );*/
      },
    );
  }

  Widget _dbError() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Null data"),
      ),
      body: Center(
        child: Text("Failed type-cast?"),
      ),
    );
  }
}
