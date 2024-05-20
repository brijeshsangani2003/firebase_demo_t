import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_demo_t/local_databse_offline_online/local_database.dart';
import 'package:firebase_demo_t/models/user_model.dart';
import 'package:get/get.dart';

import '../constants/firebase_constants.dart';

class UserController extends GetxController {
  var userList = <UserModel>[].obs;
  List<UserModel> get users => userList;

  //onReady function pela buid method call thase pachi aa function run thase.
  //jo onInit function hoy to  a thase pachi buid method ne pachi onReady function
  // userList.bindStream aa StreamBuilder jevo use kare che.
  @override
  void onReady() {
    super.onReady();
    userList.bindStream(FirestoreDb.userStream());
  }

  // LocalDatabase localDatabase = LocalDatabase();
  // var isConnected = true.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _init();
  // }
  //
  // void _init() async {
  //   // Check connectivity initially
  //   checkConnectivity();
  //
  //   // Listen for connectivity changes
  //   Connectivity().onConnectivityChanged.listen((result) {
  //     isConnected.value = result != ConnectivityResult.none;
  //   });
  //
  //   // Sync data when connectivity changes
  //   isConnected.listen((online) {
  //     if (online) {
  //       syncDataWithFirebase();
  //     } else {
  //       // addUser();
  //       print('======No internet');
  //     }
  //   });
  // }
  //
  // void checkConnectivity() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   isConnected.value = connectivityResult != ConnectivityResult.none;
  // }
  //
  // Future<void> syncDataWithFirebase() async {
  //   var users = await localDatabase.fetchUsers(); // Get local data
  //
  //   for (var user in users) {
  //     await FirebaseFirestore.instance.collection('users').add({
  //       'name': user['name'],
  //       'email': user['email'],
  //     });
  //   }
  //
  //   await localDatabase.clearUserTable(); // Clear local data after sync
  // }
  //
  // Future<void> addUser() async {
  //   // if (isConnected.value) {
  //   //   await FirestoreDb.addUser(userList as UserModel);
  //   // }
  //   await FirestoreDb.addUser(userList as UserModel);
  // }
}
