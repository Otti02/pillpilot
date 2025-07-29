import 'package:flutter/material.dart';
import 'base_model.dart';

/// Model representing an appointment in the calendar.
///
/// Contains information about an appointment including its title,
/// date, time, and optional notes.
class Appointment extends BaseModel implements Persistable {
  /// Unique identifier for the appointment.
  @override
  final String id;

  /// Title of the appointment.
  final String title;

  /// Date of the appointment.
  final DateTime date;

  /// Time of the appointment.
  final TimeOfDay time;

  /// Optional notes about the appointment.
  final String notes;

  /// Creates a new appointment instance.
  Appointment({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    this.notes = '',
  });

  /// Creates an appointment from a JSON map.
  factory Appointment.fromJson(Map<String, dynamic> json) {
    try {
      final dateTime = DateTime.parse(json['date'] as String);
      final timeMap = json['time'] as Map<String, dynamic>;

      return Appointment(
        id: json['id'] as String,
        title: json['title'] as String,
        date: dateTime,
        time: TimeOfDay(
          hour: timeMap['hour'] as int,
          minute: timeMap['minute'] as int,
        ),
        notes: json['notes'] as String? ?? '',
      );
    } catch (e) {
      // Fallback to default values if parsing fails
      return Appointment(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        date: DateTime.now(),
        time: const TimeOfDay(hour: 8, minute: 0),
        notes: json['notes'] as String? ?? '',
      );
    }
  }

  /// Converts the appointment to a JSON map.
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'time': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'notes': notes,
    };
  }

  /// Creates a copy of the appointment with updated fields.
  ///
  /// Any parameter that is null will use the current value.
  Appointment copyWith({
    String? id,
    String? title,
    DateTime? date,
    TimeOfDay? time,
    String? notes,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      notes: notes ?? this.notes,
    );
  }

  /// Returns a DateTime that combines the date and time of this appointment.
  DateTime get dateTime {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}

/// Extension to convert DateTime to a date string key for event mapping.
extension DateTimeExtension on DateTime {
  String get dateString {
    return "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }
}
