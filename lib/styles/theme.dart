import 'package:flutter/material.dart';

class AppTheme {
  static Color mainColor = Color(0xFFF194AF); // Soft Pink
  static Color secondaryColor = Color(0xFFEDE4D4); // Beige
  static Color accentColor = Color(0xFF371B1E); // Deep Burgundy

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: mainColor,
    scaffoldBackgroundColor: secondaryColor,

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: mainColor,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: accentColor), 
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: accentColor),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87), 
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black54), 
    ),

    // Input Fields Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mainColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
      labelStyle: TextStyle(color: mainColor),
      prefixIconColor: mainColor,
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: accentColor,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: accentColor.withOpacity(0.5),
      thickness: 1,
    ),
  );
}
