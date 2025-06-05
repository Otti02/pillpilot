import 'base_model.dart';

/// Model representing a medication in the application.
///
/// Contains information about a medication including its name,
/// dosage, time of day to be taken, and optional notes.
class Medication extends BaseModel implements Persistable {
  /// Unique identifier for the medication.
  @override
  final String id;

  /// Name of the medication.
  final String name;

  /// Dosage information (e.g., "10mg").
  final String dosage;

  /// Time of day to take the medication (e.g., "Morning").
  final String timeOfDay;

  /// Whether the medication has been taken.
  final bool isCompleted;

  /// Optional notes about the medication.
  final String notes;

  /// Creates a new medication instance.
  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.timeOfDay,
    this.isCompleted = false,
    this.notes = '',
  });

  /// Creates a medication from a JSON map.
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      timeOfDay: json['timeOfDay'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
    );
  }

  /// Converts the medication to a JSON map.
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'timeOfDay': timeOfDay,
      'isCompleted': isCompleted,
      'notes': notes,
    };
  }

  /// Creates a copy of the medication with updated fields.
  ///
  /// Any parameter that is null will use the current value.
  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    String? timeOfDay,
    bool? isCompleted,
    String? notes,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}
