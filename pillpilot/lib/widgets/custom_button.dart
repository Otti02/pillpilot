import 'package:flutter/material.dart';
import '../theme/app_theme.dart'; // Stelle sicher, dass der Pfad zu deinem Theme korrekt ist

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading;
  final Color? color; // Optional: für spezielle Farben wie Rot beim Löschen

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle elevatedStyle = ElevatedButton.styleFrom(
      backgroundColor: color ?? AppTheme.primaryColor,
      foregroundColor: Colors.white,
      minimumSize: const Size(88, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
    );

    final ButtonStyle outlinedStyle = OutlinedButton.styleFrom(
      foregroundColor: color ?? AppTheme.primaryColor,
      minimumSize: const Size(88, 48),
      side: BorderSide(color: color ?? AppTheme.primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );

    if (isLoading) {
      return SizedBox(
        height: 48,
        child: ElevatedButton(
          style: elevatedStyle,
          onPressed: null,
          child: const CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return isOutlined
        ? OutlinedButton(
      onPressed: onPressed,
      style: outlinedStyle,
      child: Text(text),
    )
        : ElevatedButton(
      onPressed: onPressed,
      style: elevatedStyle,
      child: Text(text),
    );
  }
}
