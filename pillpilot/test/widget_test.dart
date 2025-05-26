// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pillpilot/main.dart';
import 'package:pillpilot/pages/medications_page.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('MedicationsPage builds without errors', (WidgetTester tester) async {
    // Build the MedicationsPage and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: MedicationsPage(),
      ),
    );

    // Verify that the page builds without errors
    expect(find.byType(MedicationsPage), findsOneWidget);

    // Verify that the page contains text elements
    expect(find.text('Deine Einnahmen Heute'), findsOneWidget);
    expect(find.text('Übersicht aller heutigen Einnahmen'), findsOneWidget);

    // Verify that medication items are displayed
    expect(find.text('Ibuprofen'), findsOneWidget);
    expect(find.text('Aspirin'), findsOneWidget);
    expect(find.text('Paracetamol'), findsOneWidget);
  });
}
