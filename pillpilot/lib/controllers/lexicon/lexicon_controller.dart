import 'dart:async';
import '../../models/lexicon_entry_model.dart';
import '../../services/lexicon_service.dart';
import '../../services/service_provider.dart';

class LexiconController {
  final LexiconService _lexiconService;

  // Callbacks
  void Function(List<LexiconEntry>)? onEntriesLoaded;
  void Function(String)? onError;

  // Stream controller for lexicon entries
  final _entriesController = StreamController<List<LexiconEntry>>();
  Stream<List<LexiconEntry>> get entriesStream => _entriesController.stream;

  LexiconController({LexiconService? lexiconService})
      : _lexiconService = lexiconService ?? ServiceProvider().lexiconService;

  void initialize() {
    loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      final entries = await _lexiconService.getLexiconEntries();
      _entriesController.add(entries);

      if (onEntriesLoaded != null) {
        onEntriesLoaded!(entries);
      }
    } catch (e) {
      if (onError != null) {
        onError!(e.toString());
      }
    }
  }

  Future<LexiconEntry> getEntryById(String id) async {
    try {
      return await _lexiconService.getLexiconEntryById(id);
    } catch (e) {
      if (onError != null) {
        onError!(e.toString());
      }
      rethrow;
    }
  }

  Future<LexiconEntry> createEntry(
    String name,
    String type,
    String category,
    String description,
    String usageInfo,
  ) async {
    final entry = await _lexiconService.createLexiconEntry(
      name,
      type,
      category,
      description,
      usageInfo,
    );
    await loadEntries();
    return entry;
  }

  Future<LexiconEntry> updateEntry(LexiconEntry entry) async {
    final updatedEntry = await _lexiconService.updateLexiconEntry(entry);
    await loadEntries();
    return updatedEntry;
  }

  Future<void> deleteEntry(String id) async {
    await _lexiconService.deleteLexiconEntry(id);
    await loadEntries();
  }

  void dispose() {
    _entriesController.close();
  }
}
