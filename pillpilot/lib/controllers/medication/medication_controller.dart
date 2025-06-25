import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/medication_model.dart';
import '../../models/medication_state_model.dart';
import '../../services/medication_service.dart';
import '../../services/service_provider.dart';

class MedicationController extends Cubit<MedicationModel> {
  final MedicationService medicationService;

  MedicationController({MedicationService? medicationService})
      : medicationService = medicationService ?? ServiceProvider().medicationService,
        super(MedicationModel(medications: []));

  void initialize() {
    loadMedications();
  }

  Future<void> loadMedications() async {
    try {
      emit(state.copyWith(isLoading: true));
      final medications = await medicationService.getMedications();
      emit(state.copyWith(medications: medications, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Error handling could be improved here
    }
  }

  Future<Medication> createMedication(String name, String dosage, String timeOfDay, {String notes = ''}) async {
    emit(state.copyWith(isLoading: true));
    final medication = await medicationService.createMedication(name, dosage, timeOfDay, notes: notes);
    await loadMedications();
    return medication;
  }

  Future<Medication> updateMedication(Medication medication) async {
    emit(state.copyWith(isLoading: true));
    final updatedMedication = await medicationService.updateMedication(medication);
    await loadMedications();
    return updatedMedication;
  }

  Future<void> deleteMedication(String id) async {
    emit(state.copyWith(isLoading: true));
    await medicationService.deleteMedication(id);
    await loadMedications();
  }

  Future<void> toggleMedicationCompletion(String id, bool isCompleted) async {
    emit(state.copyWith(isLoading: true));
    final medication = await medicationService.getMedicationById(id);
    final updatedMedication = medication.copyWith(isCompleted: isCompleted);
    await updateMedication(updatedMedication);
  }
}
