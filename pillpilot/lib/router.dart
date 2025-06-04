import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/Login.dart';
import 'pages/Register.dart';
import 'pages/main_screen.dart';
import 'pages/home_page.dart';
import 'pages/medications_page.dart';
import 'pages/diary_page.dart';
import 'pages/calendar_page.dart';
import 'pages/widgets_overview_page.dart';
import 'pages/widget_detail_pages/widget_detail_page.dart';

class AppRoute {
  static const login = '/';
  static const register = '/register';
  static const home = '/home';
  static const medications = '/medications';
  static const diary = '/diary';
  static const calendar = '/calendar';
  static const widgets = '/widgets';
  static const widgetDetail = '/widget_detail';

  AppRoute._();
}

class AppRouter {
  static final AppRouter _instance = AppRouter._();
  static AppRouter get instance => _instance;

  AppRouter._();

   final router = GoRouter(
    initialLocation: AppRoute.login,
    routes: [
      // Auth routes
      GoRoute(
        path: AppRoute.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoute.register,
        builder: (context, state) => const RegisterPage(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          final location = state.uri.path;
          int currentIndex = 0;

          if (location.startsWith(AppRoute.home)) {
            currentIndex = 0;
          } else if (location.startsWith(AppRoute.medications)) {
            currentIndex = 1;
          } else if (location.startsWith(AppRoute.diary)) {
            currentIndex = 2;
          } else if (location.startsWith(AppRoute.calendar)) {
            currentIndex = 3;
          }

          return MainScreen(
            currentIndex: currentIndex,
            child: child,
          );
        },
        routes: [
          // Tab routes
          GoRoute(
            path: AppRoute.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoute.medications,
            builder: (context, state) => const MedicationsPage(),
          ),
          GoRoute(
            path: AppRoute.diary,
            builder: (context, state) => const DiaryPage(),
          ),
          GoRoute(
            path: AppRoute.calendar,
            builder: (context, state) => const CalendarPage(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoute.widgets,
        builder: (context, state) => const WidgetsOverviewPage(),
      ),
      GoRoute(
        path: '${AppRoute.widgetDetail}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          final arguments = state.extra as Map<String, dynamic>?;
          final title = arguments?['title'] as String? ?? 'Widget Detail';
          final examples = arguments?['examples'] as List<Map<String, dynamic>>? ?? [];

          return WidgetDetailPage(
            title: title,
            examples: examples,
          );
        },
      ),
    ],
  );

  // Navigation methods
  void goToLogin() => router.go(AppRoute.login);
  void goToRegister() => router.go(AppRoute.register);
  void goToHome() => router.go(AppRoute.home);
  void goToMedications() => router.go(AppRoute.medications);
  void goToDiary() => router.go(AppRoute.diary);
  void goToCalendar() => router.go(AppRoute.calendar);
  void goToWidgets() => router.go(AppRoute.widgets);

  void goToWidgetDetail({
    required String id,
    required String title,
    required List<Map<String, dynamic>> examples,
  }) {
    router.go(
      '${AppRoute.widgetDetail}/$id',
      extra: {
        'title': title,
        'examples': examples,
      },
    );
  }

  void goToTab(int index) {
    switch (index) {
      case 0:
        goToHome();
        break;
      case 1:
        goToMedications();
        break;
      case 2:
        goToDiary();
        break;
      case 3:
        goToCalendar();
        break;
      default:
        goToHome();
    }
  }
}
