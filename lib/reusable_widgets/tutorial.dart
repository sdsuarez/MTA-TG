import 'package:flutter/material.dart';


import '../screens/Games/auditory_memory_game_screen.dart';
import '../screens/Games/memory_game_screen.dart';
import '../screens/Games/number_sequences_screen.dart';
import '../screens/Games/order_game_screen.dart';
import '../screens/Games/simon_game_screen.dart';
import '../screens/Games/words_association_game_screen.dart';
import '../utils/colors_utils.dart';

class TutoPage extends StatelessWidget {
  final int index;

  TutoPage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("0E5BC2"),
            hexStringToColor("47b1c1"),
            hexStringToColor("76aee1")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GameMessage(index: index),
              GameContinueButton(
                index: index,
                onContinue: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => getGameScreen(index),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getGameScreen(int index) {
    switch (index) {
      case 0:
        return MemoryGame();
      case 1:
        return AuditoryMemoryGame();
      case 2:
        return NumberSequencesGame();
      case 3:
        return StroopGamePage();
      case 4:
        return OrderAndRememberGame();
      case 5:
        return SimonGame();
      default:
        return Container();
    }
  }
}

class GameMessage extends StatelessWidget {
  final int index;

  GameMessage({required this.index});

  @override
  Widget build(BuildContext context) {
    String gameTitle;
    String gameMessage;

    switch (index) {
      case 0:
        gameTitle = 'Memorama';
        gameMessage = '¡Encuentra las 6 parejas de cada fruta, tienes 1 minuto!';
        break;
      case 1:
        gameTitle = 'Auditivo';
        gameMessage = 'Escucha atentamente los sonidos y acierta la secuencia de instrumentos.';
        break;
      case 2:
        gameTitle = 'MasterNúmeros';
        gameMessage = 'Recuerda las secuencias numericas y escribelas lo más rápido posible.';
        break;
      case 3:
        gameTitle = 'Stroop';
        gameMessage = 'Selecciona el color que indica el texto en la paleta de colores.';
        break;
      case 4:
        gameTitle = 'Orden y Recuerda';
        gameMessage = 'Recuerda el orden de las frutas y repítelo en el mismo orden.';
        break;
      case 5:
        gameTitle = 'Simón';
        gameMessage = 'Replica la secuencia de luces correctamente.';
        break;
      default:
        gameTitle = 'Juego';
        gameMessage = 'Mensaje genérico del juego';
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                gameTitle,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                gameMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GameContinueButton extends StatelessWidget {
  final int index;
  final VoidCallback onContinue;

  GameContinueButton({required this.index, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onContinue,
      child: Text('Continuar'),
    );
  }
}


