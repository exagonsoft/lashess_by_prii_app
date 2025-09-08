import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService();
  late final Stream<User?> _authStateChanges;

  UserProvider() {
    // Firebase automatically persists sessions
    _authStateChanges = FirebaseAuth.instance.authStateChanges();
    _authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });

    // Initialize current user (useful if app starts already logged in)
    _user = FirebaseAuth.instance.currentUser;
  }

  User? get user => _user;

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
    notifyListeners();
  }
}
