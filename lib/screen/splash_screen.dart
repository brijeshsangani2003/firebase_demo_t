import 'dart:async';
import 'package:firebase_demo_t/screen/sign_in_screen.dart';
import 'package:firebase_demo_t/screen/sign_up_screen.dart';
import 'package:firebase_demo_t/screen/homescreen_auth.dart';
import 'package:flutter/material.dart';

import '../core/utils/preference.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userEmail;

  Future getUserEmail() async {
    var email = preferences.email;
    userEmail = email;
    setState(() {});
  }

  @override
  void initState() {
    getUserEmail().whenComplete(() => Timer(const Duration(seconds: 3), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => userEmail == null
                  ? const SignInScreen()
                  : const HomeAuthScreen(),
            ),
          );
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Splash Screen',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
