import 'package:pillpilot/models/appointment_model.dart';

/// Model representing the state of appointments in the application.
///
/// Contains a list of appointments and a loading state.
class AppointmentModel {
  /// List of appointments.
  final List<Appointment> appointments;

  /// Whether the appointments are currently loading.
  final bool isLoading;

  /// Creates a new appointment model instance.
  AppointmentModel({required this.appointments, this.isLoading = false});

  /// Creates a copy of the appointment model with updated fields.
  ///
  /// Any parameter that is null will use the current value.
  AppointmentModel copyWith({
    List<Appointment>? appointments,
    bool? isLoading,
  }) {
    return AppointmentModel(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
