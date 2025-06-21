import 'dart:async';
import 'dart:convert';
import '../models/lexicon_entry_model.dart';
import 'base_service.dart';
import 'service_provider.dart';

/// Service for managing lexicon entries in the application.
abstract class LexiconService extends BaseService {
  /// Retrieves all lexicon entries.
  Future<List<LexiconEntry>> getLexiconEntries();

  /// Retrieves a lexicon entry by its ID.
  ///
  /// Throws an exception if the entry is not found.
  Future<LexiconEntry> getLexiconEntryById(String id);

  /// Creates a new lexicon entry with the given details.
  Future<LexiconEntry> createLexiconEntry(
    String name,
    String type,
    String category,
    String description,
    String usageInfo,
  );

  /// Updates an existing lexicon entry.
  ///
  /// Throws an exception if the entry is not found.
  Future<LexiconEntry> updateLexiconEntry(LexiconEntry entry);

  /// Deletes a lexicon entry by its ID.
  ///
  /// Throws an exception if the entry is not found.
  Future<void> deleteLexiconEntry(String id);
}

/// Implementation of the [LexiconService] using local storage.
class LexiconServiceImpl extends BaseService implements LexiconService {
  /// Key used to store lexicon entries in persistent storage.
  static const String _entriesKey = 'lexicon_entries';

  /// Key used to store the next entry ID in persistent storage.
  static const String _nextIdKey = 'next_lexicon_entry_id';

  /// Service used for data persistence.
  final PersistenceService _persistenceService;

  /// Next ID to be used for a new entry.
  int _nextId = 1;

  /// Singleton instance of the service.
  static final LexiconServiceImpl _instance = LexiconServiceImpl._internal(
    ServiceProvider().persistenceService,
  );

  /// Factory constructor that returns the singleton instance.
  factory LexiconServiceImpl() {
    return _instance;
  }

  /// Internal constructor that initializes the service.
  ///
  /// Initializes the next ID from storage or uses default value 1.
  LexiconServiceImpl._internal(this._persistenceService) {
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
  Future<List<LexiconEntry>> getLexiconEntries() async {
    final data = await _persistenceService.getData(_entriesKey);
    if (data == null) {
      return _createInitialEntries();
    }

    final List<dynamic> entriesJson = jsonDecode(data as String) as List<dynamic>;
    return entriesJson
        .map((dynamic json) => LexiconEntry.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Creates initial lexicon entries if none exist.
  Future<List<LexiconEntry>> _createInitialEntries() async {
    final entries = <LexiconEntry>[
      await createLexiconEntry(
        'Ibuprofen',
        'Schmerzmittel',
        'Medikament',
        'Ibuprofen ist ein schmerzlinderndes, fiebersenkendes und entzündungshemmendes Medikament aus der Gruppe der nicht-steroidalen Antirheumatika (NSAR).',
        'Übliche Dosierung: 200-400mg alle 4-6 Stunden. Maximale Tagesdosis: 1200mg. Mit ausreichend Flüssigkeit einnehmen. Nicht länger als 3 Tage ohne ärztliche Rücksprache einnehmen.',
      ),
      await createLexiconEntry(
        'Vitamin B12',
        'Vitamin',
        'Nahrungsergänzung',
        'Vitamin B12 ist ein wasserlösliches Vitamin, das für die Blutbildung, Nervenfunktion und DNA-Synthese wichtig ist.',
        'Übliche Dosierung: 2,5-100µg täglich. Mit einer Mahlzeit einnehmen für bessere Aufnahme.',
      ),
      await createLexiconEntry(
        'Selen',
        'Spurenelement',
        'Nahrungsergänzung',
        'Selen ist ein essentielles Spurenelement, das als Antioxidans wirkt und für die Funktion des Immunsystems wichtig ist.',
        'Übliche Dosierung: 50-200µg täglich. Die Einnahme sollte nicht die empfohlene Tagesdosis überschreiten.',
      ),
      await createLexiconEntry(
        'Novalgin',
        'Schmerzmittel',
        'Medikament',
        'Novalgin (Metamizol) ist ein starkes Schmerzmittel mit fiebersenkender und krampflösender Wirkung.',
        'Übliche Dosierung: 500-1000mg bis zu 4x täglich. Maximale Tagesdosis: 4000mg. Mit ausreichend Flüssigkeit einnehmen. Nur nach ärztlicher Verschreibung anwenden.',
      ),
      await createLexiconEntry(
        'Kreatin',
        'Aminosäure',
        'Nahrungsergänzung',
        'Kreatin ist eine körpereigene Substanz, die zur Energieversorgung der Muskeln beiträgt und in der Sportnahrung verwendet wird.',
        'Übliche Dosierung: 3-5g täglich. Mit ausreichend Wasser einnehmen. Kann in Ladephasen (20g/Tag für 5-7 Tage) und Erhaltungsphasen (3-5g/Tag) eingenommen werden.',
      ),
    ];

    return entries;
  }

  @override
  Future<LexiconEntry> getLexiconEntryById(String id) async {
    final entries = await getLexiconEntries();
    final entry = entries.firstWhere(
      (e) => e.id == id,
      orElse: () => throw Exception('Lexicon entry not found'),
    );
    return entry;
  }

  @override
  Future<LexiconEntry> createLexiconEntry(
    String name,
    String type,
    String category,
    String description,
    String usageInfo,
  ) async {
    final entries = await getLexiconEntries();

    // Generate a new ID for the entry
    final String id = _nextId.toString();
    _nextId++;

    // Persist the updated ID counter
    await _saveNextId();

    // Create the new entry object
    final LexiconEntry newEntry = LexiconEntry(
      id: id,
      name: name,
      type: type,
      category: category,
      description: description,
      usageInfo: usageInfo,
    );

    // Add to the list and save
    entries.add(newEntry);
    await _saveEntries(entries);

    return newEntry;
  }

  /// Saves the next ID to persistent storage.
  Future<void> _saveNextId() async {
    await _persistenceService.saveData(_nextIdKey, _nextId.toString());
  }

  @override
  Future<LexiconEntry> updateLexiconEntry(LexiconEntry entry) async {
    final entries = await getLexiconEntries();

    final index = entries.indexWhere((e) => e.id == entry.id);
    if (index == -1) {
      throw Exception('Lexicon entry not found');
    }

    entries[index] = entry;
    await _saveEntries(entries);

    return entry;
  }

  @override
  Future<void> deleteLexiconEntry(String id) async {
    final entries = await getLexiconEntries();

    final index = entries.indexWhere((e) => e.id == id);
    if (index == -1) {
      throw Exception('Lexicon entry not found');
    }

    entries.removeAt(index);
    await _saveEntries(entries);
  }

  /// Saves the list of entries to persistent storage.
  ///
  /// Converts each entry to JSON format before saving.
  Future<void> _saveEntries(List<LexiconEntry> entries) async {
    final entriesJson = entries.map((e) => e.toJson()).toList();
    await _persistenceService.saveData(_entriesKey, jsonEncode(entriesJson));
  }
}
