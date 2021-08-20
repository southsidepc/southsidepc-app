import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:southsidepc/src/models/user_state.dart';

import 'package:southsidepc/login_required/login_required.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final List<String> _order = ['events', 'navigate'];
  final List<bool> _checkBoxes = [true, true];

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
            subtitle: Text(user.email + '\n' + user.phone),
            trailing: ElevatedButton(
              child: Text("Edit"),
              onPressed: () {},
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
              alignment: Alignment.bottomRight,
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
