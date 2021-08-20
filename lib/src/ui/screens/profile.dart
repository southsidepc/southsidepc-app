import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:southsidepc/src/models/user_state.dart';

import 'package:southsidepc/login_required/login_required.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = LoginRequired.currentUser as UserState;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              child: Text("Logout"),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
            Text('Phone: ${user.phone}'),
            Card(
              child: Column(
                children: [
                  Text('Notifications'),
                  ...user.notifications.map((e) => Text('- $e')).toList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _noUserView() {
    return Form(
      //key: _formKey,
      child: Column(
        children: <Widget>[
          Text("TODO: Login or create account form"),
        ],
      ),
    );
  }

  Widget _yesUserView() {
    return Row(
      children: [
        CircleAvatar(
          child: Text('WB'),
        ),
        Expanded(
          child: Column(
            children: [
              /*Text(user.name),
              Text(user.email),
              if (user.phone != null) Text(user.phone!),*/
            ],
          ),
        )
      ],
    );
  }
}
