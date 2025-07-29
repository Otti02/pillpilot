import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../models/appointment_state_model.dart';
import '../../services/appointment_service.dart';
import '../../services/service_provider.dart';
import '../base_controller.dart';

class AppointmentController extends BlocController<AppointmentModel> {
  final AppointmentService appointmentService;

  AppointmentController({AppointmentService? appointmentService})
      : appointmentService = appointmentService ?? ServiceProvider.instance.appointmentService,
        super(AppointmentModel(appointments: []));

  @override
  Future<void> initialize() async {
    await loadAppointments();
  }

  @override
  void handleError(String message, [Object? error]) {
    // For BLoC controllers, we emit an error state
    emit(state.copyWith(isLoading: false));
  }

  Future<void> loadAppointments() async {
    try {
      emit(state.copyWith(isLoading: true));
      final appointments = await appointmentService.getAppointments();
      emit(state.copyWith(appointments: appointments, isLoading: false));
    } catch (e) {
      handleError('Failed to load appointments: ${e.toString()}', e);
    }
  }

  Future<void> loadAppointmentsForDate(DateTime date) async {
    try {
      emit(state.copyWith(isLoading: true));
      final appointments = await appointmentService.getAppointmentsForDate(date);
      emit(state.copyWith(appointments: appointments, isLoading: false));
    } catch (e) {
      handleError('Failed to load appointments for date: ${e.toString()}', e);
    }
  }

  Future<List<DateTime>> getDatesWithAppointments() async {
    try {
      return await appointmentService.getDatesWithAppointments();
    } catch (e) {
      handleError('Failed to get dates with appointments: ${e.toString()}', e);
      rethrow;
    }
  }

  Future<Appointment> createAppointment(String title, DateTime date, TimeOfDay time, {String notes = ''}) async {
    try {
      emit(state.copyWith(isLoading: true));
      final appointment = await appointmentService.createAppointment(title, date, time, notes: notes);
      await loadAppointments();
      return appointment;
    } catch (e) {
      handleError('Failed to create appointment: ${e.toString()}', e);
      rethrow;
    }
  }

  Future<Appointment> updateAppointment(Appointment appointment) async {
    try {
      emit(state.copyWith(isLoading: true));
      final updatedAppointment = await appointmentService.updateAppointment(appointment);
      await loadAppointments();
      return updatedAppointment;
    } catch (e) {
      handleError('Failed to update appointment: ${e.toString()}', e);
      rethrow;
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      emit(state.copyWith(isLoading: true));
      await appointmentService.deleteAppointment(id);
      await loadAppointments();
    } catch (e) {
      handleError('Failed to delete appointment: ${e.toString()}', e);
      rethrow;
    }
  }
}