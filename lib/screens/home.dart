import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:southsidepc/screens/event.dart';

class Home extends StatelessWidget {
  Query events = FirebaseFirestore.instance
      .collection('events')
      .orderBy('date', descending: true)
      .where('published', isEqualTo: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: events.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          List<QueryDocumentSnapshot> events = snapshot.data.docs;
          List<Widget> formattedEvents = new List<Widget>();

          events.forEach((document) {
            Map<String, dynamic> event = document.data();
            DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                .parse(event['date'], true)
                .toLocal();
            String formattedDate = DateFormat("MMMM yyyy").format(date);
            var eventId = document.id;

            SliverStickyHeader sliverStickyHeader;

            List<Widget> filteredEvents = formattedEvents.where((element) {
              SliverStickyHeader headerContainer = element;
              Container header = headerContainer.header;
              Text headerText = header.child;
              return headerText.data == formattedDate;
            }).toList();

            if (filteredEvents.length > 0) {
              sliverStickyHeader = filteredEvents[0];
            } else {
              sliverStickyHeader = SliverStickyHeader(
                header: Container(
                  height: 40.0,
                  color: Theme.of(context).canvasColor,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle1.color),
                  ),
                ),
                sliver: SliverList(
                    delegate: SliverChildListDelegate(new List<Widget>())),
              );

              formattedEvents.add(sliverStickyHeader);
            }

            SliverList sliverList = sliverStickyHeader.sliver;
            SliverChildListDelegate sliverChildListDelegate =
                sliverList.delegate;
            sliverChildListDelegate.children.add(ListTile(
              leading: CircleAvatar(
                child: Text(date.day.toString()),
              ),
              title: Text(event['title']),
              subtitle: Text(event['content'].replaceAll("\n", " "),
                  overflow: TextOverflow.ellipsis),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Event.routeName,
                  arguments: EventArguments(eventId),
                );
              },
            ));
          });

          formattedEvents.insert(
              0,
              SliverAppBar(
                pinned: true,
                iconTheme: IconThemeData(
                    color: Theme.of(context).textTheme.bodyText1.color),
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "Home",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                  background: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          Theme.of(context).brightness == Brightness.light ? "assets/cover_bright.png" : "assets/cover_dark.png",
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
                      ],
                    ),
                  ),
                ),
              ));
          return CustomScrollView(slivers: formattedEvents);
        });
  }
}
