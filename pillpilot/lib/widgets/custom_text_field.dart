import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Text(
                label!,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: themeProvider.primaryTextColor,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ],
            TextField(
              controller: controller,
              obscureText: obscureText,
              onChanged: onChanged,
              style: TextStyle(color: themeProvider.primaryTextColor),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: themeProvider.secondaryTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: themeProvider.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: themeProvider.borderColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
