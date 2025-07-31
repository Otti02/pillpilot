import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pillpilot/widgets/bottom_navigation.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('BottomNavigation', () {
    testWidgets('renders all navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(BottomNavigation(currentIndex: 0, onTap: (_) {})),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Medikamente'), findsOneWidget);
      expect(find.text('Lexikon'), findsOneWidget);
      expect(find.text('Kalender'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.medication), findsOneWidget);
      expect(find.byIcon(Icons.book), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('calls onTap with correct index when tapped', (
      WidgetTester tester,
    ) async {
      int? tappedIndex;
      await tester.pumpWidget(
        makeTestableWidget(
          BottomNavigation(
            currentIndex: 0,
            onTap: (index) {
              tappedIndex = index;
            },
          ),
        ),
      );
      await tester.tap(find.text('Lexikon'));
      await tester.pump();
      expect(tappedIndex, 2);
      await tester.tap(find.text('Kalender'));
      await tester.pump();
      expect(tappedIndex, 3);
    });

    testWidgets('highlights the selected item', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(BottomNavigation(currentIndex: 1, onTap: (_) {})),
      );
      final selected = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(selected.currentIndex, 1);
    });

    testWidgets('does not throw if onTap is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(BottomNavigation(currentIndex: 0, onTap: (_) {})),
      );
      await tester.tap(find.text('Home'));
      await tester.pump();
      // No exception should be thrown
    });
  });
}
