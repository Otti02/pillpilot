import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pillpilot/widgets/custom_text_field.dart';
import 'package:pillpilot/theme/app_theme.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  group('CustomTextField', () {
    testWidgets('renders correctly with given label and hint', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      const labelText = 'Test Label';
      const hintText = 'Test Hint';
      await tester.pumpWidget(
        makeTestableWidget(
          const CustomTextField(label: labelText, hint: hintText),
        ),
      );

      // ASSERT
      expect(find.text(labelText), findsOneWidget);
      expect(find.text(hintText), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('does not show label when label is null', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      const hintText = 'Test Hint';
      await tester.pumpWidget(
        makeTestableWidget(const CustomTextField(hint: hintText)),
      );

      // ASSERT
      expect(find.text(hintText), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      // There should be no Text widget with a label
      expect(find.byType(Text), findsOneWidget); // Only the hint text
    });

    testWidgets('obscures text when obscureText is true', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      await tester.pumpWidget(
        makeTestableWidget(const CustomTextField(obscureText: true)),
      );

      // ASSERT
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('does not obscure text when obscureText is false', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      await tester.pumpWidget(
        makeTestableWidget(const CustomTextField(obscureText: false)),
      );

      // ASSERT
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isFalse);
    });

    testWidgets('uses provided controller', (WidgetTester tester) async {
      // ARRANGE
      final controller = TextEditingController(text: 'Initial Text');
      await tester.pumpWidget(
        makeTestableWidget(CustomTextField(controller: controller)),
      );

      // ASSERT
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller, controller);
      expect(controller.text, 'Initial Text');
    });

    testWidgets('calls onChanged when text changes', (
      WidgetTester tester,
    ) async {
      // ARRANGE
      String? changedText;
      await tester.pumpWidget(
        makeTestableWidget(
          CustomTextField(
            onChanged: (value) {
              changedText = value;
            },
          ),
        ),
      );

      // ACT
      await tester.enterText(find.byType(TextField), 'New Text');
      await tester.pump();

      // ASSERT
      expect(changedText, 'New Text');
    });
  });
}
