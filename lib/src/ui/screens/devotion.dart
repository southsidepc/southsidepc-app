import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:southsidepc/src/models/devotion_data.dart';

class Devotion extends StatelessWidget {
  static const routeName = '/devotion';
  final String id;

  Devotion(this.id, {Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    DocumentReference<Map<String, dynamic>> devotion =
        FirebaseFirestore.instance.collection('devotions').doc(id);

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

        Widget? bottomSheet;
        /*if (devotionData.link != '') {
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

        DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parse(devotionData.date, true)
            .toLocal();
        var formattedDate = DateFormat('d MMMM yyyy').format(date);

        return Scaffold(
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
                    ],
                  ),
                ),
              )
            ],
          ),
        );
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
