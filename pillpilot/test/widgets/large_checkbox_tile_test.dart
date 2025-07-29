import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pillpilot/widgets/large_checkbox_tile.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('LargeCheckboxListTile', () {
    testWidgets('renders correctly with given title', (WidgetTester tester) async {
      // ARRANGE
      const title = 'Test Checkbox';
      await tester.pumpWidget(makeTestableWidget(
        LargeCheckboxListTile(
          title: title,
          value: false,
          onChanged: (_) {},
        ),
      ));

      // ASSERT
      expect(find.text(title), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('checkbox shows correct state when value is true', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(makeTestableWidget(
        LargeCheckboxListTile(
          title: 'Test Checkbox',
          value: true,
          onChanged: (_) {},
        ),
      ));

      // ASSERT
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('checkbox shows correct state when value is false', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(makeTestableWidget(
        LargeCheckboxListTile(
          title: 'Test Checkbox',
          value: false,
          onChanged: (_) {},
        ),
      ));

      // ASSERT
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('calls onChanged when checkbox is tapped', (WidgetTester tester) async {
      // ARRANGE
      bool? newValue;
      await tester.pumpWidget(makeTestableWidget(
        LargeCheckboxListTile(
          title: 'Test Checkbox',
          value: false,
          onChanged: (value) {
            newValue = value;
          },
        ),
      ));

      // ACT
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // ASSERT
      expect(newValue, isTrue);
    });

    testWidgets('calls onChanged when row is tapped', (WidgetTester tester) async {
      // ARRANGE
      bool? newValue;
      await tester.pumpWidget(makeTestableWidget(
        LargeCheckboxListTile(
          title: 'Test Checkbox',
          value: false,
          onChanged: (value) {
            newValue = value;
          },
        ),
      ));

      // ACT
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // ASSERT
      expect(newValue, isTrue);
    });

    testWidgets('applies correct scale to checkbox', (WidgetTester tester) async {
      // ARRANGE
      const double testScale = 2.0;
      await tester.pumpWidget(makeTestableWidget(
        LargeCheckboxListTile(
          title: 'Test Checkbox',
          value: false,
          onChanged: (_) {},
          scale: testScale,
        ),
      ));

      // ASSERT
      final transformFinder = find.ancestor(
        of: find.byType(Checkbox),
        matching: find.byType(Transform),
      );
      expect(transformFinder, findsOneWidget);

      final transformWidget = tester.widget<Transform>(transformFinder);
      final scale = transformWidget.transform.getMaxScaleOnAxis();
      expect(scale, testScale);
    });
  });
}
