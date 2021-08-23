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
    this.notifications.clear();
    this.notifications.addAll(s.split(' '));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      // super: UserBase
      ...super.toJson(),
      // this: UserState
      ...{
        'phone': this.phone,
        'notifications': this.notifications.join(' '),
      }
    };
  }

  String get initials => this.name.split(' ').map((s) => s[0]).join();
}
