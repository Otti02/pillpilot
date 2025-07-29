import '../../models/lexicon_entry_model.dart';
import '../../models/lexicon_state_model.dart';
import '../../services/lexicon_service.dart';
import '../../services/service_provider.dart';
import '../base_controller.dart';

class LexiconController extends BlocController<LexiconModel> {
  final LexiconService lexiconService;

  LexiconController({LexiconService? lexiconService})
      : lexiconService = lexiconService ?? ServiceProvider.instance.lexiconService,
        super(LexiconModel(entries: []));

  @override
  Future<void> initialize() async {
    await loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      emit(state.copyWith(isLoading: true));
      final entries = await lexiconService.getLexiconEntries();
      emit(state.copyWith(entries: entries, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Error handling could be improved here
    }
  }

  Future<LexiconEntry> getEntryById(String id) async {
    try {
      return await lexiconService.getLexiconEntryById(id);
    } catch (e) {
      // Error handling could be improved here
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
    emit(state.copyWith(isLoading: true));
    final entry = await lexiconService.createLexiconEntry(
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
    emit(state.copyWith(isLoading: true));
    final updatedEntry = await lexiconService.updateLexiconEntry(entry);
    await loadEntries();
    return updatedEntry;
  }

  Future<void> deleteEntry(String id) async {
    emit(state.copyWith(isLoading: true));
    await lexiconService.deleteLexiconEntry(id);
    await loadEntries();
  }
}
