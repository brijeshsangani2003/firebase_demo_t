import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo_t/core/utils/preference.dart';
import 'package:firebase_demo_t/screen/homescreen_auth.dart';
import 'package:firebase_demo_t/services/email_auth_services.dart';
import 'package:flutter/material.dart';

import '../common_widget/common_textfield.dart';
import '../services/google_auth_services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  common_text_field(
                    validator: (value) {
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (value!.isEmpty) {
                        return 'email can not be empty';
                      } else if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                    },
                    hinttext: 'Email',
                    controller: email,
                  ),
                  const SizedBox(height: 20),
                  common_text_field(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password can not be empty';
                      } else if (value.length < 8) {
                        return 'Password must be in 8 Digits';
                      }
                    },
                    hinttext: 'Password',
                    controller: password,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: MaterialButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          FirebaseEmailAuthServices.signUpUser(
                                  email: email.text, password: password.text)
                              .then((value) {
                            if (value != null) {
                              preferences.email = email.text;
                              FirebaseFirestore.instance
                                  .collection('demo')
                                  .add({'email': email.text});
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeAuthScreen(),
                                  ));
                            }
                          });
                        }
                      },
                      color: Colors.blueAccent,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: MaterialButton(
                      onPressed: () {
                        // GoogleAuthServices.signInWithGoogle().then((value) {
                        //   if (value.user != null) {
                        //     preferences.email = value.user?.email ?? '';
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const HomeAuthScreen(),
                        //       ),
                        //     );
                        //   } else {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //         content: Text('Something went wrong!'),
                        //       ),
                        //     );
                        //   }
                        // });
                        GoogleAuthServices.signInWithGoogle().then((value) {
                          if (value.user != null) {
                            preferences.isGoogleSignedIn =
                                true; // Set the boolean flag
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeAuthScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Something went wrong!'),
                              ),
                            );
                          }
                        });
                      },
                      color: Colors.orangeAccent,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign up with Google',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
