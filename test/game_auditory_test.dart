import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdapp/screens/Games/auditory_memory_game_screen.dart';

void main() {
  testWidgets('AuditoryMemoryGame initializes without errors',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: AuditoryMemoryGame(),
    ));

    // Expect that there are no errors and the game starts without crashing.
    expect(tester.takeException(), isNull);
  });

  testWidgets('Initial level is 1', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AuditoryMemoryGame(),
    ));

    final finder = find.text('Nivel 1');

    expect(finder, findsOneWidget);
  });

  testWidgets('Show "Reproduciendo: 1 / 1" initially',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AuditoryMemoryGame(),
    ));

    final finder = find.text('Reproduciendo: 1 / 1');

    expect(finder, findsOneWidget);
  });

  testWidgets('Show "Faltan: 0" initially', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AuditoryMemoryGame(),
    ));

    final finder = find.text('Faltan: 0');

    expect(finder, findsOneWidget);
  });
}
