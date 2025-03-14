// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;

  void _authenticate() async {
    final authService = AuthService();
    if (isLogin) {
      final user = await authService.signInWithEmail(
          _emailController.text, _passwordController.text);
      if (user != null) context.go('/home');
    } else {
      final user = await authService.registerWithEmail(
          _emailController.text, _passwordController.text);
      if (user != null) context.go('/home');
    }
  }

  void _signInWithGoogle() async {
    try {
      print("Google Sign-In initiated...");

      final authService = AuthService();
      final user = await authService.signInWithGoogle();

      if (user != null) {
        print("Google Sign-In successful! User: ${user.displayName}");
        if (mounted) {
          context.go('/home');
        }
      } else {
        print("Google Sign-In failed or canceled.");
        _showToast("Google Sign-In was canceled or failed.");
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
      _showToast("An error occurred during Google Sign-In. Please try again.");
    }
  }

// Show Toast Message
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM, // Show at the bottom
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Text
              Text(
                isLogin ? "Welcome Back!" : "Create Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade700,
                ),
              ),
              SizedBox(height: 10),

              // Subtitle
              Text(
                "Join us for the best beauty experience!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              SizedBox(height: 30),

              // Email Input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Colors.pink.shade400),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Password Input
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock, color: Colors.pink.shade400),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Login/Register Button
              ElevatedButton(
                onPressed: _authenticate,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.pink.shade600,
                  elevation: 5,
                ),
                child: Text(
                  isLogin ? "Login" : "Register",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),

              // Toggle between Login/Register
              TextButton(
                onPressed: () {
                  setState(() => isLogin = !isLogin);
                },
                child: Text(
                  isLogin
                      ? "Create an account"
                      : "Already have an account? Login",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.pink.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Divider
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child:
                            Divider(thickness: 1, color: Colors.grey.shade400)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR",
                          style: TextStyle(color: Colors.grey.shade600)),
                    ),
                    Expanded(
                        child:
                            Divider(thickness: 1, color: Colors.grey.shade400)),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // Google Sign-In Button
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: Icon(Icons.login, color: Colors.white),
                label: Text(
                  "Sign in with Google",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.red.shade600,
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
