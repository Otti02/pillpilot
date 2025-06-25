import 'package:hive_flutter/hive_flutter.dart';



abstract class PersistenceService {
  Future<void> saveData(String key, dynamic data);

  Future<dynamic> getData(String key);

  Future<void> removeData(String key);

  Future<bool> containsKey(String key);
}

/// Implementation of persistence service using Hive database.
class HivePersistenceService  implements PersistenceService {
  static const String _boxName = 'pillpilot_data';

  late Box _box;

  static final HivePersistenceService _instance = HivePersistenceService._internal();

  factory HivePersistenceService() {
    return _instance;
  }

  HivePersistenceService._internal();

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


class ServiceFactory {
  static final ServiceFactory _instance = ServiceFactory._internal();

  factory ServiceFactory() {
    return _instance;
  }

  ServiceFactory._internal();

  PersistenceService getPersistenceService() {
    return HivePersistenceService();
  }
}
