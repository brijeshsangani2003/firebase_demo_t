import 'dart:convert';

import 'package:firebase_demo_t/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notification_screen extends StatefulWidget {
  const Notification_screen({super.key});

  @override
  State<Notification_screen> createState() => _Notification_screenState();
}

class _Notification_screenState extends State<Notification_screen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    //show notification
    notificationServices.firebaseInit(context);
    notificationServices.setupIntreactMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print('device token');
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: TextButton(
          onPressed: () {
            notificationServices.getDeviceToken().then((value) async {
              var data = {
                //'to': value.toString() ama apne ji device ma notification moklvi che aa token add karvanu.
                // 'to': value.toString(),
                'to':
                    'fxkw6DDcQFuUi8vyN5yWr0:APA91bFLpgguL-Ma0h5Mt3UE8omV2nGnWduDdQMCPjzthaQaTfXv7BY0wAUbuUxWVuUkurMIrD_xsCykcPgzwRujxelOVOdqnTwCR_llzPtn7-eZvru6Xwn_EY5MbNb8DklHa1Y1xYmJ',
                'priority': 'high',
                'notification': {
                  'title': 'Technoyuga',
                  'body': 'Welcome to technoyuga channel'
                },
                //redirect user specific page
                'data': {
                  'type': 'msg',
                  'id': '12345',
                }
              };
              await http.post(
                Uri.parse('https://fcm.googleapis.com/fcm/send'),
                body: jsonEncode(data),
                headers: {
                  'Content-type': 'application/json; charset=UTF-8',
                  //aa firebase ma Project settings ma Cloud Messaging ma Cloud Messaging API (Legacy)Enabled jo aa disable hoy to ene enable kari devanu and ['key=ahiya aa token add karvu']
                  //mara server ni key add karvani.
                  'Authorization':
                      'key=AAAApQ31_48:APA91bHcVtCdnnQOXhKhOU9EX-JIX3cJ_AuUnvcCFQhCAU-DvbzH2XirgskMvJ_fTLyQDpoxx9D6gR8Pz1-5enSFHLQcZnjfjw8e3ZJaWEnmsHEP5EbCyudR3tL5zR1bFwf1_rM2khia'
                },
              );
            });
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.tealAccent)),
          child: const Text('Send Notification'),
        ),
      )),
    );
  }
}
