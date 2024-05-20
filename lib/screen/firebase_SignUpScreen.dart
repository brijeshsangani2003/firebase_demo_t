import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_demo_t/common_widget/common_textfield.dart';
import 'package:firebase_demo_t/screen/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import 'network_error_screen.dart';

class FirebaseSignUpScreen extends StatefulWidget {
  const FirebaseSignUpScreen({super.key});

  @override
  State<FirebaseSignUpScreen> createState() => _FirebaseSignUpScreenState();
}

class _FirebaseSignUpScreenState extends State<FirebaseSignUpScreen> {
  final formKey = GlobalKey<FormState>();

  DateFormat dateFormat = DateFormat("dd-MM-YYYY");

  final dateOfBirth = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? selectedimage;

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      if (image != null) {
        selectedimage = File(image.path);
      } else {
        //print('No image selected.');
      }
    });
  }

  ///firebase mate
  // Future uploadImageToFirebase() async {
  //   await FirebaseStorage.instance
  //       .ref('/user-image.jpg')
  //       .putFile(selectedimage!);
  //
  //   final url =
  //       await FirebaseStorage.instance.ref('/user-image.jpg').getDownloadURL();
  //   return url;
  // }
  Future uploadImageToFirebase() async {
    if (selectedimage != null) {
      await FirebaseStorage.instance
          .ref('/user-image.jpg')
          .putFile(selectedimage!);
      final url = await FirebaseStorage.instance
          .ref('/user-image.jpg')
          .getDownloadURL();
      return url;
    } else {
      // Handle the case where selectedimage is null
      return null;
    }
  }

  late StreamSubscription<ConnectivityResult> subscription;

  bool isDeviceConnected = true; //net chalu hoy tyre
  bool isScreenSet = false; //error screen mate

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen(_updateConnectivityStatus); // Monitor connectivity
  }

  @override
  void dispose() {
    subscription.cancel(); // Clean up subscription
    super.dispose();
  }

  //InternetConnectionChecker().hasConnection; aa bool return kare etle ene isDeviceConnected ma store kari didhu
  //isDeviceConnected ne  bool wasConnected ma store karu.
  void _updateConnectivityStatus(ConnectivityResult result) async {
    bool wasConnected = isDeviceConnected;
    isDeviceConnected = await InternetConnectionChecker().hasConnection;

    //isDeviceConnected pela true che ene false karu
    // && wasConnected check kare che network sharu che k bandh
    // &&  bool isScreenSet pela false hatu ene true karu jo aa hoy to networkErrorScreen call thase.
    //niker amaj undhi condition
    if (!isDeviceConnected && wasConnected && !isScreenSet) {
      _navigateToNetworkErrorScreen(); // Navigate to network error screen
    } else if (isDeviceConnected && !wasConnected && isScreenSet) {
      Navigator.of(context).pop(); // Return to the previous screen
      isScreenSet = false; // Reset flag
    }
  }

  void _navigateToNetworkErrorScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const NetworkErrorScreen(),
    ));
    isScreenSet = true; // Set flag to avoid multiple navigation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  InkResponse(
                    onTap: () async {
                      getImage(ImageSource.gallery);
                    },
                    child: ClipOval(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: const BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                        child: selectedimage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                              )
                            : Image.file(selectedimage!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  common_text_field(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'First Name can not be empty';
                      } else if (value.contains(' ')) {
                        return 'First name cannot contains spaces';
                      }
                    },
                    hinttext: 'Name:',
                    controller: name,
                  ),
                  const SizedBox(
                    height: 20,
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
                  const SizedBox(
                    height: 20,
                  ),
                  common_text_field(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Birth Of Date can not be empty';
                      }
                    },
                    onTap: () async {
                      var pickedDate = await DatePicker.showSimpleDatePicker(
                        context,
                        initialDate: DateTime(1994),
                        firstDate: DateTime(1960),
                        lastDate: DateTime(2012),
                        dateFormat: "dd-MMMM-yyyy",
                        locale: DateTimePickerLocale.en_us,
                        looping: true,
                      );
                      if (pickedDate != null) {
                        dateOfBirth.text =
                            DateFormat('dd/MMMM/yyyy').format(pickedDate);
                      }
                    },
                    controller: dateOfBirth,
                    hinttext: 'Date Of Birth:',
                  ),
                  const SizedBox(height: 50),
                  MaterialButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final imageurl = await uploadImageToFirebase();
                        // print('imageurl =======> $imageurl');
                        FirebaseFirestore.instance.collection('user').add({
                          'user_pic': imageurl,
                          'name': name.text,
                          'email': email.text,
                          'date of birth': dateOfBirth.text,
                        }).then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            )));

                        // print('${name.text}');
                      }
                    },
                    color: Colors.orangeAccent,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
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
