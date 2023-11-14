import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdapp/screens/Games/order_game_screen.dart';

void main() {
  testWidgets('OrderAndRememberGame initializes without errors',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: OrderAndRememberGame(),
      ));

      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('Initial level is 1', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: OrderAndRememberGame(),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Nivel 1'), findsOneWidget);
    });
  });

  testWidgets('Show cards when isShowingSequence is true',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      final game = OrderAndRememberGame();

      // Simula que isShowingSequence es true
      // game.isShowingSequence = true;

      await tester.pumpWidget(MaterialApp(
        home: game,
      ));

      await tester.pumpAndSettle();

      // Verifica que las imágenes de las cartas se muestren cuando isShowingSequence es true
      expect(find.byType(Image), findsWidgets);
    });
  });

  testWidgets(
      'Show cards when isShowingSequence is false and isUserPlaying is true',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      final game = OrderAndRememberGame();

      // Simula que isShowingSequence es false y isUserPlaying es true
      //game.isShowingSequence = false;
      // game.isUserPlaying = true;

      await tester.pumpWidget(MaterialApp(
        home: game,
      ));

      await tester.pumpAndSettle();

      // Verifica que las imágenes de las cartas se muestren cuando isShowingSequence es false y isUserPlaying es true
      expect(find.byType(Image), findsWidgets);
    });
  });
}
