import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo_t/screen/local_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_demo_t/local_databse_offline_online/local_database.dart';

class LocalDatabaseScreen extends StatefulWidget {
  const LocalDatabaseScreen({super.key});

  @override
  State<LocalDatabaseScreen> createState() => _LocalDatabaseScreenState();
}

class _LocalDatabaseScreenState extends State<LocalDatabaseScreen> {
  final LocalDatabase localDatabase = LocalDatabase();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Future<void> addUserToFirestore(String name, String email) async {
  //   await FirebaseFirestore.instance.collection('user').add({
  //     'name': name,
  //     'email': email,
  //   });
  // }

  Future<void> saveData() async {
    // First add the data to the local database
    await localDatabase.insertUser(
      nameController.text,
      emailController.text,
    );
    nameController.clear();
    emailController.clear();

    //add UserTo Firebase
    // addUserToFirestore(nameController.text, emailController.text);

    syncDataWithFirebase(); //sync with firebase

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocalHomeScreen(),
        ));
  }

  Future<void> syncDataWithFirebase() async {
    var users = await localDatabase.fetchUsers(); // Get local data

    for (var user in users) {
      await FirebaseFirestore.instance.collection('user').add({
        'name': user['name'],
        'email': user['email'],
      });
    }

    await localDatabase.clearUserTable(); // Clear local data after sync
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offline-Online Sync"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: saveData, // Save and sync data
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
