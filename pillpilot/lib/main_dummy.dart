import 'package:flutter/material.dart';

/// This file contains dummy data for widgets demonstration.
class DummyData {
  // Button examples
  static final buttonExamples = [
    {
      'title': 'Primary Button',
      'description': 'Standard button with primary color',
      'isOutlined': false,
      'icon': null,
      'isLoading': false,
      'isDisabled': false,
    },
    {
      'title': 'Outlined Button',
      'description': 'Button with outline style',
      'isOutlined': true,
      'icon': null,
      'isLoading': false,
      'isDisabled': false,
    },
    {
      'title': 'Icon Button',
      'description': 'Button with an icon',
      'isOutlined': false,
      'icon': Icons.add,
      'isLoading': false,
      'isDisabled': false,
    },
    {
      'title': 'Loading Button',
      'description': 'Button in loading state',
      'isOutlined': false,
      'icon': null,
      'isLoading': true,
      'isDisabled': false,
    },
    {
      'title': 'Disabled Button',
      'description': 'Button in disabled state',
      'isOutlined': false,
      'icon': null,
      'isLoading': false,
      'isDisabled': true,
    },
    {
      'title': 'Disabled Outlined Button',
      'description': 'Outlined button in disabled state',
      'isOutlined': true,
      'icon': null,
      'isLoading': false,
      'isDisabled': true,
    },
  ];

