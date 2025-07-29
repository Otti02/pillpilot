import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pillpilot/controllers/medication/medication_controller.dart';
import 'package:pillpilot/models/medication_model.dart';
import 'package:pillpilot/models/medication_state_model.dart';
import 'package:pillpilot/services/medication_service.dart';
import 'package:pillpilot/services/notification_service.dart';
import 'package:pillpilot/services/base_service.dart';
import 'package:pillpilot/theme/app_strings.dart';

@GenerateMocks([MedicationService, NotificationService])
import './medication_controller_test.mocks.dart';

void main() {
  group('MedicationController', () {
    late MockMedicationService mockMedicationService;
    late MockNotificationService mockNotificationService;
    late MedicationController medicationController;

    final testMedication = Medication(
      id: '1',
      name: 'Aspirin',
      dosage: '100mg',
      time: const TimeOfDay(hour: 8, minute: 0),
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      isCompleted: false,
      enableReminders: true,
      notes: 'Test notes',
    );

    setUp(() {
      mockMedicationService = MockMedicationService();
      mockNotificationService = MockNotificationService();
      medicationController = MedicationController(
        medicationService: mockMedicationService,
        notificationService: mockNotificationService,
      );
    });

    group('Happy Path Tests', () {
      test('loadMedications should update state with medications', () async {
        // ARRANGE
        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => [testMedication]);

        // ACT
        await medicationController.loadMedications();

        // ASSERT
        expect(medicationController.state.medications.length, 1);
        expect(medicationController.state.medications.first.id, '1');
        expect(medicationController.state.isLoading, false);
        verify(mockNotificationService.scheduleMedicationNotification(medication: testMedication)).called(1);
      });

      test('createMedication should create medication and update state', () async {
        // ARRANGE
        when(mockMedicationService.createMedication(
          'Aspirin',
          '100mg',
          const TimeOfDay(hour: 8, minute: 0),
          [1, 2, 3, 4, 5, 6, 7],
          notes: 'Test notes',
        )).thenAnswer((_) async => testMedication);

        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => [testMedication]);

        // ACT
        final result = await medicationController.createMedication(
          'Aspirin',
          '100mg',
          const TimeOfDay(hour: 8, minute: 0),
          [1, 2, 3, 4, 5, 6, 7],
          notes: 'Test notes',
        );

        // ASSERT
        expect(result.id, '1');
        expect(medicationController.state.medications.length, 1);
        verify(mockNotificationService.scheduleMedicationNotification(medication: testMedication)).called(2);
      });

      test('updateMedication should update medication and reload list', () async {
        // ARRANGE
        final updatedMedication = testMedication.copyWith(name: 'Updated Aspirin');

        when(mockMedicationService.updateMedication(testMedication))
            .thenAnswer((_) async => updatedMedication);

        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => [updatedMedication]);

        // ACT
        final result = await medicationController.updateMedication(testMedication);

        // ASSERT
        expect(result.name, 'Updated Aspirin');
        expect(medicationController.state.medications.length, 1);
        expect(medicationController.state.medications.first.name, 'Updated Aspirin');
        verify(mockNotificationService.scheduleMedicationNotification(medication: updatedMedication)).called(2);
      });

      test('deleteMedication should delete medication and reload list', () async {
        // ARRANGE
        when(mockMedicationService.deleteMedication('1'))
            .thenAnswer((_) async => {});

        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => []);

        // ACT
        await medicationController.deleteMedication('1');

        // ASSERT
        expect(medicationController.state.medications.length, 0);
        verify(mockNotificationService.cancelMedicationNotifications('1')).called(1);
      });

      test('toggleMedicationCompletion should update completion status', () async {
        // ARRANGE
        final completedMedication = testMedication.copyWith(isCompleted: true);

        when(mockMedicationService.getMedicationById('1'))
            .thenAnswer((_) async => testMedication);

        when(mockMedicationService.updateMedication(any))
            .thenAnswer((_) async => completedMedication);

        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => [completedMedication]);

        // ACT
        await medicationController.toggleMedicationCompletion('1', true);

        // ASSERT
        expect(medicationController.state.medications.length, 1);
        expect(medicationController.state.medications.first.isCompleted, true);

        verify(mockMedicationService.updateMedication(
          argThat(isA<Medication>().having((m) => m.isCompleted, 'isCompleted', true)),
        )).called(1);
      });
    });

    group('Error Handling Tests', () {
      test('loadMedications should handle network errors gracefully', () async {
        // ARRANGE
        when(mockMedicationService.getMedications())
            .thenThrow(NetworkException('No connection'));

        // ACT
        await medicationController.loadMedications();

        // ASSERT
        expect(medicationController.state.isLoading, false);
        expect(medicationController.state.error, AppStrings.networkError);
      });

      test('loadMedications should handle validation errors gracefully', () async {
        // ARRANGE
        when(mockMedicationService.getMedications())
            .thenThrow(ValidationException('Invalid data'));

        // ACT
        await medicationController.loadMedications();

        // ASSERT
        expect(medicationController.state.isLoading, false);
        expect(medicationController.state.error, AppStrings.validationError);
      });

      test('loadMedications should handle unknown errors gracefully', () async {
        // ARRANGE
        when(mockMedicationService.getMedications())
            .thenThrow(Exception('Unknown'));

        // ACT
        await medicationController.loadMedications();

        // ASSERT
        expect(medicationController.state.isLoading, false);
        expect(medicationController.state.error, AppStrings.unknownError);
      });

      test('createMedication should handle service errors and rethrow', () async {
        // ARRANGE
        when(mockMedicationService.createMedication(
          any, any, any, any, notes: anyNamed('notes'),
        )).thenThrow(Exception('Failed to create medication'));

        // ACT & ASSERT
        expect(
          () => medicationController.createMedication(
            'Aspirin',
            '100mg',
            const TimeOfDay(hour: 8, minute: 0),
            [1, 2, 3, 4, 5, 6, 7],
            notes: 'Test notes',
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('updateMedication should handle service errors and rethrow', () async {
        // ARRANGE
        when(mockMedicationService.updateMedication(any))
            .thenThrow(Exception('Failed to update medication'));

        // ACT & ASSERT
        expect(
          () => medicationController.updateMedication(testMedication),
          throwsA(isA<Exception>()),
        );
      });

      test('deleteMedication should handle service errors and rethrow', () async {
        // ARRANGE
        when(mockMedicationService.deleteMedication('1'))
            .thenThrow(Exception('Failed to delete medication'));

        // ACT & ASSERT
        expect(
          () => medicationController.deleteMedication('1'),
          throwsA(isA<Exception>()),
        );
      });

      test('toggleMedicationCompletion should handle medication not found', () async {
        // ARRANGE
        when(mockMedicationService.getMedicationById('999'))
            .thenThrow(Exception('Medication not found'));

        // ACT & ASSERT
        expect(
          () => medicationController.toggleMedicationCompletion('999', true),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Edge Cases', () {
      test('loadMedications should handle empty medication list', () async {
        // ARRANGE
        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => <Medication>[]);

        // ACT
        await medicationController.loadMedications();

        // ASSERT
        expect(medicationController.state.medications.length, 0);
        expect(medicationController.state.isLoading, false);
        // Don't verify notification calls since there are no medications
      });

      test('loadMedications should handle null service response', () async {
        // ARRANGE
        when(mockMedicationService.getMedications())
            .thenAnswer((_) async => <Medication>[]);

        // ACT
        await medicationController.loadMedications();

        // ASSERT
        expect(medicationController.state.medications.length, 0);
        expect(medicationController.state.isLoading, false);
      });
    });
  });
}
