import 'package:flutter/material.dart';
import 'base_model.dart';

class Appointment extends BaseModel implements Persistable {
  @override
  final String id;

  final String title;

  final DateTime date;

  final TimeOfDay time;

  final String notes;

  Appointment({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    this.notes = '',
  });

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
      return Appointment(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        date: DateTime.now(),
        time: const TimeOfDay(hour: 8, minute: 0),
        notes: json['notes'] as String? ?? '',
      );
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'time': {'hour': time.hour, 'minute': time.minute},
      'notes': notes,
    };
  }

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

  DateTime get dateTime {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

extension DateTimeExtension on DateTime {
  String get dateString {
    return "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }
}
