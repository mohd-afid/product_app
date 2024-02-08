
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password);
      isSuccess = true;
    } on FirebaseAuthException catch (e) {
      isSuccess = false;
      return isSuccess;
    }
    return isSuccess;
  }


// Sign up with email and password
  Future<bool> signUp(
    String email,
    String password,
  ) async {
    print("signuppp");
    bool isSuccess;
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      isSuccess = true;
      // If the createUserWithEmailAndPassword call succeeds, navigate to the next page.
    } catch (e) {
      isSuccess = false;
      // Handle any errors during sign-up.
      print(e.toString());
    }
    return isSuccess;
  }

  Future signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
