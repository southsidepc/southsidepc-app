import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/ui/sound_recorder_ui.dart';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:flutter_sound_lite/public/tau.dart';
import 'package:flutter_sound_lite/public/ui/recorder_playback_controller.dart';
import 'package:flutter_sound_lite/public/ui/sound_player_ui.dart';
import 'package:flutter_sound_lite/public/ui/sound_recorder_ui.dart';
import 'package:flutter_sound_lite/public/util/enum_helper.dart';
import 'package:flutter_sound_lite/public/util/flutter_sound_ffmpeg.dart';
import 'package:flutter_sound_lite/public/util/flutter_sound_helper.dart';
import 'package:flutter_sound_lite/public/util/temp_file_system.dart';
import 'package:flutter_sound_lite/public/util/wave_header.dart';

import 'package:southsidepc/src/models/devotion_data.dart';

class Devotion extends StatefulWidget {
  static const routeName = '/devotion';
  final String id;

  Devotion(this.id, {Key? key}) : super(key: key);

  @override
  _DevotionState createState() => _DevotionState();
}

class _DevotionState extends State<Devotion> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final String mp3File =
      "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3";

  late Track track;
  _DevotionState() {
    //_player.openAudioSession(withUI: true);
    //_player.onProgress?.listen((e) => _onProgress(e));
  }

  @override
  void initState() {
    super.initState();
    track = Track.fromAsset('assets/rock.mp3', mediaFormat: Mp3MediaFormat());
  }

  @override
  void dispose() {
    //_player.closeAudioSession();
    super.dispose();
  }

  void _onProgress(PlaybackDisposition e) {
    print('Position = ${e.position}');
  }

  Future<void> _onPressed() async {
    if (_player.isPaused) {
      await _player.startPlayer(fromURI: mp3File, codec: Codec.mp3);
    } else if (_player.isPlaying) {
      await _player.stopPlayer();
    } else {
      // isStopped
      await _player.startPlayer(fromURI: mp3File, codec: Codec.mp3);
    }
    setState(() {});
  }

  Widget _getIcon() {
    if (_player.isPaused) {
      return Icon(Icons.pause);
    } else if (_player.isPlaying) {
      return Icon(Icons.stop);
    } else {
      return Icon(Icons.play_arrow);
    }
  }

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
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: SoundPlayerUI.fromLoader(
                (context) async => Track(trackPath: mp3File),
              ),
            ),
            /*IconButton(
              icon: _getIcon(),
              onPressed: () async => await _onPressed(),
            ),*/
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
