import 'package:pillpilot/models/lexicon_entry_model.dart';

class LexiconModel {
  final List<LexiconEntry> entries;
  
  final bool isLoading;
  
  LexiconModel({
    required this.entries,
    this.isLoading = false,
  });

  LexiconModel copyWith({
    List<LexiconEntry>? entries,
    bool? isLoading,
  }) {
    return LexiconModel(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}