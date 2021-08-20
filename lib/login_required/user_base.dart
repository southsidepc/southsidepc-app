import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class UserBase {
  @mustCallSuper
  UserBase(
      {this.email = '',
      this.name = '',
      this.userID = '',
      this.profilePictureURL = ''})
      : this.appIdentifier = 'Southside App Login ${Platform.operatingSystem}';

  ////////////////////////
  // exported interface //
  ////////////////////////

  String email;

  String name;

  String userID;

  String profilePictureURL;

  String appIdentifier;

  /*User constructFrom(
      {required String email,
      required String name,
      required String userID,
      required String profilePictureURL}) {
    return User(
        email: email,
        name: name,
        userID: userID,
        profilePictureURL: profilePictureURL);
  }*/

  @mustCallSuper
  void updateFromJson(Map<String, dynamic> parsedJson) {
    email = parsedJson['email'] ?? '';
    name = parsedJson['name'] ?? '';
    userID = parsedJson['id'] ?? parsedJson['userID'] ?? '';
    profilePictureURL = parsedJson['profilePictureURL'] ?? '';
  }

  @mustCallSuper
  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'name': this.name,
      'id': this.userID,
      'profilePictureURL': this.profilePictureURL,
      'appIdentifier': this.appIdentifier
    };
  }
}
