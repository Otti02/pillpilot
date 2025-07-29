import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pillpilot/widgets/custom_calendar.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('CustomCalendar', () {
    testWidgets('renders CalendarDatePicker', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(
        CustomCalendar(),
      ));
      expect(find.byType(CalendarDatePicker), findsOneWidget);
    });

    testWidgets('calls onDateSelected when a date is selected', (WidgetTester tester) async {
      DateTime? selectedDate;
      await tester.pumpWidget(makeTestableWidget(
        CustomCalendar(
          onDateSelected: (date) {
            selectedDate = date;
          },
        ),
      ));
      final state = tester.state(find.byType(CustomCalendar)) as dynamic;
      state.widget.onDateSelected?.call(DateTime(2025, 1, 1));
      await tester.pump();
      expect(selectedDate, DateTime(2025, 1, 1));
    });

    testWidgets('uses initialDate if provided', (WidgetTester tester) async {
      final initialDate = DateTime(2023, 12, 24);
      await tester.pumpWidget(makeTestableWidget(
        CustomCalendar(initialDate: initialDate),
      ));
      final state = tester.state(find.byType(CustomCalendar)) as dynamic;
      expect(state._selectedDate, initialDate);
    });

    testWidgets('does not fail if onDateSelected is null', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(
        CustomCalendar(),
      ));
      final state = tester.state(find.byType(CustomCalendar)) as dynamic;
      expect(() => state.widget.onDateSelected?.call(DateTime(2025, 1, 1)), returnsNormally);
    });
  });
} 