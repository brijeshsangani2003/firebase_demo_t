import 'package:firebase_demo_t/screen/sign_up_screen.dart';
import 'package:firebase_demo_t/services/email_auth_services.dart';
import 'package:flutter/material.dart';

import '../core/utils/preference.dart';
import '../services/google_auth_services.dart';

class HomeAuthScreen extends StatefulWidget {
  const HomeAuthScreen({super.key});

  @override
  State<HomeAuthScreen> createState() => _HomeAuthScreenState();
}

class _HomeAuthScreenState extends State<HomeAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              'Home Screen',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 17),
              child: InkWell(
                onTap: () {
                  FirebaseEmailAuthServices.logout().then((value) {
                    try {
                      GoogleAuthServices.logout();
                    } catch (e) {
                      print('=====>${e}');
                    }
                    preferences.remove('email');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ));
                  });
                },
                child: Center(
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
