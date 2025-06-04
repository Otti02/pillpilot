import 'dart:async';
import '../../models/medication_model.dart';
import '../../services/medication_service.dart';
import '../../services/service_provider.dart';

class MedicationController {
  final MedicationService _medicationService;

  // Callbacks
  void Function(List<Medication>)? onMedicationsLoaded;
  void Function(String)? onError;

  // Stream controller for medications
  final _medicationsController = StreamController<List<Medication>>();
  Stream<List<Medication>> get medicationsStream => _medicationsController.stream;

  MedicationController({MedicationService? medicationService})
      : _medicationService = medicationService ?? ServiceProvider().medicationService;

  void initialize() {
    loadMedications();
  }

  Future<void> loadMedications() async {
    try {
      final medications = await _medicationService.getMedications();
      _medicationsController.add(medications);

      if (onMedicationsLoaded != null) {
        onMedicationsLoaded!(medications);
      }
    } catch (e) {
      if (onError != null) {
        onError!(e.toString());
      }
    }
  }

  Future<Medication> createMedication(String name, String dosage, String timeOfDay) async {
    final medication = await _medicationService.createMedication(name, dosage, timeOfDay);
    await loadMedications();
    return medication;
  }

  Future<Medication> updateMedication(Medication medication) async {
    final updatedMedication = await _medicationService.updateMedication(medication);
    await loadMedications();
    return updatedMedication;
  }

  Future<void> deleteMedication(String id) async {
    await _medicationService.deleteMedication(id);
    await loadMedications();
  }

  Future<void> toggleMedicationCompletion(String id, bool isCompleted) async {
    final medication = await _medicationService.getMedicationById(id);
    final updatedMedication = medication.copyWith(isCompleted: isCompleted);
    await updateMedication(updatedMedication);
  }

  void dispose() {
    _medicationsController.close();
  }
}
