import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pillpilot/widgets/appointment_item.dart';
import 'package:pillpilot/models/appointment_model.dart';

void main() {
  final testAppointment = Appointment(
    id: '1',
    title: 'Doctor Visit',
    date: DateTime(2024, 6, 1),
    time: const TimeOfDay(hour: 14, minute: 30),
    notes: 'Bring documents',
  );

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('AppointmentItem', () {
    final testAppointment = Appointment(
      id: '1',
      title: 'Doctor Visit',
      date: DateTime(2024, 6, 1),
      time: const TimeOfDay(hour: 14, minute: 30),
      notes: 'Bring documents',
    );
    final testAppointmentNoNotes = Appointment(
      id: '2',
      title: 'Dentist',
      date: DateTime(2024, 7, 1),
      time: const TimeOfDay(hour: 9, minute: 0),
    );

    testWidgets('renders appointment details correctly', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(
        AppointmentItem(appointment: testAppointment),
      ));
      expect(find.text('Doctor Visit'), findsOneWidget);
      expect(find.byIcon(Icons.event_available), findsOneWidget);
      expect(find.text('2:30 PM'), findsOneWidget);
    });

    testWidgets('renders appointment without notes', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(
        AppointmentItem(appointment: testAppointmentNoNotes),
      ));
      expect(find.text('Dentist'), findsOneWidget);
      expect(find.text('9:00 AM'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(makeTestableWidget(
        AppointmentItem(
          appointment: testAppointment,
          onTap: () { tapped = true; },
        ),
      ));
      await tester.tap(find.byType(ListTile));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('does not fail if onTap is null', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(
        AppointmentItem(appointment: testAppointment),
      ));
      await tester.tap(find.byType(ListTile));
      await tester.pump();
      // No exception should be thrown
    });
  });
} 