import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService();

  User? get user => _user;

  // Fetch the current user
  Future<void> loadUser() async {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  // Sign out the user
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
