import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pillpilot/widgets/edit_appointment_dialog.dart';
import 'package:pillpilot/models/appointment_model.dart';
import 'package:pillpilot/theme/app_strings.dart';
import 'package:pillpilot/theme/app_theme.dart';
import 'package:pillpilot/controllers/appointment/appointment_controller.dart';
import 'package:pillpilot/models/appointment_state_model.dart';

import 'edit_appointment_dialog_test.mocks.dart';

@GenerateMocks([AppointmentController])
void main() {
  group('EditAppointmentDialog', () {
    late MockAppointmentController mockAppointmentController;
    late Appointment testAppointment;

    setUp(() {
      mockAppointmentController = MockAppointmentController();
      testAppointment = Appointment(
        id: '1',
        title: 'Test Termin',
        date: DateTime(2024, 1, 15),
        time: const TimeOfDay(hour: 14, minute: 30),
        notes: 'Test Notizen',
      );
    });

    Widget createTestWidget({
      required Appointment appointment,
      required VoidCallback onAppointmentUpdated,
    }) {
      return ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
        child: MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AppointmentController>.value(
                value: mockAppointmentController,
              ),
            ],
            child: Scaffold(
              body: EditAppointmentDialog(
                appointment: appointment,
                onAppointmentUpdated: onAppointmentUpdated,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should display dialog title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onAppointmentUpdated: () {},
      ));

      expect(find.text(AppStrings.terminBearbeiten), findsOneWidget);
    });

    testWidgets('should pre-fill form fields with appointment data', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onAppointmentUpdated: () {},
      ));

      // Verify title field is pre-filled
      final titleField = find.byType(TextField).first;
      expect(tester.widget<TextField>(titleField).controller?.text, equals('Test Termin'));

      // Verify notes field is pre-filled
      final notesField = find.byType(TextField).last;
      expect(tester.widget<TextField>(notesField).controller?.text, equals('Test Notizen'));

      // Verify date is displayed correctly
      expect(find.text('15.01.2024'), findsOneWidget);
    });

    testWidgets('should have save and cancel buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onAppointmentUpdated: () {},
      ));

      // Verify buttons are present
      expect(find.text(AppStrings.speichern), findsOneWidget);
      expect(find.text(AppStrings.abbrechen), findsOneWidget);
    });

    testWidgets('should close dialog when cancel button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onAppointmentUpdated: () {},
      ));

      // Tap the cancel button
      final cancelButton = find.text(AppStrings.abbrechen);
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.byType(EditAppointmentDialog), findsNothing);
    });

    testWidgets('should show date picker when date field is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onAppointmentUpdated: () {},
      ));

      // Find and tap the date field
      final dateField = find.text('15.01.2024');
      await tester.tap(dateField);
      await tester.pumpAndSettle();

      // Verify date picker is shown
      expect(find.byType(CalendarDatePicker), findsOneWidget);
    });

    testWidgets('should show time picker when time field is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onAppointmentUpdated: () {},
      ));

      // Find and tap the time field by looking for the time label
      final timeField = find.textContaining('${AppStrings.uhrzeit}');
      await tester.tap(timeField, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify time picker is shown
      expect(find.byType(TimePickerDialog), findsOneWidget);
    });



    testWidgets('should have correct form field labels', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onAppointmentUpdated: () {},
      ));

      // Verify all form field labels are present
      expect(find.text(AppStrings.titel), findsOneWidget);
      expect(find.text(AppStrings.datum), findsOneWidget);
      expect(find.text(AppStrings.uhrzeit), findsOneWidget);
      expect(find.text(AppStrings.notizen), findsOneWidget);
    });

    testWidgets('should have correct button labels', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onAppointmentUpdated: () {},
      ));

      // Verify button labels are present
      expect(find.text(AppStrings.abbrechen), findsOneWidget);
      expect(find.text(AppStrings.speichern), findsOneWidget);
    });
  });
} 