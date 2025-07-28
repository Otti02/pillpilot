import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/medication_model.dart';
import '../../models/medication_state_model.dart';
import '../../services/medication_service.dart';
import '../../services/service_provider.dart';
import '../../services/notification_service.dart';

class MedicationController extends Cubit<MedicationModel> {
  final MedicationService medicationService;
  final NotificationService _notificationService;

  MedicationController({
    MedicationService? medicationService,
    NotificationService? notificationService,
  })  : medicationService = medicationService ?? ServiceProvider().medicationService,
        _notificationService = notificationService ?? ServiceProvider().notificationService,
        super(MedicationModel(medications: []));

  void initialize() {
    loadMedications();
  }

  Future<void> loadMedications() async {
    try {
      emit(state.copyWith(isLoading: true));
      final medications = await medicationService.getMedications();
      emit(state.copyWith(medications: medications, isLoading: false));

      for (var med in medications) {
        _notificationService.scheduleMedicationNotification(medication: med);
      }

    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<Medication> createMedication(
      String name,
      String dosage,
      TimeOfDay time,
      List<int> daysOfWeek, {
        String notes = '',
      }) async {
    emit(state.copyWith(isLoading: true));
    final medication = await medicationService.createMedication(
      name,
      dosage,
      time,
      daysOfWeek,
      notes: notes,
    );
    await loadMedications();
    _notificationService.scheduleMedicationNotification(medication: medication);
    return medication;
  }

  Future<Medication> updateMedication(Medication medication) async {
    emit(state.copyWith(isLoading: true));
    final updatedMedication = await medicationService.updateMedication(medication);
    await loadMedications();
    _notificationService.scheduleMedicationNotification(medication: updatedMedication);
    return updatedMedication;
  }

  Future<void> deleteMedication(String id) async {
    emit(state.copyWith(isLoading: true));
    await medicationService.deleteMedication(id);
    await loadMedications();
    _notificationService.cancelMedicationNotifications(id);
  }

  Future<void> toggleMedicationCompletion(String id, bool isCompleted) async {
    emit(state.copyWith(isLoading: true));
    final medication = await medicationService.getMedicationById(id);
    final updatedMedication = medication.copyWith(isCompleted: isCompleted);
    await updateMedication(updatedMedication);
  }
}
