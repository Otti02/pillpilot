import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../router.dart';

class MainScreen extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const MainScreen({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  void _onTabTapped(int index) {
    AppRouter.instance.goToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
