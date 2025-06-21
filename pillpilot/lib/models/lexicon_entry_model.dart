import 'base_model.dart';

/// Model representing a lexicon entry in the application.
///
/// Contains information about a medication or supplement including its name,
/// type, category, description, and usage information.
class LexiconEntry extends BaseModel implements Persistable {
  /// Unique identifier for the lexicon entry.
  @override
  final String id;

  /// Name of the medication or supplement.
  final String name;

  /// Type of the entry (e.g., "Schmerzmittel", "Vitamin").
  final String type;

  /// Category of the entry (e.g., "Medikament", "Nahrungsergänzung").
  final String category;

  /// Description of the medication or supplement.
  final String description;

  /// Information about usage, dosage, etc.
  final String usageInfo;

  /// Creates a new lexicon entry instance.
  LexiconEntry({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.description,
    required this.usageInfo,
  });

  /// Creates a lexicon entry from a JSON map.
  factory LexiconEntry.fromJson(Map<String, dynamic> json) {
    return LexiconEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      usageInfo: json['usageInfo'] as String,
    );
  }

  /// Converts the lexicon entry to a JSON map.
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'category': category,
      'description': description,
      'usageInfo': usageInfo,
    };
  }

  /// Creates a copy of the lexicon entry with updated fields.
  ///
  /// Any parameter that is null will use the current value.
  LexiconEntry copyWith({
    String? id,
    String? name,
    String? type,
    String? category,
    String? description,
    String? usageInfo,
  }) {
    return LexiconEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      category: category ?? this.category,
      description: description ?? this.description,
      usageInfo: usageInfo ?? this.usageInfo,
    );
  }
}
