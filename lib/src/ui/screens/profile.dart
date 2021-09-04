import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:southsidepc/src/models/user_state.dart';

import 'package:southsidepc/src/locator.dart';

import 'package:southsidepc/login_required/login_required.dart';
import 'package:southsidepc/src/ui/widgets/popup_edit_profile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final List<String> _order = ['events', 'navigate'];
  final List<bool> _checkBoxes = [true, true];

  String _if_non_empty(String s, String empty) {
    return s != '' ? s : empty;
  }

  List<Widget> _notifications() {
    var user = LoginRequired.currentUser;
    var authStatus = locator<NotificationSettings>().authorizationStatus;
    var enabled = authStatus == AuthorizationStatus.authorized ||
        authStatus == AuthorizationStatus.provisional;
    return [
      Text(
        'Notifications' + (enabled ? '' : ' - not available on this device'),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      ...user.notifications.map((e) {
        return Row(
          children: [
            Flexible(child: Text('- $e'), fit: FlexFit.tight),
            Checkbox(
              value: _checkBoxes[_order.indexOf(e)],
              onChanged: enabled
                  ? (value) => setState(() {
                        _checkBoxes[_order.indexOf(e)] = value!;
                      })
                  : null,
            ),
          ],
        );
      }) // map
    ]; // return
  }

  @override
  Widget build(BuildContext context) {
    var user = LoginRequired.currentUser as UserState;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(child: Text(user.initials)),
            title: Text(user.name),
            subtitle: Text(user.email +
                '\n' +
                _if_non_empty(user.phone, 'Phone number empty')),
            trailing: ElevatedButton(
              child: Text("Edit"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => PopupEditProfile(user),
                ).then(
                  (value) {
                    if (value != null) {
                      setState(() {});
                    }
                  },
                );
              },
            ),
          ),
          Divider(),
          ..._notifications(),
          Divider(),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                child: Text("Logout"),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
