import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: isLight ? AppColors.lightInputFill : AppColors.darkInputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffix,
      ),
    );
  }
}
