import 'package:flutter/material.dart';

class HomeOtpScreen extends StatefulWidget {
  const HomeOtpScreen({super.key});

  @override
  State<HomeOtpScreen> createState() => _HomeOtpScreenState();
}

class _HomeOtpScreenState extends State<HomeOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(child: Text('Home Screen')),
      ),
    );
  }
}
