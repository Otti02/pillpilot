import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pillpilot/models/appointment_model.dart';
import 'package:pillpilot/services/base_service.dart';
import 'package:pillpilot/services/service_provider.dart';

/// Service for managing appointments in the application.
abstract class AppointmentService extends BaseService {
  /// Retrieves all appointments.
  Future<List<Appointment>> getAppointments();

  /// Retrieves an appointment by its ID.
  ///
  /// Throws an exception if the appointment is not found.
  Future<Appointment> getAppointmentById(String id);

  /// Creates a new appointment with the given details.
  Future<Appointment> createAppointment(String title, DateTime date, TimeOfDay time, {String notes = ''});

  /// Updates an existing appointment.
  ///
  /// Throws an exception if the appointment is not found.
  Future<Appointment> updateAppointment(Appointment appointment);

  /// Deletes an appointment by its ID.
  ///
  /// Throws an exception if the appointment is not found.
  Future<void> deleteAppointment(String id);
  
  /// Retrieves all appointments for a specific date.
  Future<List<Appointment>> getAppointmentsForDate(DateTime date);
  
  /// Retrieves all dates that have appointments.
  Future<List<DateTime>> getDatesWithAppointments();
}

/// Implementation of the [AppointmentService] using local storage.
class AppointmentServiceImpl extends BaseService implements AppointmentService {
  /// Key used to store appointments in persistent storage.
  static const String _appointmentsKey = 'appointments';

  /// Key used to store the next appointment ID in persistent storage.
  static const String _nextIdKey = 'next_appointment_id';

  /// Service used for data persistence.
  final PersistenceService _persistenceService;

  /// Next ID to be used for a new appointment.
  int _nextId = 1;

  /// Singleton instance of the service.
  static final AppointmentServiceImpl _instance = AppointmentServiceImpl._internal(
    ServiceProvider().persistenceService,
  );

  /// Factory constructor that returns the singleton instance.
  factory AppointmentServiceImpl() {
    return _instance;
  }

  /// Internal constructor that initializes the service.
  ///
  /// Initializes the next ID from storage or uses default value 1.
  AppointmentServiceImpl._internal(this._persistenceService) {
    _initNextId();
  }

  /// Initializes the next ID from persistent storage.
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

    final List<dynamic> appointmentsJson = jsonDecode(data as String) as List<dynamic>;
    return appointmentsJson
        .map((dynamic json) => Appointment.fromJson(json as Map<String, dynamic>))
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
  Future<Appointment> createAppointment(String title, DateTime date, TimeOfDay time, {String notes = ''}) async {
    final appointments = await getAppointments();

    // Generate a new ID for the appointment
    final String id = _nextId.toString();
    _nextId++;

    // Persist the updated ID counter
    await _saveNextId();

    // Create the new appointment object
    final Appointment newAppointment = Appointment(
      id: id,
      title: title,
      date: date,
      time: time,
      notes: notes,
    );

    // Add to the list and save
    appointments.add(newAppointment);
    await _saveAppointments(appointments);

    return newAppointment;
  }

  /// Saves the next ID to persistent storage.
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
    
    // Filter appointments for the specific date
    return appointments.where((appointment) => 
      appointment.date.year == date.year && 
      appointment.date.month == date.month && 
      appointment.date.day == date.day
    ).toList();
  }
  
  @override
  Future<List<DateTime>> getDatesWithAppointments() async {
    final appointments = await getAppointments();
    
    // Extract unique dates from appointments
    final Set<String> uniqueDateStrings = {};
    for (final appointment in appointments) {
      uniqueDateStrings.add(appointment.date.dateString);
    }
    
    // Convert date strings back to DateTime objects
    return uniqueDateStrings.map((dateString) {
      final parts = dateString.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }).toList();
  }

  /// Saves the list of appointments to persistent storage.
  ///
  /// Converts each appointment to JSON format before saving.
  Future<void> _saveAppointments(List<Appointment> appointments) async {
    final appointmentsJson = appointments.map((a) => a.toJson()).toList();
    await _persistenceService.saveData(_appointmentsKey, jsonEncode(appointmentsJson));
  }
}