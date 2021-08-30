import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:southsidepc/src/models/user_state.dart';

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
          Text(
            'Notifications',
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
                  onChanged: (value) => setState(() {
                    _checkBoxes[_order.indexOf(e)] = value!;
                  }),
                ),
              ],
            );
          }), // map()
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
