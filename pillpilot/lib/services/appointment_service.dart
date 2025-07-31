import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pillpilot/models/appointment_model.dart';
import 'package:pillpilot/services/base_service.dart';

abstract class AppointmentService {
  Future<List<Appointment>> getAppointments();

  Future<Appointment> getAppointmentById(String id);

  Future<Appointment> createAppointment(
    String title,
    DateTime date,
    TimeOfDay time, {
    String notes = '',
  });

  Future<Appointment> updateAppointment(Appointment appointment);

  Future<void> deleteAppointment(String id);

  Future<List<Appointment>> getAppointmentsForDate(DateTime date);

  Future<List<DateTime>> getDatesWithAppointments();
}

class AppointmentServiceImpl implements AppointmentService {
  static const String _appointmentsKey = 'appointments';

  static const String _nextIdKey = 'next_appointment_id';

  final PersistenceService _persistenceService;

  int _nextId = 1;

  AppointmentServiceImpl(this._persistenceService) {
    _initNextId();
  }

  Future<void> _initNextId() async {
    final nextIdStr = await _persistenceService.getData(_nextIdKey);
    if (nextIdStr != null) {
      _nextId = int.parse(nextIdStr as String);
    }
  }

  @override
  Future<List<Appointment>> getAppointments() async {
    final data = await _persistenceService.getData(_appointmentsKey);
    if (data == null) {
      return [];
    }

    final List<dynamic> appointmentsJson =
        jsonDecode(data as String) as List<dynamic>;
    return appointmentsJson
        .map(
          (dynamic json) => Appointment.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<Appointment> getAppointmentById(String id) async {
    final appointments = await getAppointments();
    final appointment = appointments.firstWhere(
      (a) => a.id == id,
      orElse: () => throw Exception('Appointment not found'),
    );
    return appointment;
  }

  @override
  Future<Appointment> createAppointment(
    String title,
    DateTime date,
    TimeOfDay time, {
    String notes = '',
  }) async {
    final appointments = await getAppointments();

    final String id = _nextId.toString();
    _nextId++;

    await _saveNextId();

    final Appointment newAppointment = Appointment(
      id: id,
      title: title,
      date: date,
      time: time,
      notes: notes,
    );

    appointments.add(newAppointment);
    await _saveAppointments(appointments);

    return newAppointment;
  }

  Future<void> _saveNextId() async {
    await _persistenceService.saveData(_nextIdKey, _nextId.toString());
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    final appointments = await getAppointments();

    final index = appointments.indexWhere((a) => a.id == appointment.id);
    if (index == -1) {
      throw Exception('Appointment not found');
    }

    appointments[index] = appointment;
    await _saveAppointments(appointments);

    return appointment;
  }

  @override
  Future<void> deleteAppointment(String id) async {
    final appointments = await getAppointments();

    final index = appointments.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw Exception('Appointment not found');
    }

    appointments.removeAt(index);
    await _saveAppointments(appointments);
  }

  @override
  Future<List<Appointment>> getAppointmentsForDate(DateTime date) async {
    final appointments = await getAppointments();

    return appointments
        .where(
          (appointment) =>
              appointment.date.year == date.year &&
              appointment.date.month == date.month &&
              appointment.date.day == date.day,
        )
        .toList();
  }

  @override
  Future<List<DateTime>> getDatesWithAppointments() async {
    final appointments = await getAppointments();

    final Set<String> uniqueDateStrings = {};
    for (final appointment in appointments) {
      uniqueDateStrings.add(appointment.date.dateString);
    }

    return uniqueDateStrings.map((dateString) {
      final parts = dateString.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }).toList();
  }

  Future<void> _saveAppointments(List<Appointment> appointments) async {
    final appointmentsJson = appointments.map((a) => a.toJson()).toList();
    await _persistenceService.saveData(
      _appointmentsKey,
      jsonEncode(appointmentsJson),
    );
  }
}