  // Card examples
  static final cardExamples = [
    {
      'title': 'Basic Card',
      'description': 'A simple card with title and description',
      'type': 'basic',
      'content': {
        'title': 'Card Title',
        'description': 'This is a description for the card. It can contain multiple lines of text to demonstrate how the card handles longer content.',
      },
    },
    {
      'title': 'Info Card',
      'description': 'Card with icon and information',
      'type': 'info',
      'content': {
        'title': 'Information Card',
        'subtitle': 'This card displays information with an icon',
        'icon': Icons.info_outline,
      },
    },
    {
      'title': 'Image Card',
      'description': 'Card with image, title and description',
      'type': 'image',
      'content': {
        'title': 'Image Card Title',
        'description': 'This card displays an image with title and description',
        'imageUrl': 'https://picsum.photos/300/200',
      },
    },
    {
      'title': 'Long Text Card',
      'description': 'Card with very long text content',
      'type': 'basic',
      'content': {
        'title': 'Long Text Example',
        'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      },
    },
  ];

  // Dialog examples
  static final dialogExamples = [
    {
      'title': 'Basic Dialog',
      'description': 'A simple dialog with title and message',
      'dialogTitle': 'Information',
      'dialogMessage': 'This is a basic dialog with a message and a button.',
      'confirmText': 'OK',
      'cancelText': null,
      'icon': Icons.info_outline,
      'isDestructive': false,
    },
    {
      'title': 'Confirmation Dialog',
      'description': 'Dialog asking for confirmation',
      'dialogTitle': 'Confirm Action',
      'dialogMessage': 'Are you sure you want to perform this action?',
      'confirmText': 'Confirm',
      'cancelText': 'Cancel',
      'icon': Icons.help_outline,
      'isDestructive': false,
    },
    {
      'title': 'Error Dialog',
      'description': 'Dialog showing an error message',
      'dialogTitle': 'Error Occurred',
      'dialogMessage': 'Something went wrong. Please try again later.',
      'confirmText': 'OK',
      'cancelText': null,
      'icon': Icons.error_outline,
      'isDestructive': true,
    },
    {
      'title': 'Success Dialog',
      'description': 'Dialog showing a success message',
      'dialogTitle': 'Success',
      'dialogMessage': 'Operation completed successfully!',
      'confirmText': 'Great',
      'cancelText': null,
      'icon': Icons.check_circle_outline,
      'isDestructive': false,
    },
  ];

  // TextField examples
  static final textFieldExamples = [
    {
      'title': 'Basic Text Field',
      'description': 'A simple text field for input',
      'type': 'basic',
      'label': 'Input Label',
      'hint': 'Enter text here',
      'errorText': null,
    },
    {
      'title': 'Text Field with Error',
      'description': 'Text field showing an error state',
      'type': 'basic',
      'label': 'Email',
      'hint': 'Enter your email',
      'errorText': 'Please enter a valid email address',
    },
    {
      'title': 'Password Field',
      'description': 'Text field for password input with visibility toggle',
      'type': 'password',
      'label': 'Password',
      'hint': 'Enter your password',
      'errorText': null,
    },
    {
      'title': 'Search Field',
      'description': 'Text field optimized for search functionality',
      'type': 'search',
      'hint': 'Search...',
    },
    {
      'title': 'Multiline Text Field',
      'description': 'Text field that supports multiple lines of text',
      'type': 'basic',
      'label': 'Description',
      'hint': 'Enter a detailed description',
      'errorText': null,
      'maxLines': 5,
    },
  ];

  // Image examples
  static final imageExamples = [
    {
      'title': 'Network Image',
      'description': 'Image loaded from a URL',
      'type': 'standard',
      'imageUrl': 'https://picsum.photos/400/300',
      'assetPath': null,
      'width': 300.0,
      'height': 200.0,
    },
    {
      'title': 'Asset Image',
      'description': 'Image loaded from assets',
      'type': 'standard',
      'imageUrl': null,
      'assetPath': 'assets/design/img.png',
      'width': 300.0,
      'height': 200.0,
    },
    {
      'title': 'Circular Avatar',
      'description': 'Circular image for user avatars',
      'type': 'avatar',
      'imageUrl': 'https://picsum.photos/200',
      'size': 80.0,
    },
    {
      'title': 'Avatar with Initials',
      'description': 'Avatar showing initials when no image is available',
      'type': 'avatar',
      'imageUrl': null,
      'initials': 'JD',
      'size': 80.0,
    },
    {
      'title': 'Image with Error',
      'description': 'Image with invalid URL to show error state',
      'type': 'standard',
      'imageUrl': 'https://invalid-url.jpg',
      'assetPath': null,
      'width': 300.0,
      'height': 200.0,
      'errorText': 'Failed to load image',
    },
  ];

  // Calendar examples
  static final calendarExamples = [
    {
      'title': 'Basic Calendar',
      'description': 'A simple calendar for date selection',
      'type': 'calendar',
      'showTodayButton': true,
      'showNavigationArrows': true,
    },
    {
      'title': 'Calendar without Today Button',
      'description': 'Calendar without the Today button',
      'type': 'calendar',
      'showTodayButton': false,
      'showNavigationArrows': true,
    },
    {
      'title': 'Calendar without Navigation',
      'description': 'Calendar without navigation arrows',
      'type': 'calendar',
      'showTodayButton': true,
      'showNavigationArrows': false,
    },
    {
      'title': 'Date Picker Dialog',
      'description': 'Dialog for selecting a date',
      'type': 'datePicker',
    },
  ];

  // List of all widget categories
  static final widgetCategories = [
    {
      'title': 'Buttons',
      'icon': Icons.touch_app,
      'description': 'Various button styles and states',
      'examples': buttonExamples,
    },
    {
      'title': 'Cards',
      'icon': Icons.credit_card,
      'description': 'Different card layouts and designs',
      'examples': cardExamples,
    },
    {
      'title': 'Dialogs',
      'icon': Icons.chat_bubble_outline,
      'description': 'Modal dialogs for various purposes',
      'examples': dialogExamples,
    },
    {
      'title': 'Text Fields',
      'icon': Icons.text_fields,
      'description': 'Input fields for text and data entry',
      'examples': textFieldExamples,
    },
    {
      'title': 'Images',
      'icon': Icons.image,
      'description': 'Image display components and avatars',
      'examples': imageExamples,
    },
    {
      'title': 'Calendar',
      'icon': Icons.calendar_today,
      'description': 'Calendar and date picker components',
      'examples': calendarExamples,
    },
  ];

  // Sample long text for testing text overflow
  static const String loremIpsum = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
}
