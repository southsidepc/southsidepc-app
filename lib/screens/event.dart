import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Event extends StatelessWidget {
  Event({Key key}) : super(key: key);
  static const routeName = '/events';

  Widget build(BuildContext context) {
    final EventArguments args = ModalRoute.of(context).settings.arguments;
    DocumentReference event =
        FirebaseFirestore.instance.collection('events').doc(args.eventId);

    return StreamBuilder<DocumentSnapshot<EventData>>(
        stream: event.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Event Error"),
              ),
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Loading Event"),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          var eventData = snapshot.data.data();

          double height;

          if (eventData.imageName != null &&
              eventData.imageName != '') {
            height = 250;
          }

          Widget bottomSheet;

          if (eventData.link != null &&
              eventData.link != '') {
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
                      launch(eventData.link);
                    },
                    child: Text("Visit Website"),
                  ),
                ),
              ),
            );
          }

          DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
              .parse(eventData.date, true)
              .toLocal();
          var formattedDate = DateFormat('d MMMM yyyy').format(date);

          return Scaffold(
            bottomSheet: bottomSheet,
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                iconTheme: IconThemeData(
                    color: Theme.of(context).textTheme.bodyText1.color),
                expandedHeight: height,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    eventData.title,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                  background: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          eventData.image,
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
                                ])),
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
                                  ])),
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
                      delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8), child: Divider(),),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(eventData.content),
                ),
              ])))
            ]),
          );
        });
  }
}

class EventArguments {
  final String eventId;

  EventArguments(this.eventId);
}

class EventData {
  String imageName;
  String link;
  String date;
  String title;
  String image;
  String content;
}
