import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pillpilot/controllers/home/home_controller.dart';
import 'package:pillpilot/services/medication_service.dart';
import 'package:pillpilot/services/appointment_service.dart';
import 'package:pillpilot/models/medication_model.dart';
import 'package:pillpilot/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:pillpilot/services/base_service.dart';

@GenerateMocks([MedicationService, AppointmentService])
import './home_controller_test.mocks.dart';

void main() {
  group('HomeController', () {
    late MockMedicationService mockMedicationService;
    late MockAppointmentService mockAppointmentService;
    late HomeController homeController;

    final testMedication = Medication(
      id: '1',
      name: 'Aspirin',
      dosage: '100mg',
      time: const TimeOfDay(hour: 8, minute: 0),
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      isCompleted: false,
    );

    final testAppointment = Appointment(
      id: '1',
      title: 'Doctor Appointment',
      date: DateTime.now(),
      time: const TimeOfDay(hour: 10, minute: 0),
      notes: 'Regular checkup',
    );

    setUp(() {
      mockMedicationService = MockMedicationService();
      mockAppointmentService = MockAppointmentService();
      homeController = HomeController(
        medicationService: mockMedicationService,
        appointmentService: mockAppointmentService,
      );
    });

    group('Happy Path Tests', () {
      test('initialize should load medications and appointments', () async {
        // ARRANGE
        when(
          mockMedicationService.getMedications(),
        ).thenAnswer((_) async => [testMedication]);
        when(
          mockAppointmentService.getAppointmentsForDate(any),
        ).thenAnswer((_) async => [testAppointment]);

        // ACT
        await homeController.initialize();

        // ASSERT
        expect(homeController.state.medications, isNotNull);
        expect(homeController.state.medications.length, 1);
        expect(homeController.state.appointments, isNotNull);
        expect(homeController.state.appointments.length, 1);
      });

      test(
        'toggleMedicationCompletion should update medication and reload the list',
        () async {
          // ARRANGE
          when(
            mockMedicationService.getMedicationById('1'),
          ).thenAnswer((_) async => testMedication);

          when(
            mockMedicationService.updateMedication(any),
          ).thenAnswer((_) async => testMedication.copyWith(isCompleted: true));

          when(mockMedicationService.getMedications()).thenAnswer(
            (_) async => [testMedication.copyWith(isCompleted: true)],
          );

          // ACT
          await homeController.toggleMedicationCompletion('1', true);

          // ASSERT
          verify(
            mockMedicationService.updateMedication(
              argThat(
                isA<Medication>().having(
                  (m) => m.isCompleted,
                  'isCompleted',
                  true,
                ),
              ),
            ),
          ).called(1);

          expect(homeController.state.medications, isNotNull);
          expect(homeController.state.medications.length, 1);
          expect(homeController.state.medications.first.isCompleted, true);
        },
      );

      test('loadMedications should filter medications for today', () async {
        // ARRANGE
        final today = DateTime.now().weekday;
        final todayMedication = testMedication.copyWith(daysOfWeek: [today]);
        final otherMedication = testMedication.copyWith(
          id: '2',
          daysOfWeek: [today == 1 ? 2 : 1], // Different day
        );

        when(
          mockMedicationService.getMedications(),
        ).thenAnswer((_) async => [todayMedication, otherMedication]);

        // ACT
        await homeController.loadMedications();

        // ASSERT
        expect(homeController.state.medications, isNotNull);
        expect(homeController.state.medications.length, 1);
        expect(homeController.state.medications.first.id, '1');
      });
    });

    group('Error Handling Tests', () {
      test('loadMedications should handle network errors', () async {
        // ARRANGE
        when(
          mockMedicationService.getMedications(),
        ).thenThrow(NetworkException('No connection'));

        // ACT
        await homeController.loadMedications();

        // ASSERT
        expect(
          homeController.state.error,
          'Bitte überprüfen Sie Ihre Internetverbindung.',
        );
      });

      test('loadMedications should handle validation errors', () async {
        // ARRANGE
        when(
          mockMedicationService.getMedications(),
        ).thenThrow(ValidationException('Invalid data'));

        // ACT
        await homeController.loadMedications();

        // ASSERT
        expect(
          homeController.state.error,
          'Bitte überprüfen Sie Ihre Eingaben.',
        );
      });

      test('loadMedications should handle unknown errors', () async {
        // ARRANGE
        when(
          mockMedicationService.getMedications(),
        ).thenThrow(Exception('Unknown'));

        // ACT
        await homeController.loadMedications();

        // ASSERT
        expect(
          homeController.state.error,
          'Ein unbekannter Fehler ist aufgetreten.',
        );
      });

      test('loadAppointments should handle network errors', () async {
        // ARRANGE
        when(
          mockAppointmentService.getAppointmentsForDate(any),
        ).thenThrow(NetworkException('No connection'));

        // ACT
        await homeController.loadAppointments();

        // ASSERT
        expect(
          homeController.state.error,
          'Bitte überprüfen Sie Ihre Internetverbindung.',
        );
      });

      test('loadAppointments should handle validation errors', () async {
        // ARRANGE
        when(
          mockAppointmentService.getAppointmentsForDate(any),
        ).thenThrow(ValidationException('Invalid data'));

        // ACT
        await homeController.loadAppointments();

        // ASSERT
        expect(
          homeController.state.error,
          'Bitte überprüfen Sie Ihre Eingaben.',
        );
      });

      test('loadAppointments should handle unknown errors', () async {
        // ARRANGE
        when(
          mockAppointmentService.getAppointmentsForDate(any),
        ).thenThrow(Exception('Unknown'));

        // ACT
        await homeController.loadAppointments();

        // ASSERT
        expect(
          homeController.state.error,
          'Ein unbekannter Fehler ist aufgetreten.',
        );
      });

      test('toggleMedicationCompletion should handle service errors', () async {
        // ARRANGE
        when(
          mockMedicationService.getMedicationById('1'),
        ).thenThrow(Exception('Medication not found'));

        // ACT
        await homeController.toggleMedicationCompletion('1', true);

        // ASSERT
        expect(
          homeController.state.error,
          'Ein unbekannter Fehler ist aufgetreten.',
        );
      });

      test('initialize should handle partial failures gracefully', () async {
        // ARRANGE
        when(
          mockMedicationService.getMedications(),
        ).thenAnswer((_) async => [testMedication]);
        when(
          mockAppointmentService.getAppointmentsForDate(any),
        ).thenThrow(NetworkException('No connection'));

        // ACT
        await homeController.initialize();

        // ASSERT
        expect(homeController.state.medications, isNotNull);
        expect(homeController.state.medications.length, 1);
        expect(
          homeController.state.error,
          'Bitte überprüfen Sie Ihre Internetverbindung.',
        );
      });
    });

    group('Edge Cases', () {
      test('loadMedications should handle empty medication list', () async {
        // ARRANGE
        when(
          mockMedicationService.getMedications(),
        ).thenAnswer((_) async => <Medication>[]);

        // ACT
        await homeController.loadMedications();

        // ASSERT
        expect(homeController.state.medications, isNotNull);
        expect(homeController.state.medications.length, 0);
      });

      test('loadAppointments should handle empty appointment list', () async {
        // ARRANGE
        when(
          mockAppointmentService.getAppointmentsForDate(any),
        ).thenAnswer((_) async => <Appointment>[]);

        // ACT
        await homeController.loadAppointments();

        // ASSERT
        expect(homeController.state.appointments, isNotNull);
        expect(homeController.state.appointments.length, 0);
      });
    });
  });
}
