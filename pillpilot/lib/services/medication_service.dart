import 'dart:async';
import 'dart:convert';
import 'package:pillpilot/models/medication_model.dart';
import 'package:pillpilot/services/base_service.dart';
import 'package:pillpilot/services/service_provider.dart';
abstract class MedicationService {

  Future<List<Medication>> getMedications();

  Future<Medication> getMedicationById(String id);

  Future<Medication> createMedication(String name, String dosage, String timeOfDay, {String notes = ''});

  Future<Medication> updateMedication(Medication medication);


  Future<void> deleteMedication(String id);
}

class MedicationServiceImpl implements MedicationService {
  static const String _medicationsKey = 'medications';

  static const String _nextIdKey = 'next_medication_id';

  final PersistenceService _persistenceService;

  int _nextId = 1;

  static final MedicationServiceImpl _instance = MedicationServiceImpl._internal(
    ServiceProvider().persistenceService,
  );

  factory MedicationServiceImpl() {
    return _instance;
  }

  MedicationServiceImpl._internal(this._persistenceService) {
    _initNextId();
  }

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
  Future<Medication> createMedication(String name, String dosage, String timeOfDay, {String notes = ''}) async {
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
      notes: notes,
    );

    // Add to the list and save
    medications.add(newMedication);
    await _saveMedications(medications);

    return newMedication;
  }

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

  Future<void> _saveMedications(List<Medication> medications) async {
    final medicationsJson = medications.map((m) => m.toJson()).toList();
    await _persistenceService.saveData(_medicationsKey, jsonEncode(medicationsJson));
  }
}
