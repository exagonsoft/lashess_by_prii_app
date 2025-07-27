import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn signIn = GoogleSignIn();

  // Sign in with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Register with Email & Password
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? _account = await signIn.signIn();
      if (_account == null) {
        return null;
      }
      final GoogleSignInAuthentication _googleAuth =
          await _account.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: _googleAuth.accessToken, idToken: _googleAuth.idToken);
      var _user = await FirebaseAuth.instance.signInWithCredential(credential);
      if (_user.user == null) {
        return null;
      }

      return _user.user;
    } catch (e) {
      debugPrint("❌ Google Sign-In failed: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await signIn.signOut();
    await _auth.signOut();
  }
}
