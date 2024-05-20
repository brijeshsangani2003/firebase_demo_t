import 'package:firebase_demo_t/core/utils/preference.dart';
import 'package:firebase_demo_t/screen/sign_up_screen.dart';
import 'package:firebase_demo_t/services/email_auth_services.dart';
import 'package:flutter/material.dart';

import '../common_widget/common_textfield.dart';
import 'homescreen_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Log In',
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
                        FirebaseEmailAuthServices.signInUser(
                                email: email.text, password: password.text)
                            .then((value) {
                          if (value != null) {
                            preferences.email = email.text;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeAuthScreen(),
                                ));
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid email or password!'),
                          ),
                        );
                      }
                    },
                    color: Colors.blueAccent,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Log In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text("Sign Up"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
