import 'package:flutter/material.dart';
import 'package:pillpilot/theme/app_theme.dart';
import 'package:pillpilot/widgets/custom_button.dart';

/// A custom dialog widget that can be styled in different ways.
class CustomDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final IconData? icon;
  final Color? iconColor;
  final bool showCloseButton;

  const CustomDialog({
    Key? key,
    required this.title,
    this.message,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.icon,
    this.iconColor,
    this.showCloseButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCloseButton)
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close,
                  color: AppTheme.secondaryTextColor,
                  size: 24,
                ),
              ),
            ),
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (iconColor ?? (isDestructive ? AppTheme.errorColor : AppTheme.primaryColor)).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor ?? (isDestructive ? AppTheme.errorColor : AppTheme.primaryColor),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: AppTheme.titleStyle,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: AppTheme.bodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
          if (content != null) ...[
            const SizedBox(height: 16),
            content!,
          ],
          const SizedBox(height: 24),
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    if (confirmText == null && cancelText == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (cancelText != null)
          Expanded(
            child: CustomButton(
              text: cancelText!,
              isOutlined: true,
              onPressed: onCancel ?? () => Navigator.of(context).pop(false),
            ),
          ),
        if (confirmText != null && cancelText != null)
          const SizedBox(width: 12),
        if (confirmText != null)
          Expanded(
            child: CustomButton(
              text: confirmText!,
              backgroundColor: isDestructive ? AppTheme.errorColor : null,
              onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
            ),
          ),
      ],
    );
  }
}

/// Shows a custom dialog with the given parameters.
Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required String title,
  String? message,
  Widget? content,
  String? confirmText,
  String? cancelText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool isDestructive = false,
  IconData? icon,
  Color? iconColor,
  bool showCloseButton = true,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return CustomDialog(
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
        icon: icon,
        iconColor: iconColor,
        showCloseButton: showCloseButton,
      );
    },
  );
}

/// Shows a confirmation dialog with the given parameters.
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  String? message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool isDestructive = false,
  IconData? icon,
}) {
  return showCustomDialog<bool>(
    context: context,
    title: title,
    message: message,
    confirmText: confirmText,
    cancelText: cancelText,
    isDestructive: isDestructive,
    icon: icon ?? (isDestructive ? Icons.warning_amber_rounded : Icons.help_outline_rounded),
    iconColor: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
  );
}

/// Shows an error dialog with the given parameters.
Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
}) {
  return showCustomDialog(
    context: context,
    title: title,
    message: message,
    confirmText: buttonText,
    icon: Icons.error_outline_rounded,
    iconColor: AppTheme.errorColor,
  );
}

/// Shows a success dialog with the given parameters.
Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  String? message,
  String buttonText = 'OK',
}) {
  return showCustomDialog(
    context: context,
    title: title,
    message: message,
    confirmText: buttonText,
    icon: Icons.check_circle_outline_rounded,
    iconColor: AppTheme.successColor,
  );
}