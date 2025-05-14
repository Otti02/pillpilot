import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_calendar.dart';

/// A generic page that displays examples of a specific widget category.
class WidgetDetailPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> examples;

  const WidgetDetailPage({
    Key? key,
    required this.title,
    required this.examples,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                '$title Examples',
                style: AppTheme.headingStyle,
              ),
              const SizedBox(height: 8),
              Text(
                'Explore different variations of $title',
                style: AppTheme.bodyStyle,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: examples.length,
                  itemBuilder: (context, index) {
                    final example = examples[index];
                    return _buildExampleCard(context, example);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, Map<String, dynamic> example) {
    final exampleTitle = example['title'] as String;
    final description = example['description'] as String;

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exampleTitle,
            style: AppTheme.titleStyle,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTheme.bodyStyle,
          ),
          const SizedBox(height: 24),
          _buildWidgetExample(context, example),
        ],
      ),
    );
  }

  Widget _buildWidgetExample(BuildContext context, Map<String, dynamic> example) {
    // Determine which widget to display based on the category title
    switch (title.toLowerCase()) {
      case 'buttons':
        return _buildButtonExample(context, example);
      case 'cards':
        return _buildCardExample(context, example);
      case 'dialogs':
        return _buildDialogExample(context, example);
      case 'text fields':
        return _buildTextFieldExample(context, example);
      case 'images':
        return _buildImageExample(context, example);
      case 'calendar':
        return _buildCalendarExample(context, example);
      default:
        return const Text('Unknown widget category');
    }
  }

  Widget _buildButtonExample(BuildContext context, Map<String, dynamic> example) {
    final isOutlined = example['isOutlined'] as bool;
    final IconData? icon = example['icon'] as IconData?;
    final isLoading = example['isLoading'] as bool;
    final isDisabled = example['isDisabled'] as bool;

    return CustomButton(
      text: example['title'] as String,
      isOutlined: isOutlined,
      icon: icon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${example['title']} pressed'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  Widget _buildCardExample(BuildContext context, Map<String, dynamic> example) {
    final type = example['type'] as String;
    final content = example['content'] as Map<String, dynamic>;

    switch (type) {
      case 'basic':
        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content['title'] as String,
                style: AppTheme.titleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                content['description'] as String,
                style: AppTheme.bodyStyle,
              ),
            ],
          ),
        );
      case 'info':
        return InfoCard(
          title: content['title'] as String,
          subtitle: content['subtitle'] as String?,
          icon: content['icon'] as IconData?,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${content['title']} card tapped'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      case 'image':
        return ImageCard(
          title: content['title'] as String,
          description: content['description'] as String?,
          imageUrl: content['imageUrl'] as String?,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${content['title']} card tapped'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      default:
        return const Text('Unknown card type');
    }
  }

  Widget _buildDialogExample(BuildContext context, Map<String, dynamic> example) {
    final dialogTitle = example['dialogTitle'] as String;
    final dialogMessage = example['dialogMessage'] as String;
    final confirmText = example['confirmText'] as String?;
    final cancelText = example['cancelText'] as String?;
    final IconData? icon = example['icon'] as IconData?;
    final isDestructive = example['isDestructive'] as bool;

    return CustomButton(
      text: 'Show ${example['title']}',
      onPressed: () {
        showCustomDialog(
          context: context,
          title: dialogTitle,
          message: dialogMessage,
          confirmText: confirmText,
          cancelText: cancelText,
          icon: icon,
          isDestructive: isDestructive,
          onConfirm: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${example['title']} confirmed'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          onCancel: cancelText != null
              ? () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${example['title']} cancelled'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              : null,
        );
      },
    );
  }

  Widget _buildTextFieldExample(BuildContext context, Map<String, dynamic> example) {
    final type = example['type'] as String;
    final label = example['label'] as String?;
    final hint = example['hint'] as String?;
    final errorText = example['errorText'] as String?;
    final maxLines = example.containsKey('maxLines') ? example['maxLines'] as int : 1;

    switch (type) {
      case 'basic':
        return CustomTextField(
          label: label,
          hint: hint,
          errorText: errorText,
          maxLines: maxLines,
        );
      case 'password':
        return PasswordField(
          label: label,
          hint: hint,
          errorText: errorText,
        );
      case 'search':
        return SearchField(
          hint: hint ?? 'Search',
        );
      default:
        return const Text('Unknown text field type');
    }
  }

  Widget _buildImageExample(BuildContext context, Map<String, dynamic> example) {
    final type = example['type'] as String;

    switch (type) {
      case 'standard':
        return CustomImage(
          imageUrl: example['imageUrl'] as String?,
          assetPath: example['assetPath'] as String?,
          width: example['width'] as double?,
          height: example['height'] as double?,
          errorText: example.containsKey('errorText') ? example['errorText'] as String? : null,
        );
      case 'avatar':
        return Center(
          child: CircularAvatar(
            imageUrl: example['imageUrl'] as String?,
            size: example['size'] as double? ?? 48,
            initials: example.containsKey('initials') ? example['initials'] as String? : null,
          ),
        );
      default:
        return const Text('Unknown image type');
    }
  }

  Widget _buildCalendarExample(BuildContext context, Map<String, dynamic> example) {
    final type = example['type'] as String;

    switch (type) {
      case 'calendar':
        final showTodayButton = example['showTodayButton'] as bool;
        final showNavigationArrows = example['showNavigationArrows'] as bool;

        return CustomCalendar(
          showTodayButton: showTodayButton,
          showNavigationArrows: showNavigationArrows,
          onDateSelected: (date) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Selected date: ${date.toString().split(' ')[0]}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      case 'datePicker':
        return CustomButton(
          text: 'Show Date Picker',
          onPressed: () async {
            final selectedDate = await showDatePickerDialog(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );

            if (selectedDate != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected date: ${selectedDate.toString().split(' ')[0]}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
        );
      default:
        return const Text('Unknown calendar type');
    }
  }
}
