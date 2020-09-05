import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:community_material_icon/community_material_icon.dart';

class Connect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.only(left: 48, top: 16, right: 48, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  "Want to keep up to date with what is happening at Southside, connect with us online.",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 48,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                        child: GestureDetector(
                          onTap: () {
                            launch("https://southsidepc.org/");
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/logo.png',
                                  width: 80.0, height: 80.0),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                  "www.southsidepc.org",
                              style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          )
                        )
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 48,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                        child: GestureDetector(
                            onTap: () {
                              launch("https://www.facebook.com/southsidepc");
                            },
                            child: Column(
                              children: [
                                Image.asset('assets/facebook_icon.png',
                                    width: 80.0, height: 80.0),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "@southsidepc",
                                  style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            )
                        )
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 48,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                        child: GestureDetector(
                            onTap: () {
                              launch("https://www.instagram.com/southside.church");
                            },
                            child: Column(
                              children: [
                                Image.asset('assets/instagram_icon.png',
                                    width: 80.0, height: 80.0),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "@southside.church",
                                  style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            )
                        )
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
