import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import '../../controller/firebase_input_controller.dart';
import '../player/home_screen.dart';

class SimonGame extends StatefulWidget {
  @override
  _SimonGameState createState() => _SimonGameState();
}

class _SimonGameState extends State<SimonGame> {
  int round = 0;
  int userPosition = 0;
  int totalRounds = 100;
  List<int> sequence = [];
  int speed = 1000;
  bool blockedButtons = true;
  bool showingSequence = false;
  List<Color> buttonColors = [
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.green,
  ];
  List<bool> buttonStates = [false, false, false, false];
  bool disposed = false;
  String sequenceMessage = "Recuerda la siguiente secuencia";
  String userMessage = "Recrea la secuencia (0/0)";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    startGame();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("0E5BC2"),
                hexStringToColor("47b1c1"),
                hexStringToColor("76aee1")
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Simón Dice',
                    style: TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Ronda $round',
                    style: const TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(16.0),
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    children: [
                      buildSimonButton(0),
                      buildSimonButton(1),
                      buildSimonButton(2),
                      buildSimonButton(3),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    showingSequence ? sequenceMessage : userMessage,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSimonButton(int index) {
    return GestureDetector(
      onTapDown: (details) {
        if (!blockedButtons && !showingSequence) {
          setState(() {
            buttonStates[index] = true;
          });
          buttonClick(index);
        }
      },
      onTapUp: (details) {
        if (!blockedButtons && !showingSequence) {
          setState(() {
            buttonStates[index] = false;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: buttonStates[index] ? buttonColors[index] : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  void startGame() {
    round = 1;
    userPosition = 0;
    sequence = createSequence();
    blockedButtons = true;
    showingSequence = true;
    showSequenceAnimation();
  }

  void showSequenceAnimation() async {
    setState(() {
      sequenceMessage = "Recuerda la siguiente secuencia";
    });

    for (int i = 0; i < round; i++) {
      if (disposed) return;

      await Future.delayed(Duration(milliseconds: speed));
      if (disposed) return;

      setState(() {
        buttonStates[sequence[i]] = true;
      });
      await Future.delayed(Duration(milliseconds: speed));
      if (disposed) return;

      setState(() {
        buttonStates[sequence[i]] = false;
      });
    }

    setState(() {
      blockedButtons = false;
      showingSequence = false;
      userMessage = "Recrea la secuencia (0/$round)";
    });
  }

  void buttonClick(int buttonIndex) {
    if (buttonIndex == sequence[userPosition]) {
      userPosition++;

      if (userPosition == round) {
        userPosition = 0;
        round++;

        if (round > totalRounds) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('¡Felicidades!'),
              content: const Text('Has completado todas las rondas.'),
              actions: [
                TextButton(
                  onPressed: () {
                    FirebaseController.saveGameResult("simon", round);
                    Navigator.of(context).pop();
                    resetGame();
                  },
                  child: const Text('Jugar de nuevo'),
                ),
              ],
            ),
          );
          return;
        }

        blockedButtons = true;
        showingSequence = true;

        resetButtonStates();
        showSequenceAnimation();
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FirebaseController.saveGameResult("simon", round);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¡Perdiste!'),
            content: Text('Has presionado el botón incorrecto.\nPuntaje: $round'),
            actions: [

                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: const Text('Ir al Inicio'),
                ),

            ],
          ),
        );
      });
    }
    // ...

  setState(() {
      userMessage = "Recrea la secuencia ($userPosition/$round)";
    });
  }

  List<int> createSequence() {
    List<int> sequence = [];
    Random random = Random();
    for (int i = 0; i < totalRounds; i++) {
      sequence.add(random.nextInt(4));
    }
    return sequence;
  }

  Color hexStringToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  void resetButtonStates() {
    for (int i = 0; i < buttonStates.length; i++) {
      buttonStates[i] = false;
    }
  }

  void resetGame() {
    round = 0;
    userPosition = 0;
    blockedButtons = true;
    showingSequence = false;
    resetButtonStates();
    startGame();
  }
}
