import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences._();
  static final Preferences _instance = Preferences._();
  static SharedPreferences? _shared;

  final String _email = 'email';
  final String _isGoogleSignedIn = 'isGoogleSignedIn'; // New boolean flag

  static Future<void> init() async {
    _shared = await SharedPreferences.getInstance();
  }

  set email(String? value) {
    if (value == null) return;
    _shared?.setString(_email, value);
  }

  String? get email => _shared?.getString(_email);

  set isGoogleSignedIn(bool value) =>
      _shared?.setBool(_isGoogleSignedIn, value); // Setter for the boolean flag

  bool get isGoogleSignedIn =>
      _shared?.getBool(_isGoogleSignedIn) ??
      false; // Getter for the boolean flag

  String remove(String key) => _email;

  static Preferences get instance => _instance;
}

Preferences preferences = Preferences.instance;
