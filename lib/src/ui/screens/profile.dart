//import 'package:community_material_icon/community_material_icon.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:southsidepc/src/models/user_state.dart';

class Profile extends StatelessWidget {
  final UserState user = UserState();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: user == null ? _noUserView() : _yesUserView(user),
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

  Widget _yesUserView(UserState user) {
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
