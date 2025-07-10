import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/locale_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;

  void _authenticate() async {
    final authService = AuthService();
    final user = isLogin
        ? await authService.signInWithEmail(
            _emailController.text, _passwordController.text)
        : await authService.registerWithEmail(
            _emailController.text, _passwordController.text);
    if (user != null) context.go('/home');
  }

  void _signInWithGoogle() async {
    try {
      setState(() => isLogin = true);
      final authService = AuthService();
      final user = await authService.signInWithGoogle();

      if (user != null) {
        context.go('/home');
      } else {
        _showToast(AppLocalizations.of(context)!.googleSignInCancelled);
      }
      setState(() => isLogin = false);
    } catch (e) {
      setState(() => isLogin = false);
      _showToast(AppLocalizations.of(context)!.googleSignInError);
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.07;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.15),
              Text(
                isLogin ? t.welcome : t.createAccount,
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: screenWidth * 0.07,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.authSubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: screenHeight * 0.04),
              _buildTextField(
                label: t.email,
                icon: Icons.email,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: t.password,
                icon: Icons.lock,
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              _buildMainButton(
                text: isLogin ? t.login : t.register,
                onPressed: _authenticate,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(
                  isLogin ? t.createAccount : t.alreadyHaveAccount,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(t.or, style: theme.textTheme.bodyMedium),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
              ),
              _buildMainButton(
                text: t.loginWithGoogle,
                onPressed: _signInWithGoogle,
                icon: Icons.login,
                color: Colors.red.shade600,
              ),
              SizedBox(height: screenHeight * 0.05),
              DropdownButton<Locale>(
                value:
                    context.read<LocaleProvider>().locale ?? const Locale('es'),
                onChanged: (locale) {
                  if (locale != null) {
                    context.read<LocaleProvider>().setLocale(locale);
                  }
                },
                dropdownColor: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                items: const [
                  DropdownMenuItem(
                    value: Locale('es'),
                    child: Text("Español"),
                  ),
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Text("English"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: Colors.white),
              label: Text(
                text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color ?? Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color ?? Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
