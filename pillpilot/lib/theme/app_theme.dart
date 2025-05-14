import 'package:flutter/material.dart';

/// Defines the app's theme based on the design specifications.
class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF4A80F0);
  static const Color secondaryColor = Color(0xFFB4C0FE);
  static const Color accentColor = Color(0xFFD0DBFF);
  
  // Background colors
  static const Color backgroundColor = Color(0xFFF9FAFF);
  static const Color cardBackgroundColor = Colors.white;
  
  // Text colors
  static const Color primaryTextColor = Color(0xFF1F1F39);
  static const Color secondaryTextColor = Color(0xFF6E7191);
  static const Color tertiaryTextColor = Color(0xFFA0A3BD);
  
  // Border colors
  static const Color borderColor = Color(0xFFEFF0F6);
  
  // Success/Error colors
  static const Color successColor = Color(0xFF4CD964);
  static const Color errorColor = Color(0xFFFF3B30);
  
  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );
  
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: secondaryTextColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: secondaryTextColor,
  );
  
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  // ThemeData for MaterialApp
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: primaryTextColor,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: headingStyle,
        titleLarge: titleStyle,
        titleMedium: subtitleStyle,
        bodyMedium: bodyStyle,
      ),
      cardTheme: CardTheme(
        color: cardBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: buttonTextStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: buttonTextStyle.copyWith(color: primaryColor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      useMaterial3: true,
    );
  }
}