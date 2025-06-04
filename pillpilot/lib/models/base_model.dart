/// Base class for all models in the application.
///
/// Provides a common base for all model classes.
abstract class BaseModel {
  // Common properties and methods for all models
}

/// Interface for models that can be converted to/from JSON.
///
/// Classes implementing this interface can be serialized to and from JSON.
abstract class JsonSerializable {
  /// Converts the model to a JSON map.
  Map<String, dynamic> toJson();

  // Factory constructor for creating model from JSON
  // This would be implemented by each model class
  // static T fromJson<T extends JsonSerializable>(Map<String, dynamic> json);
}

/// Interface for models that can be persisted in storage.
///
/// Extends [BaseModel] and implements [JsonSerializable] to provide
/// both base model functionality and JSON serialization.
abstract class Persistable extends BaseModel implements JsonSerializable {
  /// Unique identifier for the model.
  String get id;
}
