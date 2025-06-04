import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color backgroundColor = Color(0xFFFFFBFE);
  static const Color cardBackgroundColor = Colors.white;

  // Text colors
  static const Color primaryTextColor = Color(0xFF1C1B1F);
  static const Color secondaryTextColor = Color(0xFF49454F);
  static const Color disabledTextColor = Colors.grey;

  // Border and divider colors
  static const Color borderColor = Color(0xFFE7E0EC);
  static const Color dividerColor = Color(0xFFE7E0EC);

  // Status colors
  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Colors.orange;

  // Icon colors
  static const Color iconColor = primaryColor;
  static const Color iconBackgroundColor = Color(0xFFEADDFF); // Light purple
  static const Color medicationIconColor = Colors.blue;
  static const Color medicationIconBackgroundColor = Color(0xFFE6F2FF); // Light blue

  // Checkbox colors
  static const Color checkboxActiveColor = successColor;
  static const Color checkboxInactiveColor = Color(0xFFCACACA); // Light grey

  // Shadow colors
  static const Color shadowColor = Color(0x1A000000); // Black with 10% opacity

  // Completed/disabled state colors
  static const Color completedTextColor = Colors.grey;
  static const Color completedColor = successColor;

  static ThemeData get themeData => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: primaryColor,
      error: errorColor,
      background: backgroundColor,
      surface: cardBackgroundColor,
    ),
    useMaterial3: true,

    // Text theme
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: primaryTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: secondaryTextColor,
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: disabledTextColor,
      type: BottomNavigationBarType.fixed,
    ),

    // Card theme
    cardTheme: CardTheme(
      color: cardBackgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
