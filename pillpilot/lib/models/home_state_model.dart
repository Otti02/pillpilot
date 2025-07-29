import 'package:pillpilot/models/medication_model.dart';
import 'package:pillpilot/models/appointment_model.dart';

class HomeState {
  final List<Medication> medications;
  final List<Appointment> appointments;
  final String welcomeMessage;
  final bool isLoading;
  final String? error;

  HomeState({
    required this.medications,
    required this.appointments,
    this.welcomeMessage = '',
    this.isLoading = true,
    this.error,
  });

  HomeState copyWith({
    List<Medication>? medications,
    List<Appointment>? appointments,
    String? welcomeMessage,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      medications: medications ?? this.medications,
      appointments: appointments ?? this.appointments,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory HomeState.initial() => HomeState(
    medications: [],
    appointments: [],
    welcomeMessage: '',
    isLoading: true,
    error: null,
  );
} 