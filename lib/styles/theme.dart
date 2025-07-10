import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.lightTextPrimary,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
      titleLarge: TextStyle(color: AppColors.lightAccent, fontSize: 20),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightAccent,
        foregroundColor: AppColors.lightTextPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightPrimary,
      selectedItemColor: AppColors.lightAccent,
      unselectedItemColor: AppColors.lightTextSecondary,
      selectedIconTheme: IconThemeData(color: AppColors.darkIconPrimary),
      unselectedIconTheme: IconThemeData(color: AppColors.darkIconSecondary),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.lightIconPrimary, // ✅ Use dark text primary
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.darkTextPrimary, // ✅ Use AppColors
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTextPrimary, // ✅
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
      titleLarge: TextStyle(color: AppColors.darkAccent, fontSize: 20),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkAccent,
        foregroundColor: AppColors.darkTextPrimary, // ✅ Use textPrimary
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkPrimary,
      selectedItemColor: AppColors.darkAccent,
      unselectedItemColor: AppColors.darkTextSecondary,
      selectedIconTheme: IconThemeData(color: AppColors.darkIconPrimary),
      unselectedIconTheme: IconThemeData(color: AppColors.darkIconSecondary),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.darkIconPrimary, // ✅ Use dark text primary
    ),
  );
}
