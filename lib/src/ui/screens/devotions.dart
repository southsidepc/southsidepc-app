// external imports
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

// internal imports: models
import 'package:southsidepc/src/models/devotion_data.dart';

// internal imports: screens
import 'devotion.dart';

class Devotions extends StatefulWidget {
  @override
  _Devotions createState() => _Devotions();
}

class _Devotions extends State<Devotions> {
  Query<Map<String, dynamic>> _incomingDevotions = FirebaseFirestore.instance
      .collection('devotions')
      .orderBy('date', descending: true);
  //.where('published', isEqualTo: true);

  List<MonthOfDevotions> _devotionsByMonth = [];
  List<SliverStickyHeader> _headers = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _incomingDevotions.snapshots(),
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
        return Scaffold(
          body: CustomScrollView(
            slivers: slivers,
          ),
        );
      }, // builder:
    );
  }

  void _addDevotion(Map<String, dynamic> dbEvent, String id) {
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
                  final devotion = month.devotions.elementAt(index);
                  final date = devotion.toLocalDateTime();
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(date.day.toString()),
                    ),
                    title: Text(devotion.title),
                    subtitle: Text(
                      devotion.title,
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
                childCount: month.devotions.length,
              ),
            ),
          ),
        );
      },
    );
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
