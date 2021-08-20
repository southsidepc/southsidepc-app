import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import "event.dart";

class Home extends StatelessWidget {
  final Query<Map<String, dynamic>> _events = FirebaseFirestore.instance
      .collection('events')
      .orderBy('date', descending: true)
      .where('published', isEqualTo: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _events.snapshots(),
      builder: (context, snapshot) {
        // this builder turns the snapshot into a List of slivers (as Widgets)
        // wrapped in a CustomScrollView

        // regardless of snapshot state, display AppBar
        var slivers = <Widget>[
          _makeHomeAppBar(context),
        ];

        // check for error: add message if so
        if (snapshot.hasError) {
          var sliver = SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Text("Error while communicating with server."),
              ],
            ),
          );
          slivers.add(sliver);
        }

        // check for loading: add message if so
        else if (snapshot.connectionState == ConnectionState.waiting) {
          var sliver = SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text("Loading events ..."),
                ),
              ],
            ),
          );
          slivers.add(sliver);
        }

        // snapshot ready!
        // construct List of widgets to display
        else {
          /// eventsByMonth
          /// - List of type SliverStickyHeader
          /// - each SliverStickyHeader has a SliverList for a child
          /// - each SliverList contains a particular month's events
          ///   as children
          var eventsByMonth = <SliverStickyHeader>[];

          // order and format events
          final events = snapshot.data?.docs;
          if (events != null) {
            events.forEach(
              (document) {
                var event = document.data() as Map<String, dynamic>?;
                if (event == null) return;
                _addEvent(eventsByMonth, event, _getDateFromEvent(event),
                    document, context);
              }, // lambda
            ); // forEach()
          }

          // add eventsByMonth to list of widgets (SliverStickyHeaders) to display
          slivers.addAll(eventsByMonth);
        }

        // make CustomScrollView
        return CustomScrollView(slivers: slivers);
      },
    );
  } // Home.build()

  void _addEvent(
      List<SliverStickyHeader> eventsByMonth,
      Map<String, dynamic> event,
      DateTime date,
      QueryDocumentSnapshot<Object?> document,
      BuildContext context) {
    // get (or create) the SliverStickyHeader corresponding
    // to the month of this event
    var tgtHeader = _getHeaderByMonth(eventsByMonth, event, date, context);

    // add this event to 'tgtHeader'
    // [ access via delegate ]
    ((tgtHeader.sliver as SliverList).delegate as SliverChildListDelegate)
        .children
        .add(
          ListTile(
            leading: CircleAvatar(
              child: Text(date.day.toString()),
            ),
            title: Text(event['title']),
            subtitle: Text(
              event['content'].replaceAll("\n", " "),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                Event.routeName,
                arguments: EventArguments(document.id),
              );
            },
          ),
        ); // add()
  }

  /// _getDateFromEvent()
  DateTime _getDateFromEvent(Map<String, dynamic> event) =>
      DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(event['date'], true).toLocal();

  /// _getHeaderByMonth()
  ///  - Given a list of events catalogued by month (as SliverStickyHeaders),
  ///    gets (creating if necessary) the SliverStickyHeader corresponding to
  ///    the month of the supplied event.
  ///  - (A BuildContext is needed to create the SliverStickyHeader.)
  SliverStickyHeader _getHeaderByMonth(List<SliverStickyHeader> eventsByMonth,
      Map<String, dynamic> event, DateTime date, BuildContext context) {
    var monthYear = DateFormat("MMMM yyyy").format(date);
    return eventsByMonth.firstWhere(
      (month) {
        var header = month.header;
        if (header == null) return false;
        if (header is! Container) return false;
        var child = header.child;
        if (child == null) return false;
        if (child is! Text) return false;
        return child.data == monthYear;
      },
      // header not found; create
      orElse: () => _makeHeaderFromDate(eventsByMonth, monthYear, context),
    );
  }

  /// _makeHeaderFromDate()
  /// - creates a SliverSitckyHeader corresponding to the given date,
  ///   adds this to the list of events, then returns the header
  SliverStickyHeader _makeHeaderFromDate(List<SliverStickyHeader> eventsByMonth,
      String date, BuildContext context) {
    var header = SliverStickyHeader(
      header: Container(
        height: 40.0,
        color: Theme.of(context).canvasColor,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          date,
          style: TextStyle(color: Theme.of(context).textTheme.subtitle1?.color),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[],
        ),
      ),
    );

    eventsByMonth.add(header);
    return header;
  }

  SliverAppBar _makeHomeAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      iconTheme:
          IconThemeData(color: Theme.of(context).textTheme.bodyText1?.color),
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: Text(
          "Home",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
        ),
        background: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/cover_bright.png"
                    : "assets/cover_dark.png",
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
    );
  }
}
