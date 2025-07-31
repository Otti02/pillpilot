import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/medication_model.dart';
import '../../models/medication_state_model.dart';
import '../../services/medication_service.dart';
import '../../services/service_provider.dart';
import '../../services/notification_service.dart';
import '../../services/base_service.dart';

import '../base_controller.dart';

class MedicationController extends BlocController<MedicationModel> {
  final MedicationService medicationService;
  final NotificationService _notificationService;
  Timer? _midnightResetTimer;

  MedicationController({
    MedicationService? medicationService,
    NotificationService? notificationService,
  }) : medicationService =
           medicationService ?? ServiceProvider.instance.medicationService,
       _notificationService =
           notificationService ?? ServiceProvider.instance.notificationService,
       super(MedicationModel(medications: []));

  @override
  void handleError(String message, [Object? error]) {
    String userMessage = message;
    if (error is NetworkException) {
      userMessage = 'Bitte überprüfen Sie Ihre Internetverbindung.';
    } else if (error is ValidationException) {
      userMessage = 'Bitte überprüfen Sie Ihre Eingaben.';
    } else if (error is AppException) {
      userMessage =
          error.message.isNotEmpty
              ? error.message
              : 'Ein unbekannter Fehler ist aufgetreten.';
    } else {
      userMessage = 'Ein unbekannter Fehler ist aufgetreten.';
    }
    emit(state.copyWith(isLoading: false, error: userMessage));
  }

  @override
  Future<void> initialize() async {
    await loadMedications();
    _startMidnightResetTimer();
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
      handleError('Failed to load medications: ${e.toString()}', e);
    }
  }

  Future<Medication> createMedication(
    String name,
    String dosage,
    TimeOfDay time,
    List<int> daysOfWeek, {
    String notes = '',
  }) async {
    try {
      emit(state.copyWith(isLoading: true));
      final medication = await medicationService.createMedication(
        name,
        dosage,
        time,
        daysOfWeek,
        notes: notes,
      );
      await loadMedications();
      _notificationService.scheduleMedicationNotification(
        medication: medication,
      );
      return medication;
    } catch (e) {
      handleError('Failed to create medication: ${e.toString()}', e);
      rethrow;
    }
  }

  Future<Medication> updateMedication(Medication medication) async {
    try {
      emit(state.copyWith(isLoading: true));
      final updatedMedication = await medicationService.updateMedication(
        medication,
      );
      await loadMedications();
      _notificationService.scheduleMedicationNotification(
        medication: updatedMedication,
      );
      return updatedMedication;
    } catch (e) {
      handleError('Failed to update medication: ${e.toString()}', e);
      rethrow;
    }
  }

  Future<void> deleteMedication(String id) async {
    try {
      emit(state.copyWith(isLoading: true));
      await medicationService.deleteMedication(id);
      await loadMedications();
      _notificationService.cancelMedicationNotifications(id);
    } catch (e) {
      handleError('Failed to delete medication: ${e.toString()}', e);
      rethrow;
    }
  }

  Future<void> toggleMedicationCompletion(String id, bool isCompleted) async {
    try {
      emit(state.copyWith(isLoading: true));
      final medication = await medicationService.getMedicationById(id);
      final updatedMedication = medication.copyWith(isCompleted: isCompleted);
      await updateMedication(updatedMedication);
    } catch (e) {
      handleError('Failed to toggle medication completion: ${e.toString()}', e);
      rethrow;
    }
  }

  void _startMidnightResetTimer() {
    _midnightResetTimer?.cancel();

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);

    _midnightResetTimer = Timer(timeUntilMidnight, () {
      _resetAllMedications();
      _startMidnightResetTimer(); // Schedule next reset
    });
  }

  Future<void> _resetAllMedications() async {
    try {
      final medications = await medicationService.getMedications();
      final updatedMedications =
          medications.map((med) => med.copyWith(isCompleted: false)).toList();

      // Update all medications to reset their completion status
      for (final medication in updatedMedications) {
        await medicationService.updateMedication(medication);
      }

      // Reload medications to update the UI
      await loadMedications();
    } catch (e) {
      handleError(
        'Failed to reset medications at midnight: ${e.toString()}',
        e,
      );
    }
  }

  @override
  void dispose() {
    _midnightResetTimer?.cancel();
    super.dispose();
  }
}
