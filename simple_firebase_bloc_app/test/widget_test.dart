// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the
// widget tree, read text, and verify that the values of widget properties are
// correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simple_firebase_bloc_app/app.dart'; // <-- CORRECTED IMPORT

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: We cannot test the full app here easily because it requires
    // Firebase initialization. We'll just test that MyApp builds.
    await tester.pumpWidget(const MyApp());

    // Verify that our app shows the app bar title.
    expect(find.text('Firebase BLoC Notes'), findsOneWidget);

    // We won't test the counter functionality as it was removed.
    // We'll just confirm the floating action button exists.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
