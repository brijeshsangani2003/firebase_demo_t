import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? documentId;
  late String name;
  late String email;

  UserModel({
    required this.name,
    required this.email,
  });

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    documentId = documentSnapshot.id;
    name = documentSnapshot['name'];
    email = documentSnapshot['email'];
  }
}
