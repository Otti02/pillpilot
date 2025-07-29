import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../models/appointment_state_model.dart';
import '../../services/appointment_service.dart';
import '../../services/service_provider.dart';
import '../base_controller.dart';

class AppointmentController extends BlocController<AppointmentModel> {
  final AppointmentService appointmentService;

  AppointmentController({AppointmentService? appointmentService})
      : appointmentService = appointmentService ?? ServiceProvider().appointmentService,
        super(AppointmentModel(appointments: []));

  @override
  Future<void> initialize() async {
    await loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      emit(state.copyWith(isLoading: true));
      final appointments = await appointmentService.getAppointments();
      emit(state.copyWith(appointments: appointments, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Error handling could be improved here
    }
  }

  Future<void> loadAppointmentsForDate(DateTime date) async {
    try {
      emit(state.copyWith(isLoading: true));
      final appointments = await appointmentService.getAppointmentsForDate(date);
      emit(state.copyWith(appointments: appointments, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<List<DateTime>> getDatesWithAppointments() async {
    return await appointmentService.getDatesWithAppointments();
  }

  Future<Appointment> createAppointment(String title, DateTime date, TimeOfDay time, {String notes = ''}) async {
    emit(state.copyWith(isLoading: true));
    final appointment = await appointmentService.createAppointment(title, date, time, notes: notes);
    await loadAppointments();
    return appointment;
  }

  Future<Appointment> updateAppointment(Appointment appointment) async {
    emit(state.copyWith(isLoading: true));
    final updatedAppointment = await appointmentService.updateAppointment(appointment);
    await loadAppointments();
    return updatedAppointment;
  }

  Future<void> deleteAppointment(String id) async {
    emit(state.copyWith(isLoading: true));
    await appointmentService.deleteAppointment(id);
    await loadAppointments();
  }
}