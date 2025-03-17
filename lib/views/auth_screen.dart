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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.07; // Responsive horizontal padding

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.2), // Dynamic top spacing

                // Title Text
                Text(
                  isLogin ? "Bienvenido!" : "Crear Cuenta",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.07, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),

                // Subtitle
                Text(
                  "¡Únete a nosotras para la mejor experiencia de belleza!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),

                // Email Input
                _buildTextField("Email", Icons.email, _emailController),
                SizedBox(height: screenHeight * 0.02),

                // Password Input
                _buildTextField("Contraseña", Icons.lock, _passwordController,
                    obscureText: true),
                SizedBox(height: screenHeight * 0.03),

                // Login/Register Button
                _buildMainButton(isLogin ? "Acceso" : "Registro", _authenticate),
                SizedBox(height: screenHeight * 0.01),

                // Toggle between Login/Register
                TextButton(
                  onPressed: () {
                    setState(() => isLogin = !isLogin);
                  },
                  child: Text(
                    isLogin
                        ? "Crear Cuenta"
                        : "¿Ya tienes una cuenta? Iniciar sesión",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // Responsive font size
                      color: Colors.pink.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Divider
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                              thickness: 1, color: Colors.grey.shade400)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("OR",
                            style: TextStyle(color: Colors.grey.shade600)),
                      ),
                      Expanded(
                          child: Divider(
                              thickness: 1, color: Colors.grey.shade400)),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),

                // Google Sign-In Button
                _buildMainButton("Iniciar sesión con Google", _signInWithGoogle,
                    color: Colors.red.shade600),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink.shade400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildMainButton(String text, VoidCallback onPressed,
      {IconData? icon, Color? color, double? width}) {
    return icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.white),
            label: Text(
              text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: width ?? 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: color ?? Colors.pink.shade600,
              elevation: 5,
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: width ?? 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: color ?? Colors.pink.shade600,
              elevation: 5,
            ),
            child: Center(
              // Ensures label is always centered
              child: Text(
                text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
