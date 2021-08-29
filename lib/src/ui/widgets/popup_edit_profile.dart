// Popup UI taken from StackOverflow user Ajay Kumar:
// https://stackoverflow.com/questions/54480641/flutter-how-to-create-forms-in-popup

import 'package:flutter/material.dart';
import 'package:southsidepc/login_required/helper.dart';
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
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    validator: validateName,
                    onSaved: (name) {
                      widget.user.name = name ?? '';
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
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _phoneController,
                    textInputAction: TextInputAction.next,
                    validator: validateMobile,
                    onSaved: (phone) {
                      widget.user.phone = phone ?? '';
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      hintText: widget.user.phone != ''
                          ? widget.user.phone
                          : 'Enter phone number',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text("Update"),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        showDialog(
                            context: context,
                            builder: (_) =>
                                Text(widget.user.toJson().entries.join()));
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
