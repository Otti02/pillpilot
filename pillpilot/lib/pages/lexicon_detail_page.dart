import 'package:flutter/material.dart';
import '../models/lexicon_entry_model.dart';
import '../theme/app_theme.dart';

class LexiconDetailPage extends StatelessWidget {
  final LexiconEntry entry;

  const LexiconDetailPage({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppTheme.backgroundColor,
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
                  color: AppTheme.primaryTextColor,
                ),
              ),
              const SizedBox(height: 24),

              // Information card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.iconBackgroundColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type
                    _buildInfoSection(
                      title: 'Art',
                      content: entry.type,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    _buildInfoSection(
                      title: 'Informationen',
                      content: entry.description,
                    ),
                    const SizedBox(height: 16),

                    // Usage information
                    _buildInfoSection(
                      title: 'Einnahmeinformationen',
                      content: entry.usageInfo,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.secondaryTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
