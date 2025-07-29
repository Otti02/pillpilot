import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pillpilot/controllers/home/home_controller.dart';
import 'package:pillpilot/services/medication_service.dart';
import 'package:pillpilot/services/appointment_service.dart';
import 'package:pillpilot/models/medication_model.dart';
import 'package:pillpilot/models/appointment_model.dart';
import 'package:flutter/material.dart';

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
        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => [testMedication]);
        when(mockAppointmentService.getAppointmentsForDate(any))
            .thenAnswer((_) async => [testAppointment]);

        List<Medication>? capturedMedications;
        List<Appointment>? capturedAppointments;
        homeController.onMedicationsLoaded = (meds) => capturedMedications = meds;
        homeController.onAppointmentsLoaded = (apps) => capturedAppointments = apps;

        // ACT
        await homeController.initialize();

        // ASSERT
        expect(capturedMedications, isNotNull);
        expect(capturedMedications!.length, 1);
        expect(capturedAppointments, isNotNull);
        expect(capturedAppointments!.length, 1);
      });

      test('toggleMedicationCompletion should update medication and reload the list', () async {
        // ARRANGE
        when(mockMedicationService.getMedicationById('1'))
            .thenAnswer((_) async => testMedication);

        when(mockMedicationService.updateMedication(any))
            .thenAnswer((_) async => testMedication.copyWith(isCompleted: true));

        when(mockMedicationService.getMedications()).thenAnswer((_) async => [
          testMedication.copyWith(isCompleted: true),
        ]);

        List<Medication>? capturedMedications;
        homeController.onMedicationsLoaded = (meds) {
          capturedMedications = meds;
        };

        // ACT
        await homeController.toggleMedicationCompletion('1', true);

        // ASSERT
        verify(mockMedicationService.updateMedication(
          argThat(isA<Medication>().having((m) => m.isCompleted, 'isCompleted', true)),
        )).called(1);

        expect(capturedMedications, isNotNull);
        expect(capturedMedications!.length, 1);
        expect(capturedMedications!.first.isCompleted, true);
      });

      test('loadMedications should filter medications for today', () async {
        // ARRANGE
        final today = DateTime.now().weekday;
        final todayMedication = testMedication.copyWith(daysOfWeek: [today]);
        final otherMedication = testMedication.copyWith(
          id: '2',
          daysOfWeek: [today == 1 ? 2 : 1], // Different day
        );

        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => [todayMedication, otherMedication]);

        List<Medication>? capturedMedications;
        homeController.onMedicationsLoaded = (meds) => capturedMedications = meds;

        // ACT
        await homeController.loadMedications();

        // ASSERT
        expect(capturedMedications, isNotNull);
        expect(capturedMedications!.length, 1);
        expect(capturedMedications!.first.id, '1');
      });
    });

    group('Error Handling Tests', () {
      test('loadMedications should handle service errors', () async {
        // ARRANGE
        when(mockMedicationService.getMedications())
            .thenThrow(Exception('Database connection failed'));

        String? capturedError;
        homeController.onError = (error) => capturedError = error;

        // ACT
        await homeController.loadMedications();

        // ASSERT
        expect(capturedError, isNotNull);
        expect(capturedError!.contains('Failed to load medications'), isTrue);
      });

      test('loadAppointments should handle service errors', () async {
        // ARRANGE
        when(mockAppointmentService.getAppointmentsForDate(any))
            .thenThrow(Exception('Failed to fetch appointments'));

        String? capturedError;
        homeController.onError = (error) => capturedError = error;

        // ACT
        await homeController.loadAppointments();

        // ASSERT
        expect(capturedError, isNotNull);
        expect(capturedError!.contains('Failed to load appointments'), isTrue);
      });

      test('toggleMedicationCompletion should handle service errors', () async {
        // ARRANGE
        when(mockMedicationService.getMedicationById('1'))
            .thenThrow(Exception('Medication not found'));

        String? capturedError;
        homeController.onError = (error) => capturedError = error;

        // ACT
        await homeController.toggleMedicationCompletion('1', true);

        // ASSERT
        expect(capturedError, isNotNull);
        expect(capturedError!.contains('Failed to update medication'), isTrue);
      });

      test('initialize should handle partial failures gracefully', () async {
        // ARRANGE
        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => [testMedication]);
        when(mockAppointmentService.getAppointmentsForDate(any))
            .thenThrow(Exception('Appointment service failed'));

        List<Medication>? capturedMedications;
        String? capturedError;
        homeController.onMedicationsLoaded = (meds) => capturedMedications = meds;
        homeController.onError = (error) => capturedError = error;

        // ACT
        await homeController.initialize();

        // ASSERT
        expect(capturedMedications, isNotNull);
        expect(capturedMedications!.length, 1);
        expect(capturedError, isNotNull);
        expect(capturedError!.contains('Failed to load appointments'), isTrue);
      });
    });

    group('Edge Cases', () {
      test('loadMedications should handle empty medication list', () async {
        // ARRANGE
        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => <Medication>[]);

        List<Medication>? capturedMedications;
        homeController.onMedicationsLoaded = (meds) => capturedMedications = meds;

        // ACT
        await homeController.loadMedications();

        // ASSERT
        expect(capturedMedications, isNotNull);
        expect(capturedMedications!.length, 0);
      });

      test('loadAppointments should handle empty appointment list', () async {
        // ARRANGE
        when(mockAppointmentService.getAppointmentsForDate(any))
            .thenAnswer((_) async => <Appointment>[]);

        List<Appointment>? capturedAppointments;
        homeController.onAppointmentsLoaded = (apps) => capturedAppointments = apps;

        // ACT
        await homeController.loadAppointments();

        // ASSERT
        expect(capturedAppointments, isNotNull);
        expect(capturedAppointments!.length, 0);
      });
    });
  });
}
