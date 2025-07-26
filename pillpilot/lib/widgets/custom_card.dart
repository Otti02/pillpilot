import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundColor, // Weißer Hintergrund
        borderRadius: BorderRadius.circular(12), // Runde Ecken wie im Figma
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Sehr subtiler Schatten
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
