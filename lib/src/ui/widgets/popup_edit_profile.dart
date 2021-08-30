// Popup UI taken from StackOverflow user Ajay Kumar:
// https://stackoverflow.com/questions/54480641/flutter-how-to-create-forms-in-popup

import 'package:flutter/material.dart';
import 'package:southsidepc/login_required/authenticate.dart';
import 'package:southsidepc/login_required/helper.dart';
import 'package:southsidepc/login_required/login_required.dart';
import 'package:southsidepc/src/models/user_state.dart';

class PopupEditProfile extends StatefulWidget {
  final UserState user;

  PopupEditProfile(this.user);

  @override
  _PopupEditProfileState createState() => _PopupEditProfileState();
}

class _PopupEditProfileState extends State<PopupEditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Edit profile',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Display name:',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    validator: validateName,
                    onSaved: (name) {
                      widget.user.name = name?.trim() ?? '';
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      hintText: widget.user.name != ''
                          ? widget.user.name
                          : 'Enter display name',
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phone:',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _phoneController,
                    textInputAction: TextInputAction.next,
                    validator: validateMobile,
                    onSaved: (phone) {
                      widget.user.phone = phone?.trim() ?? '';
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      hintText: widget.user.phone != ''
                          ? widget.user.phone
                          : 'Enter phone number',
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text("Update"),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      await FireStoreUtils.updateCurrentUser(widget.user);
                      Navigator.pop(context, true); // non-null = success
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Profile updated.'),
                        action: SnackBarAction(
                          label: 'Got it!',
                          onPressed: () {},
                        ),
                      ));
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
