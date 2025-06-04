import 'base_model.dart';

/// Model representing a medication in the application.
///
/// Contains information about a medication including its name,
/// dosage, and time of day to be taken.
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

  /// Creates a new medication instance.
  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.timeOfDay,
    this.isCompleted = false,
  });

  /// Creates a medication from a JSON map.
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      timeOfDay: json['timeOfDay'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
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
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
