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

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.daysOfWeek,
    this.isCompleted = false,
    this.notes = '',
  });

  static TimeOfDay _timeOfDayFromString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      time: _timeOfDayFromString(json['time'] as String? ?? '08:00'),
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)?.cast<int>() ?? [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': '${time.hour}:${time.minute}',
      'daysOfWeek': daysOfWeek,
      'isCompleted': isCompleted,
      'notes': notes,
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
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}
