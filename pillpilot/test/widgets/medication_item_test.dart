import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pillpilot/models/medication_model.dart';
import 'package:pillpilot/widgets/medication_item.dart';
import 'package:pillpilot/theme/app_theme.dart';

void main() {
  final testMedication = Medication(
    id: '1',
    name: 'Ibuprofen',
    dosage: '400mg',
    time: const TimeOfDay(hour: 10, minute: 30),
    daysOfWeek: [1, 3, 5],
    isCompleted: false,
  );

  Widget makeTestableWidget(Widget child) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  group('MedicationItem', () {
    testWidgets('renders medication details correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(makeTestableWidget(
        MedicationItem(
          medication: testMedication,
        ),
      ));

      // ASSERT
      expect(find.text('Ibuprofen'), findsOneWidget);
      expect(find.textContaining('400mg'), findsOneWidget);
      expect(find.textContaining('Mo, Mi, Fr'), findsOneWidget);

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('calls onToggle when checkbox area is tapped', (WidgetTester tester) async {
      // ARRANGE
      bool toggleCalled = false;
      await tester.pumpWidget(makeTestableWidget(
        MedicationItem(
          medication: testMedication,
          onToggle: () {
            toggleCalled = true;
          },
          onDataChanged: () {},
        ),
      ));

      // ACT
      await tester.tap(find.byType(GestureDetector).last);
      await tester.pump();

      // ASSERT
      expect(toggleCalled, isTrue);
    });

    group('Trailing Widget Tests', () {
      testWidgets('shows trailing widget when provided', (WidgetTester tester) async {
        // ARRANGE
        await tester.pumpWidget(makeTestableWidget(
          MedicationItem(
            medication: testMedication,
            trailingWidget: const Icon(Icons.delete, color: Colors.red),
          ),
        ));

        // ASSERT
        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing); // Checkbox should not be shown
      });

      testWidgets('shows checkbox when no trailing widget is provided', (WidgetTester tester) async {
        // ARRANGE
        await tester.pumpWidget(makeTestableWidget(
          MedicationItem(
            medication: testMedication,
          ),
        ));

        // ASSERT
        expect(find.byIcon(Icons.delete), findsNothing);
        // Checkbox should be shown (we can't directly test the checkbox icon, but we can test the container)
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('trailing widget is clickable', (WidgetTester tester) async {
        // ARRANGE
        bool deleteCalled = false;
        await tester.pumpWidget(makeTestableWidget(
          MedicationItem(
            medication: testMedication,
            trailingWidget: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteCalled = true;
              },
            ),
          ),
        ));

        // ACT
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pump();

        // ASSERT
        expect(deleteCalled, isTrue);
      });
    });

    group('Completed Styling Tests', () {
      final completedMedication = testMedication.copyWith(isCompleted: true);

      testWidgets('shows completed styling when medication is completed and showCompletedStyling is true', (WidgetTester tester) async {
        // ARRANGE
        await tester.pumpWidget(makeTestableWidget(
          MedicationItem(
            medication: completedMedication,
            showCompletedStyling: true,
          ),
        ));

        // ASSERT
        expect(find.byIcon(Icons.check), findsOneWidget);
        // The text should be styled with completed color (we can't directly test color, but we can verify the widget exists)
        expect(find.text('Ibuprofen'), findsOneWidget);
      });

      testWidgets('does not show completed styling when showCompletedStyling is false', (WidgetTester tester) async {
        // ARRANGE
        await tester.pumpWidget(makeTestableWidget(
          MedicationItem(
            medication: completedMedication,
            showCompletedStyling: false,
          ),
        ));

        // ASSERT
        expect(find.byIcon(Icons.check), findsNothing);
        expect(find.text('Ibuprofen'), findsOneWidget);
      });

      testWidgets('shows completed styling by default when medication is completed', (WidgetTester tester) async {
        // ARRANGE
        await tester.pumpWidget(makeTestableWidget(
          MedicationItem(
            medication: completedMedication,
            // showCompletedStyling defaults to true
          ),
        ));

        // ASSERT
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('does not show completed styling when medication is not completed', (WidgetTester tester) async {
        // ARRANGE
        await tester.pumpWidget(makeTestableWidget(
          MedicationItem(
            medication: testMedication, // isCompleted: false
            showCompletedStyling: true,
          ),
        ));

        // ASSERT
        expect(find.byIcon(Icons.check), findsNothing);
      });
    });

    group('Combined Tests', () {
      final completedMedication = testMedication.copyWith(isCompleted: true);

      testWidgets('trailing widget takes precedence over checkbox even when medication is completed', (WidgetTester tester) async {
        // ARRANGE
        await tester.pumpWidget(makeTestableWidget(
          MedicationItem(
            medication: completedMedication,
            showCompletedStyling: true,
            trailingWidget: const Icon(Icons.edit, color: Colors.blue),
          ),
        ));

        // ASSERT
        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing); // Checkbox should not be shown
      });

      testWidgets('trailing widget works correctly with showCompletedStyling false', (WidgetTester tester) async {
        // ARRANGE
        await tester.pumpWidget(makeTestableWidget(
          MedicationItem(
            medication: completedMedication,
            showCompletedStyling: false,
            trailingWidget: const Icon(Icons.delete, color: Colors.red),
          ),
        ));

        // ASSERT
        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing);
      });
    });
  });
}
