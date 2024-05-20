import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo_t/models/user_model.dart';

class FirestoreDb {
  //add data
  static addUser(UserModel userModel) async {
    await FirebaseFirestore.instance.collection('users').add({
      'name': userModel.name,
      'email': userModel.email,
    });
  }

  //stream builder nu work karse aa function.
  static Stream<List<UserModel>> userStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModel> users = [];
      for (var user in query.docs) {
        final userModel =
            UserModel.fromDocumentSnapshot(documentSnapshot: user);
        users.add(userModel);
      }
      return users;
    });
  }

  //update data
  static updateUser(String name, String email, String documentId) {
    FirebaseFirestore.instance.collection('users').doc(documentId).update({
      'name': name,
      'email': email,
    });
  }

  //delete data
  static deleteUser(String documentId) {
    FirebaseFirestore.instance.collection('users').doc(documentId).delete();
  }
}
