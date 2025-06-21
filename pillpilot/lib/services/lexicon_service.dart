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
    final entries = entriesJson
        .map((dynamic json) => LexiconEntry.fromJson(json as Map<String, dynamic>))
        .toList();

    if (entries.length < 18) {
      return _migrateToNewEntries(entries);
    }

    return entries;
  }

  Future<List<LexiconEntry>> _migrateToNewEntries(List<LexiconEntry> existingEntries) async {
    final allEntries = await _createInitialEntries();

    final userEntries = existingEntries.where((entry) {
      final id = int.tryParse(entry.id) ?? 0;
      return id > 18;
    }).toList();

    final finalEntries = [...allEntries, ...userEntries];

    if (userEntries.isNotEmpty) {
      final maxId = userEntries.map((e) => int.tryParse(e.id) ?? 0).reduce((a, b) => a > b ? a : b);
      if (maxId >= _nextId) {
        _nextId = maxId + 1;
        await _saveNextId();
      }
    }

    await _saveEntries(finalEntries);

    return finalEntries;
  }

  Future<List<LexiconEntry>> _createInitialEntries() async {
    final entries = <LexiconEntry>[
      // Medikamente
      LexiconEntry(
        id: '1',
        name: 'Ibuprofen',
        type: 'Schmerzmittel',
        category: 'Medikament',
        description: 'Ibuprofen ist ein schmerzlinderndes, fiebersenkendes und entzündungshemmendes Medikament aus der Gruppe der nicht-steroidalen Antirheumatika (NSAR).',
        usageInfo: 'Übliche Dosierung: 200-400mg alle 4-6 Stunden. Maximale Tagesdosis: 1200mg. Mit ausreichend Flüssigkeit einnehmen. Nicht länger als 3 Tage ohne ärztliche Rücksprache einnehmen.',
      ),
      LexiconEntry(
        id: '2',
        name: 'Paracetamol',
        type: 'Schmerzmittel',
        category: 'Medikament',
        description: 'Paracetamol ist ein schmerzlinderndes und fiebersenkendes Medikament, das bei leichten bis mäßigen Schmerzen und Fieber eingesetzt wird.',
        usageInfo: 'Übliche Dosierung: 500-1000mg alle 4-6 Stunden. Maximale Tagesdosis: 4000mg. Nicht länger als 3 Tage ohne ärztliche Rücksprache einnehmen.',
      ),
      LexiconEntry(
        id: '3',
        name: 'ASS (Aspirin)',
        type: 'Schmerzmittel',
        category: 'Medikament',
        description: 'Acetylsalicylsäure wirkt schmerzlindernd, fiebersenkend, entzündungshemmend und blutverdünnend.',
        usageInfo: 'Übliche Dosierung: 500-1000mg alle 4-6 Stunden. Maximale Tagesdosis: 3000mg. Mit viel Flüssigkeit und nach dem Essen einnehmen. Nicht bei Kindern unter 12 Jahren.',
      ),
      LexiconEntry(
        id: '4',
        name: 'Novalgin',
        type: 'Schmerzmittel',
        category: 'Medikament',
        description: 'Novalgin (Metamizol) ist ein starkes Schmerzmittel mit fiebersenkender und krampflösender Wirkung.',
        usageInfo: 'Übliche Dosierung: 500-1000mg bis zu 4x täglich. Maximale Tagesdosis: 4000mg. Mit ausreichend Flüssigkeit einnehmen. Nur nach ärztlicher Verschreibung anwenden.',
      ),
      LexiconEntry(
        id: '5',
        name: 'Omeprazol',
        type: 'Magenschutz',
        category: 'Medikament',
        description: 'Omeprazol ist ein Protonenpumpenhemmer, der die Magensäureproduktion reduziert und bei Sodbrennen, Magenschleimhautentzündung und Magengeschwüren eingesetzt wird.',
        usageInfo: 'Übliche Dosierung: 20-40mg einmal täglich vor dem Frühstück. Kapsel ganz schlucken, nicht zerkauen. Behandlungsdauer nach ärztlicher Anweisung.',
      ),
      LexiconEntry(
        id: '6',
        name: 'Cetirizin',
        type: 'Antihistaminikum',
        category: 'Medikament',
        description: 'Cetirizin ist ein Antihistaminikum zur Behandlung von allergischen Reaktionen wie Heuschnupfen, Nesselsucht und allergischem Asthma.',
        usageInfo: 'Übliche Dosierung: 10mg einmal täglich, vorzugsweise abends. Bei Kindern entsprechend reduziert. Mit ausreichend Flüssigkeit einnehmen.',
      ),
      LexiconEntry(
        id: '7',
        name: 'Diclofenac',
        type: 'Schmerzmittel',
        category: 'Medikament',
        description: 'Diclofenac ist ein entzündungshemmendes Schmerzmittel aus der Gruppe der NSAR, besonders wirksam bei Gelenkschmerzen und Entzündungen.',
        usageInfo: 'Übliche Dosierung: 25-50mg 2-3x täglich. Maximale Tagesdosis: 150mg. Mit dem Essen einnehmen. Nur kurzfristig ohne ärztliche Überwachung.',
      ),

      // Nahrungsergänzungsmittel
      LexiconEntry(
        id: '8',
        name: 'Vitamin D3',
        type: 'Vitamin',
        category: 'Nahrungsergänzung',
        description: 'Vitamin D3 (Cholecalciferol) ist wichtig für die Knochengesundheit, das Immunsystem und die Muskelkraft. Wird hauptsächlich durch Sonnenlicht in der Haut gebildet.',
        usageInfo: 'Übliche Dosierung: 800-2000 I.E. (20-50µg) täglich. Mit einer fetthaltigen Mahlzeit einnehmen für bessere Aufnahme. Regelmäßige Blutkontrollen empfehlenswert.',
      ),
      LexiconEntry(
        id: '9',
        name: 'Vitamin B12',
        type: 'Vitamin',
        category: 'Nahrungsergänzung',
        description: 'Vitamin B12 ist ein wasserlösliches Vitamin, das für die Blutbildung, Nervenfunktion und DNA-Synthese wichtig ist.',
        usageInfo: 'Übliche Dosierung: 2,5-100µg täglich. Mit einer Mahlzeit einnehmen für bessere Aufnahme.',
      ),
      LexiconEntry(
        id: '10',
        name: 'Omega-3',
        type: 'Fettsäure',
        category: 'Nahrungsergänzung',
        description: 'Omega-3-Fettsäuren (EPA und DHA) sind essentielle Fettsäuren, die wichtig für Herz, Gehirn und Augen sind.',
        usageInfo: 'Übliche Dosierung: 1000-2000mg täglich (mit mindestens 250mg EPA+DHA). Mit einer Mahlzeit einnehmen. Auf Qualität und Reinheit achten.',
      ),
      LexiconEntry(
        id: '11',
        name: 'Magnesium',
        type: 'Mineralstoff',
        category: 'Nahrungsergänzung',
        description: 'Magnesium ist ein essentieller Mineralstoff für Muskelfunktion, Nervensystem, Energiestoffwechsel und Knochengesundheit.',
        usageInfo: 'Übliche Dosierung: 200-400mg täglich. Aufgeteilt auf mehrere Dosen einnehmen. Mit ausreichend Flüssigkeit. Abends kann es entspannend wirken.',
      ),
      LexiconEntry(
        id: '12',
        name: 'Zink',
        type: 'Spurenelement',
        category: 'Nahrungsergänzung',
        description: 'Zink ist ein essentielles Spurenelement für Immunsystem, Wundheilung, Haut, Haare und Nägel.',
        usageInfo: 'Übliche Dosierung: 10-15mg täglich. Auf nüchternen Magen oder zwischen den Mahlzeiten einnehmen. Nicht zusammen mit Kalzium oder Eisen.',
      ),
      LexiconEntry(
        id: '13',
        name: 'Vitamin C',
        type: 'Vitamin',
        category: 'Nahrungsergänzung',
        description: 'Vitamin C (Ascorbinsäure) ist wichtig für das Immunsystem, die Kollagenbildung und wirkt als Antioxidans.',
        usageInfo: 'Übliche Dosierung: 100-1000mg täglich. Aufgeteilt auf mehrere Dosen für bessere Verträglichkeit. Mit viel Flüssigkeit einnehmen.',
      ),
      LexiconEntry(
        id: '14',
        name: 'Selen',
        type: 'Spurenelement',
        category: 'Nahrungsergänzung',
        description: 'Selen ist ein essentielles Spurenelement, das als Antioxidans wirkt und für die Funktion des Immunsystems wichtig ist.',
        usageInfo: 'Übliche Dosierung: 50-200µg täglich. Die Einnahme sollte nicht die empfohlene Tagesdosis überschreiten.',
      ),
      LexiconEntry(
        id: '15',
        name: 'Folsäure',
        type: 'Vitamin',
        category: 'Nahrungsergänzung',
        description: 'Folsäure (Vitamin B9) ist wichtig für die Zellteilung, Blutbildung und besonders in der Schwangerschaft für die Entwicklung des Kindes.',
        usageInfo: 'Übliche Dosierung: 400-800µg täglich. Besonders wichtig vor und während der Schwangerschaft. Mit oder ohne Mahlzeit einnehmen.',
      ),
      LexiconEntry(
        id: '16',
        name: 'Kreatin',
        type: 'Aminosäure',
        category: 'Nahrungsergänzung',
        description: 'Kreatin ist eine körpereigene Substanz, die zur Energieversorgung der Muskeln beiträgt und in der Sportnahrung verwendet wird.',
        usageInfo: 'Übliche Dosierung: 3-5g täglich. Mit ausreichend Wasser einnehmen. Kann in Ladephasen (20g/Tag für 5-7 Tage) und Erhaltungsphasen (3-5g/Tag) eingenommen werden.',
      ),
      LexiconEntry(
        id: '17',
        name: 'Probiotika',
        type: 'Bakterienkulturen',
        category: 'Nahrungsergänzung',
        description: 'Probiotika sind lebende Mikroorganismen, die die Darmflora unterstützen und sich positiv auf die Verdauung und das Immunsystem auswirken können.',
        usageInfo: 'Übliche Dosierung: 1-10 Milliarden KBE täglich. Auf nüchternen Magen oder zu den Mahlzeiten. Kühl lagern, wenn erforderlich.',
      ),
      LexiconEntry(
        id: '18',
        name: 'Eisen',
        type: 'Spurenelement',
        category: 'Nahrungsergänzung',
        description: 'Eisen ist essentiell für die Blutbildung, den Sauerstofftransport und die Energieproduktion im Körper.',
        usageInfo: 'Übliche Dosierung: 10-20mg täglich. Auf nüchternen Magen mit Vitamin C für bessere Aufnahme. Nicht mit Kaffee, Tee oder Milchprodukten einnehmen.',
      ),
    ];

    // Update the next ID to be after our manually created entries
    _nextId = 19;
    await _saveNextId();

    // Save the entries to storage
    await _saveEntries(entries);

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