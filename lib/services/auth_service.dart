import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

const String? _kServerClientId =
    "302024968063-9sqqlsb1m31fubmjto1g0sov32g3f6jh.apps.googleusercontent.com";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn signIn = GoogleSignIn.instance;
  static bool isInitialize = false;

  /// Mirrors the sample: initialize + listen to authenticationEvents + attempt lightweight auth.
  Future<void> initSignIn() async {
    if (!isInitialize) {
      await signIn.initialize(serverClientId: _kServerClientId);
    }
    isInitialize = true;
    debugPrint(
      '[GoogleAuthService] initialized. serverClientId=$_kServerClientId',
    );
  }

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
      initSignIn();
      final GoogleSignInAccount googleUser = await signIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);

      final accessToken = authorization?.accessToken;
      if (accessToken == null) {
        final GoogleSignInClientAuthorization? authorization2 =
            authorizationClient.authorizationForScopes(['email', 'profile'])
                as GoogleSignInClientAuthorization?;
        if (authorization2?.accessToken == null) {
          throw FirebaseAuthException(
            code: 'google_sign_in',
            message: 'No access token obtained from Google Sign-In.',
          );
        }
        authorization = authorization2;
      }

      final credentials = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credentials,
      );
      final User? user = userCredential.user;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          await userDoc.set({
            'uuid': user.uid,
            'email': user.email ?? '',
            'name': user.displayName ?? '',
            'photoUrl': user.photoURL ?? '',
            'createdAt': FieldValue.serverTimestamp(),
            'provider': 'google',
          });
        }
        // ✅ Print nicely
        debugPrint('Signed in as: ${user.displayName} (${user.email})');
        debugPrint('Firestore user doc: ${(await userDoc.get()).data()}');
        return user;
      }
      return null;
    } on GoogleSignInException catch (e, st) {
      debugPrint(
        '[GoogleAuthService] GoogleSignInException ${e.code}: ${e.description}',
      );
      debugPrint('[GoogleAuthService] $st');

      // Optional recovery for “Account reauth failed.” (code 16 via canceled)
      final isReauth16 =
          e.code == GoogleSignInExceptionCode.canceled &&
          (e.description?.contains('Account reauth failed') ?? false);
      if (isReauth16) {
        try {
          await signIn.disconnect();
        } catch (_) {}
        try {
          await signIn.signOut();
        } catch (_) {}
        try {
          final GoogleSignInAccount? user = await signIn.authenticate();
          if (user == null) return null;
        } catch (e2, st2) {
          debugPrint('[GoogleAuthService] Recovery failed: $e2');
          debugPrint('[GoogleAuthService] $st2');
        }
      }

      return null;
    } catch (e, st) {
      debugPrint('[GoogleAuthService] Unexpected sign-in error: $e');
      debugPrint('[GoogleAuthService] $st');
      return null;
    }
  }

  Future<void> signOut() async {
    await signIn.signOut();
    await _auth.signOut();
  }
}
