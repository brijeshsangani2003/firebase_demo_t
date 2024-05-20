import 'package:firebase_demo_t/constants/firebase_constants.dart';
import 'package:firebase_demo_t/getx_controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetxWithLocalScreen extends StatelessWidget {
  GetxWithLocalScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'FireStore Data',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetX<UserController>(
                init: Get.put<UserController>(UserController()),
                builder: (UserController userController) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: userController.users.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Name:-',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                Text(userController.users[index].name
                                    .toString()),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Email:-',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                Text(userController.users[index].email
                                    .toString()),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      // nameController.text(update ni value apne ama store karavi chvi.
                                      // etle apni juni valu joti che to ji pela apne get karavi ti ema apne aa value store karavi didhi etle click karsu etle juni value avse.)
                                      nameController.text = userController
                                          .users[index].name
                                          .toString();
                                      emailController.text = userController
                                          .users[index].email
                                          .toString();

                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 30),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Update Users',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17),
                                                ),
                                                const SizedBox(height: 20),
                                                TextFormField(
                                                  controller: nameController,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'Name'),
                                                ),
                                                const SizedBox(height: 20),
                                                TextFormField(
                                                  controller: emailController,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'Email'),
                                                ),
                                                const SizedBox(height: 35),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        FirestoreDb.updateUser(
                                                          nameController.text,
                                                          emailController.text,
                                                          userController
                                                                  .users[index]
                                                                  .documentId ??
                                                              '',
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        'Update',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 17),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit)),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Are you sure?'),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      FirestoreDb.deleteUser(
                                                          userController
                                                                  .users[index]
                                                                  .documentId ??
                                                              '');
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.delete),
                                )
                              ],
                            ),
                            const Divider(thickness: 2),
                          ],
                        );
                      },
                    ),
                  );
                })
          ],
        ));
  }
}
