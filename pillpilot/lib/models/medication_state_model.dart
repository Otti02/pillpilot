import 'package:pillpilot/models/medication_model.dart';

class MedicationModel {
  final List<Medication> medications;
  
  final bool isLoading;
  
  MedicationModel({
    required this.medications,
    this.isLoading = false,
  });

  MedicationModel copyWith({
    List<Medication>? medications,
    bool? isLoading,
  }) {
    return MedicationModel(
      medications: medications ?? this.medications,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}