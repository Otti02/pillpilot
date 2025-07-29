import 'package:flutter/material.dart';
import 'base_model.dart';

class Medication extends BaseModel implements Persistable {
  @override
  final String id;

  final String name;

  final String dosage;

  final TimeOfDay time;

  final List<int> daysOfWeek;

  final bool isCompleted;

  final String notes;

  final bool enableReminders;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.daysOfWeek,
    this.isCompleted = false,
    this.notes = '',
    this.enableReminders = true,
  });

  static TimeOfDay _timeOfDayFromString(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) {
        throw FormatException('Invalid time format. Expected HH:MM, got: $timeString');
      }
      
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      
      if (hour == null || minute == null) {
        throw FormatException('Invalid time values. Expected numbers, got: $timeString');
      }
      
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        throw FormatException('Time out of range. Hour: 0-23, Minute: 0-59, got: $timeString');
      }
      
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      // Fallback to default time if parsing fails
      return const TimeOfDay(hour: 8, minute: 0);
    }
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    TimeOfDay time;
    try {
      if (json['time'] is Map<String, dynamic>) {
        // New format: time as map
        final timeMap = json['time'] as Map<String, dynamic>;
        time = TimeOfDay(
          hour: timeMap['hour'] as int,
          minute: timeMap['minute'] as int,
        );
      } else if (json['time'] is String) {
        // Legacy format: time as string (HH:MM)
        time = _timeOfDayFromString(json['time'] as String);
      } else {
        // Fallback to default
        time = const TimeOfDay(hour: 8, minute: 0);
      }
    } catch (e) {
      // Fallback to default time if parsing fails
      time = const TimeOfDay(hour: 8, minute: 0);
    }

    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      time: time,
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)?.cast<int>() ?? [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      enableReminders: json['enableReminders'] as bool? ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'daysOfWeek': daysOfWeek,
      'isCompleted': isCompleted,
      'notes': notes,
      'enableReminders': enableReminders,
    };
  }

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    TimeOfDay? time,
    List<int>? daysOfWeek,
    bool? isCompleted,
    String? notes,
    bool? enableReminders,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      enableReminders: enableReminders ?? this.enableReminders,
    );
  }
}
