import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../controller/firebase_input_controller.dart';
import '../player/home_screen.dart';

class CardData {
  final String image;

  CardData({required this.image});
}

class OrderAndRememberGame extends StatefulWidget {
  @override
  _OrderAndRememberGameState createState() => _OrderAndRememberGameState();
}

class _OrderAndRememberGameState extends State<OrderAndRememberGame> {
  List<CardData> cardSequence = [];
  List<CardData> userSequence = [];
  int currentLevel = 1;
  int sequenceLength = 2;
  int currentCardIndex = 0;
  bool isShowingSequence = true;
  bool isUserPlaying = false;

  List<CardData> allCards = [
    CardData(image: 'assets/images/memoryCard/banano.png'),
    CardData(image: 'assets/images/memoryCard/cereza.png'),
    CardData(image: 'assets/images/memoryCard/fresa.png'),
    CardData(image: 'assets/images/memoryCard/manzana.png'),
    CardData(image: 'assets/images/memoryCard/pina.png'),
    CardData(image: 'assets/images/memoryCard/sandia.png'),
  ];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentLevel = 1;
    sequenceLength = 2;
    cardSequence.clear();
    userSequence.clear();
    generateCardSequence();
    showCardSequence();
  }

  void generateCardSequence() {
    cardSequence.clear();
    for (int i = 0; i < sequenceLength; i++) {
      int randomIndex = Random().nextInt(allCards.length);
      cardSequence.add(allCards[randomIndex]);
    }
  }

  void showCardSequence() {
    setState(() {
      isShowingSequence = true;
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        isShowingSequence = false;
      });
      Timer(const Duration(seconds: 1), () {
        setState(() {
          isUserPlaying = true;
        });
      });
    });
  }

  void handleCardTap(CardData card) {
    if (isUserPlaying) {
      setState(() {
        userSequence.add(card);
        if (userSequence.length == sequenceLength) {
          checkSequence();
        }
      });
    }
  }

  void checkSequence() {
    bool isCorrect = true;
    for (int i = 0; i < sequenceLength; i++) {
      if (userSequence[i] != cardSequence[i]) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      setState(() {
        currentLevel++;
        userSequence.clear();
      });
      if (currentLevel % 2 == 0) {
        sequenceLength++;
      }
      generateCardSequence();
      showCardSequence();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          int score = currentLevel - 1;
          FirebaseController.saveGameResult("secuenciaOrden", score);
          return AlertDialog(
            title: const Text('¡Juego terminado!'),
            content: Text('Puntaje: $score'),
            actions: [

              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: const Text('Ir a Inicio'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      home: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0E5BC2),
                Color(0xFF47b1c1),
                Color(0xFF76aee1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nivel $currentLevel',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                if (isShowingSequence)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: cardSequence.map((card) {
                      return Image.asset(
                        card.image,
                        width: 100,
                        height: 100,
                      );
                    }).toList(),
                  ),
                if (!isShowingSequence && isUserPlaying)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: allCards.map((card) {
                      return GestureDetector(
                        onTap: () => handleCardTap(card),
                        child: Image.asset(
                          card.image,
                          width: 100,
                          height: 100,
                        ),
                      );
                    }).toList(),
                  ),

                if (!isShowingSequence && isUserPlaying)
                  Text(
                    'Taps: ${userSequence.length} / $sequenceLength',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

