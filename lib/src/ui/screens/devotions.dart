import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

import "package:southsidepc/src/ui/screens/devotion.dart";

class DevotionData {
  String imageName;
  String link;
  String date;
  String title;
  String image;
  String content;
  String id;

  DevotionData.fromDB(Map<String, dynamic> dbEntry, {String id = ""})
      : imageName = dbEntry["imageName"],
        link = dbEntry["link"],
        date = dbEntry["date"],
        title = dbEntry["title"],
        image = dbEntry["image"],
        content = dbEntry["content"],
        id = id;

  DateTime toLocalDateTime() {
    return DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(date, true).toLocal();
  }

  String toMonthYear() {
    return DateFormat("MMMM yyyy").format(toLocalDateTime());
  }
}

class Devotions extends StatefulWidget {
  @override
  _Devotions createState() => _Devotions();
}

class MonthOfDevotions {
  final List<DevotionData> _devotions = [];
  final String monthYear;

  MonthOfDevotions(this.monthYear);

  void addDevotion(DevotionData devotion) {
    _devotions.add(devotion);
  }
}

class _Devotions extends State<Devotions> {
  Query<Map<String, dynamic>> _incomingEvents = FirebaseFirestore.instance
      .collection('devotions')
      .orderBy('date', descending: true)
      .where('published', isEqualTo: true);

  List<MonthOfDevotions> _devotionsByMonth = [];
  List<SliverStickyHeader> _headers = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _incomingEvents.snapshots(),
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
                  title: Text("Loading devotions ..."),
                ),
              ],
            ),
          );
          slivers.add(sliver);
        }

        // snapshot ready!
        // construct List of widgets to display
        else {
          // order and format devotions
          final devotions = snapshot.data?.docs;
          if (devotions != null) {
            devotions.forEach(
              (document) {
                var devotion = document.data() as Map<String, dynamic>?;
                if (devotion == null) return;
                _addDevotion(devotion, document.id);
              }, // lambda
            ); // forEach()
          }

          // add
          _makeHeaders();
          slivers.addAll(_headers);
        }

        // make CustomScrollView
        return CustomScrollView(
          slivers: slivers,
        );
      }, // builder:
    );
  }

  void _addDevotion(
    Map<String, dynamic> dbEvent,
    String id,
  ) {
    final devotion = DevotionData.fromDB(dbEvent, id: id);
    final monthYear = devotion.toMonthYear();

    // get a MonthOfDevotion corresponding to the devotion to be added
    final month = _devotionsByMonth.singleWhere(
      (monthOfDevotions) => monthOfDevotions.monthYear == monthYear,
      orElse: () {
        // no such MonthOfEvents found, so create one using the event
        final newMonth = MonthOfDevotions(monthYear);
        _devotionsByMonth.add(newMonth);

        return newMonth;
      },
    );

    month.addDevotion(devotion);
  }

  void _makeHeaders() {
    // create SliverStickyHeader
    _devotionsByMonth.forEach(
      (month) {
        final monthYear = month.monthYear;
        _headers.add(
          SliverStickyHeader(
            header: Container(
              height: 40.0,
              color: Theme.of(context).canvasColor,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                monthYear,
                style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle1?.color),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final devotion = month._devotions.elementAt(index);
                  final date = devotion.toLocalDateTime();
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(date.day.toString()),
                    ),
                    title: Text(devotion.title),
                    subtitle: Text(
                      devotion.content.replaceAll("\n", " "),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Devotion(devotion.id),
                        ),
                      );
                    },
                  );
                },
                childCount: month._devotions.length,
              ),
            ),
          ),
        );
      },
    );
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
          "Devotions",
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
