import 'package:firebase_auth/firebase_auth.dart';

class LoginGoogleUtils {
  Future<bool> isUserLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}