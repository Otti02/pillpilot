import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../main_dummy.dart';

/// A page that displays all available widgets with buttons to navigate to their detail pages.
class WidgetsOverviewPage extends StatelessWidget {
  const WidgetsOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Gallery'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'UI Components',
                style: AppTheme.headingStyle,
              ),
              const SizedBox(height: 8),
              Text(
                'Explore our collection of reusable UI components',
                style: AppTheme.bodyStyle,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: DummyData.widgetCategories.length,
                  itemBuilder: (context, index) {
                    final category = DummyData.widgetCategories[index];
                    return _buildCategoryCard(context, category);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    final title = category['title'] as String;
    final icon = category['icon'] as IconData;
    final description = category['description'] as String;
    final examples = category['examples'] as List<Map<String, dynamic>>;

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.titleStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTheme.bodyStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${examples.length} examples',
            style: AppTheme.subtitleStyle.copyWith(
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'View Examples',
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/widget_detail/${title.toLowerCase().replaceAll(' ', '_')}',
                arguments: {
                  'title': title,
                  'examples': examples,
                },
              );
            },
          ),
        ],
      ),
    );
  }
}