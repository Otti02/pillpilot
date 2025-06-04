import 'package:hive_flutter/hive_flutter.dart';

/// Base service class that all services should extend.
///
/// This is the root class for all services in the application.
abstract class BaseService {
  // No common methods defined at this level
}

/// Interface for persistence service that handles data storage.
abstract class PersistenceService extends BaseService {
  /// Saves data to persistent storage.
  Future<void> saveData(String key, dynamic data);

  /// Retrieves data from persistent storage.
  Future<dynamic> getData(String key);

  /// Removes data from persistent storage.
  Future<void> removeData(String key);

  /// Checks if a key exists in persistent storage.
  Future<bool> containsKey(String key);
}

/// Implementation of persistence service using Hive database.
class HivePersistenceService extends BaseService implements PersistenceService {
  /// Name of the Hive box used for storage.
  static const String _boxName = 'pillpilot_data';

  /// The Hive box instance for data storage.
  late Box _box;

  /// Singleton instance of the service.
  static final HivePersistenceService _instance = HivePersistenceService._internal();

  /// Factory constructor that returns the singleton instance.
  factory HivePersistenceService() {
    return _instance;
  }

  /// Internal constructor.
  HivePersistenceService._internal();

  /// Initializes the Hive database.
  ///
  /// Must be called before using any other methods.
  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  /// Checks if a key exists in the Hive box.
  @override
  Future<bool> containsKey(String key) async {
    return _box.containsKey(key);
  }

  /// Retrieves data from the Hive box by key.
  @override
  Future<dynamic> getData(String key) async {
    return _box.get(key);
  }

  /// Removes data from the Hive box by key.
  @override
  Future<void> removeData(String key) async {
    await _box.delete(key);
  }

  /// Saves data to the Hive box with the specified key.
  @override
  Future<void> saveData(String key, dynamic data) async {
    await _box.put(key, data);
  }
}

/// Factory for creating service instances.
///
/// Provides a centralized way to get service instances.
class ServiceFactory {
  /// Singleton instance of the factory.
  static final ServiceFactory _instance = ServiceFactory._internal();

  /// Factory constructor that returns the singleton instance.
  factory ServiceFactory() {
    return _instance;
  }

  /// Internal constructor.
  ServiceFactory._internal();

  /// Returns an instance of the persistence service.
  PersistenceService getPersistenceService() {
    return HivePersistenceService();
  }
}
