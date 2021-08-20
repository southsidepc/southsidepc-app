import 'dart:core';

import 'package:southsidepc/login_required/user_base.dart';

class UserState extends UserBase {
  String phone = '';
  List<String> notifications = [];

  @override
  void updateFromJson(Map<String, dynamic> parsedJson) {
    // super
    super.updateFromJson(parsedJson);

    // phone
    this.phone = parsedJson['phone'] ?? '';

    // notifications
    String? s = parsedJson['notifications'];
    if (s == null) {
      return;
    }
    this.notifications.addAll(s.split(' '));
  }

  @override
  Map<String, dynamic> toJson() {
    // super
    return {
      ...super.toJson(),
      ...{
        'phone': this.phone,
        //'notifications': this.notifications.join(' '),
      }
    };
  }
}
