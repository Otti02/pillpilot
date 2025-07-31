import 'base_model.dart';

class LexiconEntry extends BaseModel implements Persistable {
  @override
  final String id;

  final String name;

  final String type;

  final String category;

  final String description;

  final String usageInfo;

  LexiconEntry({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.description,
    required this.usageInfo,
  });

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
