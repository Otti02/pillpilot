import 'package:go_router/go_router.dart';

import 'pages/main_screen.dart';
import 'views/home/home_view.dart';
import 'pages/medications_page.dart';
import 'pages/lexicon_page.dart';
import 'pages/calendar_page.dart';
import 'pages/widgets_overview_page.dart';
import 'pages/widget_detail_pages/widget_detail_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

class AppRoute {
  static const home = '/';
  static const medications = '/medications';
  static const lexicon = '/lexicon';
  static const calendar = '/calendar';
  static const widgets = '/widgets';
  static const widgetDetail = '/widget_detail';
  static const login = '/login';
  static const register = '/register';

  AppRoute._();
}

class AppRouter {
  static final AppRouter _instance = AppRouter._();
  static AppRouter get instance => _instance;

  AppRouter._();

   final router = GoRouter(
    initialLocation: AppRoute.home,
    routes: [
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

      GoRoute(
        path: AppRoute.widgets,
        builder: (context, state) => const WidgetsOverviewPage(),
      ),
      GoRoute(
        path: '${AppRoute.widgetDetail}/:id',
        builder: (context, state) {
          // Using the id parameter from the path
          // final id = state.pathParameters['id'];
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
  void goToHome() => router.go(AppRoute.home);
  void goToMedications() => router.go(AppRoute.medications);
  void goToLexicon() => router.go(AppRoute.lexicon);
  void goToCalendar() => router.go(AppRoute.calendar);
  void goToWidgets() => router.go(AppRoute.widgets);
  void goToLogin() => router.go(AppRoute.login);
  void goToRegister() => router.go(AppRoute.register);

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
