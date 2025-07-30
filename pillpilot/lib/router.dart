import 'package:go_router/go_router.dart';

import 'pages/splash_screen.dart';
import 'pages/main_screen.dart';
import 'pages/home_page.dart';
import 'pages/medications_page.dart';
import 'pages/lexicon_page.dart';
import 'pages/calendar_page.dart';

class AppRoute {
  static const splash = '/';
  static const home = '/home';
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

  // Tab indices as constants to avoid magic numbers
  static const int _homeIndex = 0;
  static const int _medicationsIndex = 1;
  static const int _lexiconIndex = 2;
  static const int _calendarIndex = 3;

  // Route to index mapping
  static const Map<String, int> _routeToIndex = {
    AppRoute.home: _homeIndex,
    AppRoute.medications: _medicationsIndex,
    AppRoute.lexicon: _lexiconIndex,
    AppRoute.calendar: _calendarIndex,
  };

  final router = GoRouter(
    initialLocation: AppRoute.splash,
    routes: [
      // Splash screen route
      GoRoute(
        path: AppRoute.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // Main app shell route
      ShellRoute(
        builder: (context, state, child) {
          final location = state.uri.path;
          final currentIndex = _routeToIndex[location] ?? _homeIndex;

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

  // Generic navigation method to replace redundant methods
  void navigateTo(String route) => router.go(route);

  // Keep specific methods for backward compatibility but implement them generically
  void goToHome() => navigateTo(AppRoute.home);
  void goToMedications() => navigateTo(AppRoute.medications);
  void goToLexicon() => navigateTo(AppRoute.lexicon);
  void goToCalendar() => navigateTo(AppRoute.calendar);
  void goToWidgets() => navigateTo(AppRoute.widgets);

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
    // Find route by index
    final route = _routeToIndex.entries
        .firstWhere(
          (entry) => entry.value == index,
          orElse: () => MapEntry(AppRoute.home, _homeIndex),
        )
        .key;
    
    navigateTo(route);
  }
}
