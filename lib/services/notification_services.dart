import 'dart:math';

import 'package:firebase_demo_t/screen/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///jyre application active hoy ,background pr hoy and application sav close thai gai hoy tyre means k killed thai hoy tyre
//AndroidManifest.xml ama aa 3 line add karvi.
// <meta-data
// android:name="com.google.firebase.messaging.default_notification_channel_id"
// android:value="high_importance_channel" />

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int notificationCount = 0;

  ///requestPermission
  Future<void> requestNotificationPermission() async {
    await messaging.requestPermission();
  }

  ///app active hoy tyre notification ave aa mate.
  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    //android
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    //ios
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //redirect page mate onDidReceiveNotificationResponse
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification?.title.toString());
      print(message.notification?.body.toString());
      print(message.data
          .toString()); //firebase ma jetla data add kara hse aa batavse badha.means k payload.(firebase ma Additional options ni ander custom data(ket and value ape aa))
      print(message.data['type']);
      print(message.data['id']);

      initLocalNotification(context, message);
      showNotification(message);
    });
  }

  ///active hoy tyre
  Future<void> showNotification(RemoteMessage message) async {
    //android mate
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Your Channel Description',
      icon: '@mipmap/ic_launcher',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      ticker: 'ticker',
    );
    //ios mate
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // flutterLocalNotificationsPlugin show mate aa 4 vastu magse.
    flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title.toString(),
      message.notification?.body.toString(),
      notificationDetails,
    );

    // Increment the notification count
    notificationCount++;

    // Update the badge count
    FlutterAppBadger.updateBadgeCount(notificationCount);
  }

  // Clear the notification count and update the badge
  void clearNotificationCount() {
    notificationCount = 0;
    FlutterAppBadger.removeBadge();
  }

  ///device token(FCM Token)
  Future<String?> getDeviceToken() async {
    String? FCMToken = await messaging.getToken();
    print('FCM Token : $FCMToken');
    return FCMToken;
  }

  ///token expire thai gyo hoy to refresh thai.
  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('Refresh Token');
    });
  }

  //one device to another device notification hoy tyre means k (button uper click kare tyre aa code use thai.)
  ///app background/terminated hoy tyre redirect thai aa mate
  Future<void> setupIntreactMessage(BuildContext context) async {
    //when app is terminated.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage(); //automatic message handle kari lese.

    //when App background
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  ///App Active hoy tyre Redirect thase bija page pr
  //firebase ma apne ji key api hoy aa ley ne Redirect thase bija page uper.
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              id: message.data['id'],
            ),
          ));

      // Clear the badge count when notification is opened
      clearNotificationCount();
    }
  }
}
