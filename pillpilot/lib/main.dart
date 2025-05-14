import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/widgets_overview_page.dart';
import 'pages/widget_detail_pages/widget_detail_page.dart';
import 'main_dummy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Gallery',
      theme: AppTheme.themeData,
      home: const WidgetsOverviewPage(),
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
