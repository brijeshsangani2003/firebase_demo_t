import 'package:firebase_auth/firebase_auth.dart';

class FirebaseEmailAuthServices {
  static Future signUpUser(
      {required String email, required String password}) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('ERROR ====> ${e.message}');
    }
  }

  static Future signInUser(
      {required String email, required String password}) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('ERROR ====> ${e.message}');
    }
  }

  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
