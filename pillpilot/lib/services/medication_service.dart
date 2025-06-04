import 'dart:async';
import 'dart:convert';
import 'package:pillpilot/models/medication_model.dart';
import 'package:pillpilot/services/base_service.dart';
import 'package:pillpilot/services/service_provider.dart';

/// Service for managing medications in the application.
abstract class MedicationService extends BaseService {
  /// Retrieves all medications.
  Future<List<Medication>> getMedications();

  /// Retrieves a medication by its ID.
  ///
  /// Throws an exception if the medication is not found.
  Future<Medication> getMedicationById(String id);

  /// Creates a new medication with the given details.
  Future<Medication> createMedication(String name, String dosage, String timeOfDay);

  /// Updates an existing medication.
  ///
  /// Throws an exception if the medication is not found.
  Future<Medication> updateMedication(Medication medication);

  /// Deletes a medication by its ID.
  ///
  /// Throws an exception if the medication is not found.
  Future<void> deleteMedication(String id);
}

/// Implementation of the [MedicationService] using local storage.
class MedicationServiceImpl extends BaseService implements MedicationService {
  /// Key used to store medications in persistent storage.
  static const String _medicationsKey = 'medications';

  /// Key used to store the next medication ID in persistent storage.
  static const String _nextIdKey = 'next_medication_id';

  /// Service used for data persistence.
  final PersistenceService _persistenceService;

  /// Next ID to be used for a new medication.
  int _nextId = 1;

  /// Singleton instance of the service.
  static final MedicationServiceImpl _instance = MedicationServiceImpl._internal(
    ServiceProvider().persistenceService,
  );

  /// Factory constructor that returns the singleton instance.
  factory MedicationServiceImpl() {
    return _instance;
  }

  /// Internal constructor that initializes the service.
  ///
  /// Initializes the next ID from storage or uses default value 1.
  MedicationServiceImpl._internal(this._persistenceService) {
    _initNextId();
  }

  /// Initializes the next ID from persistent storage.
  Future<void> _initNextId() async {
    final nextIdStr = await _persistenceService.getData(_nextIdKey);
    if (nextIdStr != null) {
      _nextId = int.parse(nextIdStr as String);
    }
  }

  @override
  Future<List<Medication>> getMedications() async {
    final data = await _persistenceService.getData(_medicationsKey);
    if (data == null) {
      return [];
    }

    final List<dynamic> medicationsJson = jsonDecode(data as String) as List<dynamic>;
    return medicationsJson
        .map((dynamic json) => Medication.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Medication> getMedicationById(String id) async {
    final medications = await getMedications();
    final medication = medications.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception('Medication not found'),
    );
    return medication;
  }

  @override
  Future<Medication> createMedication(String name, String dosage, String timeOfDay) async {
    final medications = await getMedications();

    // Generate a new ID for the medication
    final String id = _nextId.toString();
    _nextId++;

    // Persist the updated ID counter
    await _saveNextId();

    // Create the new medication object
    final Medication newMedication = Medication(
      id: id,
      name: name,
      dosage: dosage,
      timeOfDay: timeOfDay,
    );

    // Add to the list and save
    medications.add(newMedication);
    await _saveMedications(medications);

    return newMedication;
  }

  /// Saves the next ID to persistent storage.
  Future<void> _saveNextId() async {
    await _persistenceService.saveData(_nextIdKey, _nextId.toString());
  }

  @override
  Future<Medication> updateMedication(Medication medication) async {
    final medications = await getMedications();

    final index = medications.indexWhere((m) => m.id == medication.id);
    if (index == -1) {
      throw Exception('Medication not found');
    }

    medications[index] = medication;
    await _saveMedications(medications);

    return medication;
  }

  @override
  Future<void> deleteMedication(String id) async {
    final medications = await getMedications();

    final index = medications.indexWhere((m) => m.id == id);
    if (index == -1) {
      throw Exception('Medication not found');
    }

    medications.removeAt(index);
    await _saveMedications(medications);
  }

  /// Saves the list of medications to persistent storage.
  ///
  /// Converts each medication to JSON format before saving.
  Future<void> _saveMedications(List<Medication> medications) async {
    final medicationsJson = medications.map((m) => m.toJson()).toList();
    await _persistenceService.saveData(_medicationsKey, jsonEncode(medicationsJson));
  }
}
