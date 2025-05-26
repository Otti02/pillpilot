import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_calendar.dart';

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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Explore different variations of $title',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.secondaryTextColor,
                ),
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
    final exampleTitle = example['title'] as String? ?? 'Example';
    final description = example['description'] as String? ?? 'No description';

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exampleTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildWidgetExample(context, example),
        ],
      ),
    );
  }

  Widget _buildWidgetExample(BuildContext context, Map<String, dynamic> example) {
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
    final isOutlined = example['isOutlined'] as bool? ?? false;
    final isLoading = example['isLoading'] as bool? ?? false;

    return CustomButton(
      text: example['title'] as String? ?? 'Button',
      isOutlined: isOutlined,
      isLoading: isLoading,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${example['title'] ?? 'Button'} pressed'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  Widget _buildCardExample(BuildContext context, Map<String, dynamic> example) {
    final content = example['content'] as Map<String, dynamic>? ?? {};

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content['title'] as String? ?? 'Example Title',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content['description'] as String? ?? 'Example description',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.secondaryTextColor,
            ),
          ),
        ],
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${content['title'] ?? 'Card'} tapped'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  Widget _buildDialogExample(BuildContext context, Map<String, dynamic> example) {
    final dialogTitle = example['dialogTitle'] as String? ?? 'Dialog';
    final dialogMessage = example['dialogMessage'] as String? ?? 'This is a dialog message';
    final confirmText = example['confirmText'] as String?;
    final cancelText = example['cancelText'] as String?;

    return CustomButton(
      text: 'Show ${example['title'] ?? 'Dialog'}',
      onPressed: () {
        showCustomDialog(
          context: context,
          title: dialogTitle,
          message: dialogMessage,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirm: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${example['title'] ?? 'Dialog'} confirmed'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          onCancel: cancelText != null
              ? () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${example['title'] ?? 'Dialog'} cancelled'),
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
    final type = example['type'] as String? ?? 'basic';
    final label = example['label'] as String?;
    final hint = example['hint'] as String?;

    switch (type) {
      case 'basic':
      default:
        return CustomTextField(
          label: label,
          hint: hint,
          obscureText: type == 'password',
        );
    }
  }

  Widget _buildImageExample(BuildContext context, Map<String, dynamic> example) {
    final type = example['type'] as String? ?? 'standard';

    if (type == 'avatar') {
      return Center(
        child: CircularAvatar(
          imageUrl: example['imageUrl'] as String?,
          size: example['size'] as double? ?? 48,
          initials: example['initials'] as String?,
        ),
      );
    }

    return CustomImage(
      imageUrl: example['imageUrl'] as String?,
      assetPath: example['assetPath'] as String?,
      width: example['width'] as double?,
      height: example['height'] as double?,
    );
  }

  Widget _buildCalendarExample(BuildContext context, Map<String, dynamic> example) {
    final type = example['type'] as String? ?? 'calendar';

    if (type == 'datePicker') {
      return CustomButton(
        text: 'Show Date Picker',
        onPressed: () async {
          final selectedDate = await showDatePickerDialog(
            context: context,
            initialDate: DateTime.now(),
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
    }

    return CustomCalendar(
      onDateSelected: (date) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected date: ${date.toString().split(' ')[0]}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
