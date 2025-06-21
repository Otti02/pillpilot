import 'package:flutter_test/flutter_test.dart';
import 'package:pillpilot/services/lexicon_service.dart';
import 'package:pillpilot/services/service_provider.dart';

void main() {
  group('LexiconService Tests', () {
    late LexiconService lexiconService;

    setUp(() {
      // Initialize the service before each test
      lexiconService = LexiconServiceImpl();
    });

    test('getLexiconEntries should not cause infinite recursion', () async {
      // This test verifies that getLexiconEntries doesn't cause an infinite recursion
      // which would lead to an out-of-memory error
      final entries = await lexiconService.getLexiconEntries();
      
      // Verify that we got some entries
      expect(entries, isNotEmpty);
      
      // Verify that the initial entries are created correctly
      expect(entries.length, greaterThanOrEqualTo(5));
      
      // Check that the first entry is Ibuprofen
      final ibuprofenEntry = entries.firstWhere(
        (entry) => entry.name == 'Ibuprofen',
        orElse: () => throw Exception('Ibuprofen entry not found'),
      );
      expect(ibuprofenEntry.type, equals('Schmerzmittel'));
      expect(ibuprofenEntry.category, equals('Medikament'));
    });

    test('createLexiconEntry should create a new entry without infinite recursion', () async {
      // Create a new entry
      final newEntry = await lexiconService.createLexiconEntry(
        'Test Medication',
        'Test Type',
        'Test Category',
        'Test Description',
        'Test Usage Info',
      );
      
      // Verify the entry was created correctly
      expect(newEntry.name, equals('Test Medication'));
      expect(newEntry.type, equals('Test Type'));
      expect(newEntry.category, equals('Test Category'));
      expect(newEntry.description, equals('Test Description'));
      expect(newEntry.usageInfo, equals('Test Usage Info'));
      
      // Verify the entry was added to the list
      final entries = await lexiconService.getLexiconEntries();
      final foundEntry = entries.firstWhere(
        (entry) => entry.id == newEntry.id,
        orElse: () => throw Exception('New entry not found'),
      );
      expect(foundEntry.name, equals('Test Medication'));
    });
  });
}