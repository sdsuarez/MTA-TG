import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdapp/screens/Games/words_association_game_screen.dart';

void main() {
  // Prueba la función getColorFromWord
  test('getColorFromWord devuelve el color correcto', () {
    expect(getColorFromWord('rojo'), equals(Colors.red));
    expect(getColorFromWord('verde'), equals(Colors.green));
    expect(getColorFromWord('amarillo'), equals(Colors.yellow));
    expect(getColorFromWord('naranja'), equals(Colors.orange));
    expect(getColorFromWord('morado'), equals(Colors.purple));
    expect(getColorFromWord('marrón'), equals(Colors.brown));
  });
}
