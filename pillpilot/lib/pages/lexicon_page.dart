import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../controllers/lexicon/lexicon_controller.dart';
import '../models/lexicon_entry_model.dart';
import '../models/lexicon_state_model.dart';
import '../theme/app_theme.dart';

import 'lexicon_detail_page.dart';

class LexiconPage extends StatelessWidget {
  const LexiconPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BlocProvider.of<LexiconController>(context);
    if (controller.state.entries.isEmpty) {
      controller.loadEntries();
    }

    return _LexiconPageContent();
  }
}

class _LexiconPageContent extends StatefulWidget {
  @override
  State<_LexiconPageContent> createState() => _LexiconPageContentState();
}

class _LexiconPageContentState extends State<_LexiconPageContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateSearchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<LexiconEntry> _filterEntries(List<LexiconEntry> entries) {
    if (_searchQuery.isEmpty) {
      return entries;
    }

    return entries.where((entry) {
      return entry.name.toLowerCase().contains(_searchQuery) ||
          entry.type.toLowerCase().contains(_searchQuery) ||
          entry.category.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  void _navigateToEntryDetail(LexiconEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => LexiconDetailPage(entry: entry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lexikon',
                        style: TextStyle(
                          fontSize: AppTheme.mainTitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: themeProvider.cardBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: themeProvider.borderColor),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            color: themeProvider.primaryTextColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Medikament / Supplement',
                            hintStyle: TextStyle(
                              color: themeProvider.secondaryTextColor,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppTheme.primaryColor,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<LexiconController, LexiconModel>(
                    builder: (context, model) {
                      if (model.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final filteredEntries = _filterEntries(model.entries);

                      if (filteredEntries.isEmpty) {
                        return Center(
                          child: Text(
                            'Keine Einträge gefunden',
                            style: TextStyle(
                              fontSize: AppTheme.subtitleFontSize,
                              color: themeProvider.secondaryTextColor,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredEntries.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final entry = filteredEntries[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: themeProvider.cardBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.shadowColor,
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: AppTheme.transparent,
                              child: InkWell(
                                onTap: () => _navigateToEntryDetail(entry),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      // Circle with first letter
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: AppTheme.iconBackgroundColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            entry.name
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Entry info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              entry.name,
                                              style: TextStyle(
                                                fontSize:
                                                    AppTheme.subtitleFontSize,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeProvider
                                                        .primaryTextColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              entry.category,
                                              style: TextStyle(
                                                fontSize:
                                                    AppTheme.smallFontSize,
                                                color:
                                                    themeProvider
                                                        .secondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
