import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading;
  final Color? color;

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
      minimumSize: Size(MediaQuery.of(context).size.width * 0.25, MediaQuery.of(context).size.height * 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
    );

    final ButtonStyle outlinedStyle = OutlinedButton.styleFrom(
      foregroundColor: color ?? AppTheme.primaryColor,
      minimumSize: Size(MediaQuery.of(context).size.width * 0.25, MediaQuery.of(context).size.height * 0.06),
      side: BorderSide(color: color ?? AppTheme.primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );

    if (isLoading) {
      return FractionallySizedBox(
        widthFactor: 0.25,
        heightFactor: 0.06,
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
