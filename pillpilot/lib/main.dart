import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/widgets_overview_page.dart';
import 'pages/widget_detail_pages/widget_detail_page.dart';
import 'pages/Login.dart';
import 'pages/Register.dart';
import 'pages/main_screen.dart';
import 'main_dummy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Pilot',
      theme: AppTheme.themeData,
      home: const LoginPage(),
      routes: {
        '/home': (context) => const MainScreen(),
        '/register': (context) => const RegisterPage(),
        '/widgets': (context) => const WidgetsOverviewPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/widget_detail/') ?? false) {
          final arguments = settings.arguments as Map<String, dynamic>?;
          final title = arguments?['title'] as String? ?? 'Widget Detail';
          final examples = arguments?['examples'] as List<Map<String, dynamic>>? ?? [];

          return MaterialPageRoute(
            builder: (context) => WidgetDetailPage(
              title: title,
              examples: examples,
            ),
          );
        }
        return null;
      },
    );
  }
}
