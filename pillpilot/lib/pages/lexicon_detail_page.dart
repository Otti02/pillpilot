import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lexicon_entry_model.dart';
import '../theme/app_theme.dart';

class LexiconDetailPage extends StatelessWidget {
  final LexiconEntry entry;

  const LexiconDetailPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medication name
                  Text(
                    entry.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Information card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          themeProvider.isDarkMode
                              ? themeProvider.cardBackgroundColor
                              : AppTheme.iconBackgroundColor.withValues(
                                alpha: 0.5,
                              ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type
                        _buildInfoSection(
                          title: 'Art',
                          content: entry.type,
                          themeProvider: themeProvider,
                        ),
                        const SizedBox(height: 16),

                        // Description
                        _buildInfoSection(
                          title: 'Informationen',
                          content: entry.description,
                          themeProvider: themeProvider,
                        ),
                        const SizedBox(height: 16),

                        // Usage information
                        _buildInfoSection(
                          title: 'Einnahmeinformationen',
                          content: entry.usageInfo,
                          themeProvider: themeProvider,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection({
    required String title,
    required String content,
    required ThemeProvider themeProvider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color:
                themeProvider.isDarkMode
                    ? themeProvider.primaryTextColor
                    : themeProvider.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color:
                themeProvider.isDarkMode
                    ? themeProvider.primaryTextColor
                    : themeProvider.secondaryTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
