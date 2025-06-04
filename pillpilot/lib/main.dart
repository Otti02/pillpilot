import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.instance.router;

    return MaterialApp.router(
      title: 'Pill Pilot',
      theme: AppTheme.themeData,
      routerConfig: router,
    );
  }
}
