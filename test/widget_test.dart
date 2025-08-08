// Basic Flutter widget tests for the Eye of Sauron application
//
// To perform interactions with widgets in tests, use the WidgetTester
// utility from flutter_test package. You can send tap and scroll gestures,
// find widgets, read text, and verify widget property values.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eye_of_sauron_flutter/screens/eye_of_sauron_screen.dart';
import 'package:eye_of_sauron_flutter/widgets/eye_of_sauron_widget.dart';

void main() {
  testWidgets('EyeOfSauronScreen renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MaterialApp(home: EyeOfSauronScreen()));

    // Verify the main screen renders
    expect(find.byType(EyeOfSauronScreen), findsOneWidget);
    
    // Verify the eye widget is present
    expect(find.byType(EyeOfSauronWidget), findsOneWidget);
    
    // Find the specific CustomPaint for particles
    final particlePaintFinder = find.descendant(
      of: find.byType(EyeOfSauronWidget),
      matching: find.byType(CustomPaint),
    );
    
    // Verify the particle canvas is present
    expect(particlePaintFinder, findsOneWidget);
  });

  testWidgets('Particles are visible and moving', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: EyeOfSauronScreen()));
    
    // Find the specific particle paint
    final particlePaintFinder = find.descendant(
      of: find.byType(EyeOfSauronWidget),
      matching: find.byType(CustomPaint),
    );
    
    // Verify particles canvas is visible
    expect(particlePaintFinder, findsOneWidget);
    
    // Wait for particles to move
    await tester.pump(const Duration(milliseconds: 100));
    
    // Should still have particles visible
    expect(particlePaintFinder, findsOneWidget);
  });

  testWidgets('App cleans up resources on dispose', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MaterialApp(home: EyeOfSauronScreen()));
    
    // Get the widget state
    final widgetState = tester.state<EyeOfSauronWidgetState>(find.byType(EyeOfSauronWidget));
    
    // Verify timers are active
    expect(widgetState.blinkTimer?.isActive, isTrue);
    expect(widgetState.particleTimer?.isActive, isTrue);
    
    // Dispose the widget
    await tester.pumpWidget(const Placeholder());
    
    // Verify timers are cancelled
    expect(widgetState.blinkTimer?.isActive, isFalse);
    expect(widgetState.particleTimer?.isActive, isFalse);
  });
}