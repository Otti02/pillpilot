import 'package:pillpilot/models/appointment_model.dart';

class AppointmentModel {
  final List<Appointment> appointments;

  final bool isLoading;

  AppointmentModel({required this.appointments, this.isLoading = false});

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
