import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_strings.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.disabledTextColor,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medication),
          label: AppStrings.medikamente,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: AppStrings.lexikon,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: AppStrings.kalender,
        ),
      ],
    );
  }
}
