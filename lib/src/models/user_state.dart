import 'dart:core';

import 'package:southsidepc/login_required/user_base.dart';
import 'package:southsidepc/login_required/authenticate.dart';

class UserState extends UserBase {
  static const List<String> NotifyStrings = [
    'events',
    'navigate',
  ];

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

  /// hasNotification()
  bool hasNotification(String notifyString) {
    assert(NotifyStrings.contains(notifyString));
    return this.notifications.contains(notifyString);
  }

  /// setNotification()
  void setNotification(String notifyString, bool value) {
    assert(NotifyStrings.contains(notifyString));
    if (value) {
      assert(!this.hasNotification(notifyString));
      this.notifications.add(notifyString);
    } else {
      assert(this.hasNotification(notifyString));
      this.notifications.remove(notifyString);
    }
  }

  /// updateRemote()
  Future<void> updateRemote() async {
    FireStoreUtils.updateCurrentUser(this);
  }
}
