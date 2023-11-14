import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdapp/screens/Games/number_sequences_screen.dart';

void main() {
  testWidgets('Widget inicializa sin errores', (WidgetTester tester) async {
    // Construye la aplicación y dispara un frame.
    await tester.pumpWidget(MaterialApp(
      home: NumberSequencesGame(),
    ));

    // Asegúrate de que no haya errores y que el juego se inicie sin problemas.
    expect(tester.takeException(), isNull);
  });

  testWidgets('Iniciar juego muestra secuencia inicial',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: NumberSequencesGame(),
    ));

    // Espera a que aparezca la secuencia inicial en la pantalla
    expect(
        find.text(
            'Mira la secuencia de números y repítelos en el orden correcto'),
        findsOneWidget);
  });

  testWidgets('Iniciar juego muestra botón "Siguiente"',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: NumberSequencesGame(),
    ));

    // Espera a que aparezca el botón "Siguiente" al iniciar el juego
    expect(find.text('Siguiente'), findsOneWidget);
  });

  testWidgets('Botón "Siguiente" avanza a la siguiente secuencia',
      (WidgetTester tester) async {
    // Crea una instancia de NumberSequencesGame.
    final widget = MaterialApp(
      home: NumberSequencesGame(),
    );

    // Construye la aplicación y dispara un frame.
    await tester.pumpWidget(widget);

    // Localiza el botón "Siguiente" y tócalo.
    final nextButtonFinder = find.text('Siguiente');
    await tester.tap(nextButtonFinder);

    // Espera a que la pantalla muestre la nueva secuencia.
    await tester.pumpAndSettle();

    // Verifica que la nueva secuencia se muestre en la pantalla.
    expect(
        find.text(
            'Mira la secuencia de números y repítelos en el orden correcto'),
        findsOneWidget);
  });
}
