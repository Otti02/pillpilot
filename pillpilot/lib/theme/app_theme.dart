import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color backgroundColor = Color(0xFFFFFBFE);
  static const Color cardBackgroundColor = Colors.white;

  // Dark mode colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardBackgroundColor = Color(0xFF2A2A2A);
  static const Color darkPrimaryTextColor = Colors.white;
  static const Color darkSecondaryTextColor = Color(0xFFB3B3B3);
  static const Color darkBorderColor = Color(0xFF3A3A3A);

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

  // Design constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double iconCircleSize = 48.0;
  static const double iconFontSize = 20.0;
  static const double sectionTitleFontSize = 18.0;
  static const double mainTitleFontSize = 24.0;
  static const double subtitleFontSize = 16.0;
  static const double smallFontSize = 14.0;
  static const double blurRadius = 4.0;
  static const double spreadRadius = 1.0;
  static const Offset defaultShadowOffset = Offset(0, 2);
  static const int daysInWeek = 7;
  static const int snackBarDuration = 2;

  static const Color white = Colors.white;
  static const Color red = Colors.red;
  static const Color transparent = Colors.transparent;

  static const Map<int, String> weekdays = {
    1: 'Mo',
    2: 'Di',
    3: 'Mi',
    4: 'Do',
    5: 'Fr',
    6: 'Sa',
    7: 'So',
  };

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
    cardTheme: CardThemeData(
      color: cardBackgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    dialogTheme: DialogTheme(
      backgroundColor: cardBackgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  );

  static ThemeData get darkThemeData => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: primaryColor,
      error: errorColor,
      background: darkBackgroundColor,
      surface: darkCardBackgroundColor,
    ),
    useMaterial3: true,

    // Text theme
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkPrimaryTextColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkPrimaryTextColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: darkPrimaryTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: darkSecondaryTextColor,
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorderColor),
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
      unselectedItemColor: darkSecondaryTextColor,
      type: BottomNavigationBarType.fixed,
    ),

    // Card theme
    cardTheme: CardThemeData(
      color: darkCardBackgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    dialogTheme: DialogTheme(
      backgroundColor: darkCardBackgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  );
}

// Simple theme provider
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get theme => _isDarkMode ? AppTheme.darkThemeData : AppTheme.themeData;

  // Helper methods to get colors based on current theme
  Color get backgroundColor => _isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor;
  Color get cardBackgroundColor => _isDarkMode ? AppTheme.darkCardBackgroundColor : AppTheme.cardBackgroundColor;
  Color get primaryTextColor => _isDarkMode ? AppTheme.darkPrimaryTextColor : AppTheme.primaryTextColor;
  Color get secondaryTextColor => _isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor;
  Color get borderColor => _isDarkMode ? AppTheme.darkBorderColor : AppTheme.borderColor;
}
