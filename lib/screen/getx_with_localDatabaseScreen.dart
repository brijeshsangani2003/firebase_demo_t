import 'package:firebase_demo_t/constants/firebase_constants.dart';
import 'package:firebase_demo_t/models/user_model.dart';
import 'package:firebase_demo_t/screen/getx_with_localScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetxLocalDatabaseScreen extends StatelessWidget {
  GetxLocalDatabaseScreen({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Offline-Online Sync"),
          backgroundColor: Colors.blue,
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
                onPressed: () async {
                  //firebase add data
                  final userModel = UserModel(
                      name: nameController.text.trim(),
                      email: emailController.text.trim());
                  await FirestoreDb.addUser(userModel);

                  nameController.clear();
                  emailController.clear();

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => GetxWithLocalScreen(),
                  //     ));
                  Get.to(GetxWithLocalScreen());
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ));
  }
}
