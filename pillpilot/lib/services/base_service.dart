import 'package:hive_flutter/hive_flutter.dart';

/// Interface for persistence operations
abstract class PersistenceService {
  /// Initialize the persistence service
  Future<void> initialize();

  Future<void> saveData(String key, dynamic data);
  Future<dynamic> getData(String key);
  Future<void> removeData(String key);
  Future<bool> containsKey(String key);
}

/// Implementation of persistence service using Hive database
class HivePersistenceService implements PersistenceService {
  static const String _boxName = 'pillpilot_data';
  late Box<dynamic> _box;

  /// Initialize Hive and open the data box
  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  @override
  Future<bool> containsKey(String key) async {
    return _box.containsKey(key);
  }

  @override
  Future<dynamic> getData(String key) async {
    return _box.get(key);
  }

  @override
  Future<void> removeData(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> saveData(String key, dynamic data) async {
    await _box.put(key, data);
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = '']);
  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;
  ValidationException([this.message = '']);
  @override
  String toString() => 'ValidationException: $message';
}

class AppException implements Exception {
  final String message;
  AppException([this.message = '']);
  @override
  String toString() => 'AppException: $message';
}
