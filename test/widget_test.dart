// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodappp/pages/onboarding.dart';
import 'package:foodappp/pages/login.dart';

void main() {
  testWidgets('Onboarding navigates to Login screen on button tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Onboarding(),
        routes: {
          '/login': (context) => const LogIn(),
        },
      ),
    );

    // Check the onboarding screen content.
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('The Fastest\nFood Delivery'), findsOneWidget);

    // Tap the button
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle(); // wait for animations/navigation

    // Expect to find the Login screen
    expect(find.byType(LogIn), findsOneWidget);
  });
}
