//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:intl/intl.dart';
import 'package:community_material_icon/community_material_icon.dart';

const Color spotifyGreen = Color(0xFF1DB954);

const Color soundcloudOrange = Color(0xFFFE5000);

const Color googleYellow = Color(0xFFFBBC05);

class Resources extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 48, top: 16, right: 48, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "Magnification",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(
              height: 8,
              child: Container(),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                String url =
                    'https://open.spotify.com/playlist/5p0cw0WFvC5Bmkf5vyR4bG?si=-oj_dClxRUeeOUOWbg091g';

                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              icon: Icon(
                CommunityMaterialIcons.spotify,
                color: spotifyGreen,
              ),
              label: Text('Open in Spotify'),
              //highlightedBorderColor: spotifyGreen, // NA for OutlinedButton
            ),
            SizedBox(
              height: 16,
              child: Container(),
            ),
            Center(
              child: Text(
                "Navigate Podcast",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(
              height: 8,
              child: Container(),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                String url =
                    'https://open.spotify.com/show/0PRkJlUMpq0dhBoUMhFsyQ';

                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              icon: Icon(
                CommunityMaterialIcons.spotify,
                color: spotifyGreen,
              ),
              label: Text('Open in Spotify'),
              //highlightedBorderColor: spotifyGreen,
            ),
            SizedBox(
              height: 8,
              child: Container(),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                String url = 'pcast://feed.podbean.com/navigate/feed.xml';

                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  await launch(
                      'https://open.spotify.com/show/0PRkJlUMpq0dhBoUMhFsyQ');
                }
              },
              icon: Image.asset(
                'assets/google_podcast.png',
                height: 20,
              ),
              label: Text('Open Podcast'),
              //highlightedBorderColor: googleYellow,
            ),
            SizedBox(
              height: 16,
              child: Container(),
            ),
            Center(
              child: Text(
                "Sermons",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(
              height: 8,
              child: Container(),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                String url =
                    'https://open.spotify.com/show/0HrMcpDD9YDdyMfOyojmFe?si=NUvzGQUwTrCxijZHAkSvcg';

                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              icon: Icon(
                CommunityMaterialIcons.spotify,
                color: spotifyGreen,
              ),
              label: Text('Open in Spotify'),
              //highlightedBorderColor: spotifyGreen,
            ),
            SizedBox(
              height: 8,
              child: Container(),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                String url =
                    'pcast://feeds.soundcloud.com/users/soundcloud:users:212248612/sounds.rss';

                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  await launch('https://soundcloud.com/southside-presbyterian');
                }
              },
              icon: Image.asset(
                'assets/google_podcast.png',
                height: 20,
              ),
              label: Text('Open Podcast'),
              //highlightedBorderColor: googleYellow,
            ),
            SizedBox(
              height: 8,
              child: Container(),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                String url = 'https://soundcloud.com/southside-presbyterian';

                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              icon: Icon(
                CommunityMaterialIcons.soundcloud,
                color: soundcloudOrange,
              ),
              label: Text('Open in Soundcloud'),
              //highlightedBorderColor: soundcloudOrange,
            ),
            SizedBox(
              height: 8,
              child: Container(),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                String url = 'https://southsidepc.org/live';

                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'The podcast could not be opened. Please install podcast app.')));
                }
              },
              icon: Icon(CommunityMaterialIcons.video_outline),
              label: Text('Open Videos'),
            ),
          ],
        ),
      ),
    );
  }
}
