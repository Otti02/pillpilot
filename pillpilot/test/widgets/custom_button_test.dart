import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pillpilot/widgets/custom_button.dart';
import 'package:pillpilot/theme/app_theme.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('CustomButton', () {
    testWidgets('renders correctly with given text', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      const buttonText = 'Test Button';
      await tester.pumpWidget(
        makeTestableWidget(CustomButton(text: buttonText, onPressed: () {})),
      );

      // ASSERT
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders as elevated button when isOutlined is false', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'Test Button',
            onPressed: () {},
            isOutlined: false,
          ),
        ),
      );

      // ASSERT
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('renders as outlined button when isOutlined is true', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(text: 'Test Button', onPressed: () {}, isOutlined: true),
        ),
      );

      // ASSERT
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(text: 'Test Button', onPressed: () {}, isLoading: true),
        ),
      );

      // ASSERT
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('calls onPressed when button is tapped', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      bool buttonPressed = false;
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'Test Button',
            onPressed: () {
              buttonPressed = true;
            },
          ),
        ),
      );

      // ACT
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // ASSERT
      expect(buttonPressed, isTrue);
    });

    testWidgets('uses custom color when provided', (WidgetTester tester) async {
      // ARRANGE
      const customColor = Colors.red;
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'Test Button',
            onPressed: () {},
            color: customColor,
          ),
        ),
      );

      // ASSERT
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style as ButtonStyle;
      final backgroundColor = buttonStyle.backgroundColor?.resolve({});
      expect(backgroundColor, customColor);
    });

    testWidgets('uses theme color when no custom color is provided', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      await tester.pumpWidget(
        makeTestableWidget(CustomButton(text: 'Test Button', onPressed: () {})),
      );

      // ASSERT
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style as ButtonStyle;
      final backgroundColor = buttonStyle.backgroundColor?.resolve({});
      expect(backgroundColor, AppTheme.primaryColor);
    });
  });
}
