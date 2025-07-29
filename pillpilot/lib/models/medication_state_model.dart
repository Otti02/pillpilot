import 'package:pillpilot/models/medication_model.dart';

class MedicationModel {
  final List<Medication> medications;
  
  final bool isLoading;
  
  final String? error;

  MedicationModel({
    required this.medications,
    this.isLoading = false,
    this.error,
  });

  MedicationModel copyWith({
    List<Medication>? medications,
    bool? isLoading,
    String? error,
  }) {
    return MedicationModel(
      medications: medications ?? this.medications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}