import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pillpilot/widgets/appointment_details_dialog.dart';
import 'package:pillpilot/models/appointment_model.dart';
import 'package:pillpilot/theme/app_strings.dart';
import 'package:pillpilot/theme/app_theme.dart';
import 'package:pillpilot/controllers/appointment/appointment_controller.dart';
import 'package:pillpilot/models/appointment_state_model.dart';

import 'appointment_details_dialog_test.mocks.dart';

@GenerateMocks([AppointmentController])
void main() {
  group('AppointmentDetailsDialog', () {
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
      required VoidCallback onDelete,
      required VoidCallback onEdit,
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
              body: AppointmentDetailsDialog(
                appointment: appointment,
                onDelete: onDelete,
                onEdit: onEdit,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should display appointment details correctly', (WidgetTester tester) async {
      bool deleteCalled = false;
      bool editCalled = false;

      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onDelete: () => deleteCalled = true,
        onEdit: () => editCalled = true,
      ));

      // Verify title is displayed
      expect(find.text('Test Termin'), findsOneWidget);

      // Verify date is displayed
      expect(find.text('${AppStrings.datum}: 15.01.2024'), findsOneWidget);

      // Verify time label is displayed
      expect(find.textContaining('${AppStrings.uhrzeit}:'), findsOneWidget);

      // Verify notes are displayed
      expect(find.text('${AppStrings.notizen}:'), findsOneWidget);
      expect(find.text('Test Notizen'), findsOneWidget);
    });

    testWidgets('should not display notes section when notes are empty', (WidgetTester tester) async {
      final appointmentWithoutNotes = testAppointment.copyWith(notes: '');

      await tester.pumpWidget(createTestWidget(
        appointment: appointmentWithoutNotes,
        onDelete: () {},
        onEdit: () {},
      ));

      // Verify notes section is not displayed
      expect(find.text('${AppStrings.notizen}:'), findsNothing);
    });

    testWidgets('should call onDelete when delete button is tapped', (WidgetTester tester) async {
      bool deleteCalled = false;

      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onDelete: () => deleteCalled = true,
        onEdit: () {},
      ));

      // Find and tap the delete button
      final deleteButton = find.byIcon(Icons.delete);
      expect(deleteButton, findsOneWidget);

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      expect(deleteCalled, isTrue);
    });

    testWidgets('should call onEdit when edit button is tapped', (WidgetTester tester) async {
      bool editCalled = false;

      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onDelete: () {},
        onEdit: () => editCalled = true,
      ));

      // Find and tap the edit button
      final editButton = find.byIcon(Icons.edit);
      expect(editButton, findsOneWidget);

      await tester.tap(editButton);
      await tester.pumpAndSettle();

      expect(editCalled, isTrue);
    });

    testWidgets('should close dialog when close button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onDelete: () {},
        onEdit: () {},
      ));

      // Find and tap the close button
      final closeButton = find.byIcon(Icons.close);
      expect(closeButton, findsOneWidget);

      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.byType(AppointmentDetailsDialog), findsNothing);
    });

    testWidgets('should display correct tooltips', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onDelete: () {},
        onEdit: () {},
      ));

      // Verify tooltips are present
      expect(find.byTooltip(AppStrings.loeschen), findsOneWidget);
      expect(find.byTooltip(AppStrings.bearbeiten), findsOneWidget);
    });

    testWidgets('should have correct icon sizes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onDelete: () {},
        onEdit: () {},
      ));

      // Find the delete and edit icons
      final deleteIcon = find.byIcon(Icons.delete);
      final editIcon = find.byIcon(Icons.edit);

      expect(deleteIcon, findsOneWidget);
      expect(editIcon, findsOneWidget);

      // Verify the icons have the correct size
      final deleteIconWidget = tester.widget<Icon>(deleteIcon);
      final editIconWidget = tester.widget<Icon>(editIcon);

      expect(deleteIconWidget.size, equals(32));
      expect(editIconWidget.size, equals(32));
    });

    testWidgets('should have red color for delete icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        appointment: testAppointment,
        onDelete: () {},
        onEdit: () {},
      ));

      // Find the delete icon
      final deleteIcon = find.byIcon(Icons.delete);
      final deleteIconWidget = tester.widget<Icon>(deleteIcon);

      expect(deleteIconWidget.color, equals(Colors.red));
    });
  });
} 