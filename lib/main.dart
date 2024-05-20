import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_demo_t/core/utils/preference.dart';
import 'package:firebase_demo_t/screen/firebase_SignUpScreen.dart';
import 'package:firebase_demo_t/screen/getx_with_localDatabaseScreen.dart';
import 'package:firebase_demo_t/screen/local_database_screen.dart';
import 'package:firebase_demo_t/screen/home_page.dart';
import 'package:firebase_demo_t/screen/network_error_screen.dart';
import 'package:firebase_demo_t/screen/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Preferences.init();
  //background notification
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

//Terminated notification @pragma('vm:entry-point') aa khali lkaho etle virtual machine(vm) aa run karse.application bandh hoy toy ave.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification?.title.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SplashScreen(),
      // home: MobileScreen(),
      ///ama firebase ma and app ma bev ma data show thai che.
      // home:
      //     FirebaseSignUpScreen(), //network connection check multiple screen code
      // home:
      //     LocalDatabaseScreen(), //net bandh hoy toy app chalti hoy(means k low network avtu hoy tyre) pn jai net chalu kare etle ui ma pn data get thava joi aa.
      home: GetxLocalDatabaseScreen(),
      // home: const HomePage(),
      // home: Notification_screen(),
    );
  }
}
