import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lashess_by_prii_app/l10n/app_localizations.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';
import 'package:lashess_by_prii_app/widgets/custom_button_input.dart';
import 'package:lashess_by_prii_app/widgets/custom_text_input.dart';
import 'package:lashess_by_prii_app/widgets/loading_overlay.dart';
import '../services/auth_service.dart';
import '../providers/user_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  void _toast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColors.darkBackground.withOpacity(0.9),
      textColor: AppColors.lightCard,
    );
  }

  Future<void> _authenticate() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final t = AppLocalizations.of(context)!;

    try {
      final auth = AuthService();
      final user = _isLogin
          ? await auth.signInWithEmail(_emailCtrl.text.trim(), _pwCtrl.text)
          : await auth.registerWithEmail(_emailCtrl.text.trim(), _pwCtrl.text);

      if (!mounted) return;

      if (user != null) {
        // ✅ store user in provider
        await context.read<UserProvider>().reloadUser();

        context.go('/home');
      } else {
        _toast("❌ ${t.authError}");
      }
    } catch (e) {
      final msg = e.toString().toLowerCase();
      String friendly = t.authError;

      if (msg.contains('wrong-password') ||
          msg.contains('invalid-credential') ||
          msg.contains('invalid-password')) {
        friendly = t.wrongCredentials;
      } else if (msg.contains('user-not-found')) {
        friendly = t.userNotFound;
      } else if (msg.contains('email-already-in-use')) {
        friendly = t.emailInUse;
      } else if (msg.contains('network') || msg.contains('socket')) {
        friendly = t.networkError;
      }

      debugPrint('❌ Auth error: $e');
      _toast('❌ $friendly');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final t = AppLocalizations.of(context)!;

    try {
      final auth = AuthService();
      final user = await auth.signInWithGoogle();

      if (!mounted) return;

      if (user != null) {
        // ✅ store user in provider
        await context.read<UserProvider>().reloadUser();

        context.go('/home');
      } else {
        _toast('⚠️ ${t.googleSignInCancelled}');
      }
    } catch (e) {
      debugPrint('❌ Google Sign-In error: $e');
      _toast('❌ ${AppLocalizations.of(context)!.googleSignInError}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor:
          isLight ? AppColors.lightBackground : AppColors.darkBackground,
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  isLight
                      ? 'assets/images/lash_logo.png'
                      : 'assets/images/lash_logo_dark.png',
                  height: 120,
                ),
                const SizedBox(height: 16),
                Text(
                  'Lashess by Prii',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isLight
                        ? AppColors.lightTextPrimary
                        : AppColors.darkTextPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // Auth Card
                Card(
                  color: isLight ? AppColors.lightCard : AppColors.darkCard,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isLogin ? t.signIn : t.createAccount,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isLight
                                  ? AppColors.lightTextPrimary
                                  : AppColors.darkTextPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            hint: t.email,
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return t.requiredField;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          CustomTextField(
                            hint: t.password,
                            controller: _pwCtrl,
                            obscureText: _obscure,
                            suffix: TextButton(
                              onPressed: () {},
                              child: Text(
                                t.forgotPassword,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isLight
                                      ? AppColors.lightPrimary
                                      : AppColors.darkPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          CustomButton(
                            text: _isLogin ? t.login : t.register,
                            onPressed: _authenticate,
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: isLight
                                      ? AppColors.lightDivider
                                      : AppColors.darkDivider,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  t.or,
                                  style: TextStyle(
                                    color: isLight
                                        ? AppColors.lightTextSecondary
                                        : AppColors.darkTextSecondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: isLight
                                      ? AppColors.lightDivider
                                      : AppColors.darkDivider,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          CustomButton(
                            text: t.loginWithGoogle,
                            onPressed: _signInWithGoogle,
                            type: ButtonType.outlined,
                            icon: Image.asset(
                              'assets/icons/google.png',
                              height: 20,
                            ),
                            isLoading: false,
                          ),
                          const SizedBox(height: 12),

                          CustomButton(
                            text: t.loginWithFacebook,
                            onPressed: _signInWithGoogle,
                            type: ButtonType.outlined,
                            icon: Image.asset(
                              'assets/icons/facebook.png',
                              height: 20,
                            ),
                            isLoading: false,
                          ),
                          const SizedBox(height: 20),

                          GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () => setState(() => _isLogin = !_isLogin),
                            child: Text(
                              _isLogin
                                  ? t.createAccount
                                  : t.alreadyHaveAccount,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isLight
                                    ? AppColors.lightPrimary
                                    : AppColors.darkPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
