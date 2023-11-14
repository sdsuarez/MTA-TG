import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../assets/images/memoryCard/prueba.dart'; // Asegúrate de importar el archivo correcto

void main() {
  testWidgets('Widget se inicializa sin errores', (WidgetTester tester) async {
    // Construye la aplicación y dispara un frame.
    await tester.pumpWidget(MaterialApp(
      home: MemoryGame(),
    ));

    // Asegúrate de que no haya errores y que la pantalla se inicie sin problemas.
    expect(tester.takeException(), isNull);
  });
}
