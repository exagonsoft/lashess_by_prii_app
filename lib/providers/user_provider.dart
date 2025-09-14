import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _fcmToken;

  final AuthService _authService = AuthService();
  late final Stream<User?> _authStateChanges;

  UserProvider() {
    // Firebase persists sessions automatically
    _authStateChanges = FirebaseAuth.instance.authStateChanges();
    _authStateChanges.listen((user) async {
      _user = user;
      notifyListeners();

      if (_user != null) {
        await _initFcmToken(); // ✅ fetch & sync token when user logs in
      } else {
        _fcmToken = null;
      }
    });

    // Initialize current user (useful if app starts already logged in)
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      _initFcmToken();
    }
  }

  User? get user => _user;
  String? get fcmToken => _fcmToken;

  /// 🔔 Setup FCM token and sync it with Firestore
  Future<void> _initFcmToken() async {
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken();
      if (_fcmToken != null && _user != null) {
        print("📲 User FCM Token: $_fcmToken");
        await _saveTokenToFirestore(_user!.uid, _fcmToken!);

        // ✅ Subscribe this device to "offers" topic
        await FirebaseMessaging.instance.subscribeToTopic("offers");

        // Listen for token refresh
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
          _fcmToken = newToken;
          print("♻️ Refreshed FCM Token: $_fcmToken");
          await _saveTokenToFirestore(_user!.uid, newToken);

          // re-subscribe just in case
          await FirebaseMessaging.instance.subscribeToTopic("offers");
          notifyListeners();
        });
      }
      notifyListeners();
    } catch (e) {
      print("⚠️ Failed to init FCM token: $e");
    }
  }

  /// ✅ Save token in Firestore (users/{uid}.fcmTokens[])
  Future<void> _saveTokenToFirestore(String uid, String token) async {
    final userDoc = FirebaseFirestore.instance.collection("users").doc(uid);

    await userDoc.set({
      "fcmTokens": FieldValue.arrayUnion([token]),
    }, SetOptions(merge: true));
  }

  // Force reload user from Firebase
  Future<void> reloadUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _fcmToken = null;
    notifyListeners();
  }
}
