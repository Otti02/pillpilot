import 'package:go_router/go_router.dart';

import 'pages/main_screen.dart';
import 'pages/home_page.dart';
import 'pages/medications_page.dart';
import 'pages/lexicon_page.dart';
import 'pages/calendar_page.dart';

class AppRoute {
  static const home = '/';
  static const medications = '/medications';
  static const lexicon = '/lexicon';
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
    initialLocation: AppRoute.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final location = state.uri.path;
          int currentIndex = 0;

          if (location == AppRoute.home) {
            currentIndex = 0;
          } else if (location == AppRoute.medications) {
            currentIndex = 1;
          } else if (location == AppRoute.lexicon) {
            currentIndex = 2;
          } else if (location == AppRoute.calendar) {
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
            builder: (context, state) => const HomePage(), // Diese muss aus dem importierten File kommen
          ),
          GoRoute(
            path: AppRoute.medications,
            builder: (context, state) => const MedicationsPage(),
          ),
          GoRoute(
            path: AppRoute.lexicon,
            builder: (context, state) => const LexiconPage(),
          ),
          GoRoute(
            path: AppRoute.calendar,
            builder: (context, state) => const CalendarPage(),
          ),
        ],
      ),
    ],
  );

  // Navigation methods
  void goToHome() => router.go(AppRoute.home);
  void goToMedications() => router.go(AppRoute.medications);
  void goToLexicon() => router.go(AppRoute.lexicon);
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
        goToLexicon();
        break;
      case 3:
        goToCalendar();
        break;
      default:
        goToHome();
    }
  }
}
