import '../../models/lexicon_entry_model.dart';
import '../../models/lexicon_state_model.dart';
import '../../services/lexicon_service.dart';
import '../../services/service_provider.dart';
import '../../services/base_service.dart';

import '../base_controller.dart';

class LexiconController extends BlocController<LexiconModel> {
  final LexiconService lexiconService;

  LexiconController({LexiconService? lexiconService})
    : lexiconService =
          lexiconService ?? ServiceProvider.instance.lexiconService,
      super(LexiconModel(entries: []));

  @override
  void handleError(String message, [Object? error]) {
    if (error is NetworkException) {
    } else if (error is ValidationException) {
    } else if (error is AppException) {
    } else {
    }
    emit(state.copyWith(isLoading: false));
  }

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
      handleError('Failed to load lexicon entries: ${e.toString()}', e);
    }
  }

  Future<LexiconEntry> getEntryById(String id) async {
    try {
      return await lexiconService.getLexiconEntryById(id);
    } catch (e) {
      handleError('Failed to get lexicon entry by id: ${e.toString()}', e);
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
    try {
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
    } catch (e) {
      handleError('Failed to create lexicon entry: ${e.toString()}', e);
      rethrow;
    }
  }

  Future<LexiconEntry> updateEntry(LexiconEntry entry) async {
    try {
      emit(state.copyWith(isLoading: true));
      final updatedEntry = await lexiconService.updateLexiconEntry(entry);
      await loadEntries();
      return updatedEntry;
    } catch (e) {
      handleError('Failed to update lexicon entry: ${e.toString()}', e);
      rethrow;
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      emit(state.copyWith(isLoading: true));
      await lexiconService.deleteLexiconEntry(id);
      await loadEntries();
    } catch (e) {
      handleError('Failed to delete lexicon entry: ${e.toString()}', e);
      rethrow;
    }
  }
}
