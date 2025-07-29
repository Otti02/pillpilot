import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pillpilot/controllers/home/home_controller.dart';
import 'package:pillpilot/services/medication_service.dart';
import 'package:pillpilot/services/appointment_service.dart';
import 'package:pillpilot/models/medication_model.dart';
import 'package:flutter/material.dart';

@GenerateMocks([MedicationService, AppointmentService])
import './home_controller_test.mocks.dart'; // Diese Datei wird generiert

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

    setUp(() {
      mockMedicationService = MockMedicationService();
      mockAppointmentService = MockAppointmentService();
      homeController = HomeController(
        medicationService: mockMedicationService,
        appointmentService: mockAppointmentService,
      );
    });

    test(
        'toggleMedicationCompletion should update medication and reload the list',
            () async {
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
  });
}
