import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color backgroundColor = Color(0xFFFFFBFE);
  static const Color cardBackgroundColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF1C1B1F);
  static const Color secondaryTextColor = Color(0xFF49454F);
  static const Color borderColor = Color(0xFFE7E0EC);
  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color successColor = Color(0xFF4CAF50);

  static ThemeData get themeData => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    useMaterial3: true,

    // Nur für normale Buttons (ElevatedButton)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, // Deine lila Farbe
        foregroundColor: Colors.white, // Weißer Text
      ),
    ),
  );
}
