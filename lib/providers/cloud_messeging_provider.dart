import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class FirebaseCloudMessagingService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// webとiOS向け設定
  void setting() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void fcmGetToken() async {
    final fcmToken = await messaging.getToken();

    print('これがClould messegingのトークンです。${fcmToken}');
  }

  Future<void> sendPushNotification({
    required String token,
    required String title,
    String body: '',
    String type: '',
    String room: '',
    String postId: '',
  }) async {
    final fcmKey =
        'AAAAp4zDf3c:APA91bGO5_-fTx8RdduOd04s4KFIJhqMlcTGigr1VZVZCHp8Bj1u0u_vE_iqXVskAfx_rfCE3OMJoHoaX9bMzY_HtBrIV8yVSWcXhNT4bsAywnzRklm9jUhBWn7nTvARzmf-wUeMrhUi';
    final data = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "type": type,
        "room": room,
        'postId': postId,
      },
      "to": token,
    };

    final headers = {
      'Content-type': 'application/json',
      'Authorization': 'key=${fcmKey}',
    };

    final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode(data),
        headers: headers);

    if (response.statusCode == 200) {
      print('Push Notification Sent.');
    } else {
      print('Error ${response.statusCode}');
    }
  }

  Future<void> locaknotify(
    int _hashCode,
    String? _title,
    String? _body,
  ) {
    final flnp = FlutterLocalNotificationsPlugin();
    return flnp
        .initialize(
          InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings(),
          ),
        )
        .then((_) => flnp.show(
            _hashCode,
            _title,
            _body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'channel_id',
                'channel_name',
              ),
            )));
  }

  void iOSForegroundNotification() {
    messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }
}

@immutable
class isNotify {
  isNotify({required this.istrue});
  final bool istrue;
}

class isNotifyNotifier extends StateNotifier<isNotify> {
  isNotifyNotifier() : super(isNotify(istrue: true));

  void setisNotify(value) {
    state = isNotify(istrue: value);
  }
}

final isNotifyProvider =
    StateNotifierProvider<isNotifyNotifier, isNotify>((ref) {
  return isNotifyNotifier();
});
