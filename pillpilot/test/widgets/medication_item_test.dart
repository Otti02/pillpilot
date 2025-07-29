import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pillpilot/models/medication_model.dart';
import 'package:pillpilot/widgets/medication_item.dart';

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
    return MaterialApp(
      home: Scaffold(
        body: child,
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
  });
}
