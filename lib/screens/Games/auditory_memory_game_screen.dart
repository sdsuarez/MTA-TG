import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../controller/firebase_input_controller.dart';
import '../player/home_screen.dart';

class CardData {
  final String image;
  final String sound;

  CardData({required this.image, required this.sound});
}

class AuditoryMemoryGame extends StatefulWidget {
  @override
  _AuditoryMemoryGameState createState() => _AuditoryMemoryGameState();
}

class _AuditoryMemoryGameState extends State<AuditoryMemoryGame> {
  List<CardData> cardSequence = [];
  List<CardData> userSequence = [];
  List<int> userTapsByLevel = [];
  int currentLevel = 1;
  int sequenceLength = 1;
  int currentCardIndex = 0;
  bool isShowingSequence = true;
  bool isUserPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  int audiosPlayed = 0;
  int audiosRemaining = 0;

  List<CardData> allCards = [
    CardData(
      image: 'assets/images/musicCard/bateria.png',
      sound: 'assets/audio/bateria.mp3',
    ),
    CardData(
      image: 'assets/images/musicCard/flauta.png',
      sound: 'assets/audio/flauta.mp3',
    ),
    CardData(
      image: 'assets/images/musicCard/guitarra.png',
      sound: 'assets/audio/guitarra.mp3',
    ),
    CardData(
      image: 'assets/images/musicCard/harpa.png',
      sound: 'assets/audio/harpa.mp3',
    ),
    CardData(
      image: 'assets/images/musicCard/piano.png',
      sound: 'assets/audio/piano.mp3',
    ),
    CardData(
      image: 'assets/images/musicCard/trompeta.png',
      sound: 'assets/audio/trompeta.mp3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentLevel = 1;
    sequenceLength = 1;
    cardSequence.clear();
    userSequence.clear();
    userTapsByLevel = List.generate(sequenceLength, (index) => 0);
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

  Future<void> playSound(String sound) async {
    String tempDir = (await getTemporaryDirectory()).path;
    String mp3FilePath = '$tempDir/music.mp3';

    ByteData? byteData = await rootBundle.load(sound);
    List<int> audioBytes = byteData.buffer.asUint8List();

    final file = File(mp3FilePath);
    await file.writeAsBytes(audioBytes);

    await audioPlayer.stop();
    await audioPlayer.setVolume(1.0);
    await audioPlayer.play(file.path, isLocal: true);
  }

  void showCardSequence() async {
    setState(() {
      isShowingSequence = true;
      audiosPlayed = 0;
      audiosRemaining = cardSequence.length;
    });

    for (int i = 0; i < cardSequence.length; i++) {
      setState(() {
        audiosPlayed = i + 1;
        audiosRemaining = cardSequence.length - i - 1;
      });
      await playSound(cardSequence[i].sound);
      await Future.delayed(const Duration(seconds: 1));
      if (audiosRemaining == 0) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    setState(() {
      isShowingSequence = false;
      audiosPlayed = 0;
      audiosRemaining = 0;
    });

    Timer(const Duration(seconds: 3), () {
      setState(() {
        isUserPlaying = true;
      });
    });
  }

  void handleCardTap(CardData card) {
    if (isUserPlaying) {
      setState(() {
        userSequence.add(card);
        userTapsByLevel[currentLevel - 1]++;
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
      userTapsByLevel.add(0);
      generateCardSequence();
      showCardSequence();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          int score = currentLevel - 1;
          FirebaseController.saveGameResult("auditivo", score);
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
                child: const Text('Ir al Inicio'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      'Reproduciendo: $audiosPlayed / ${cardSequence.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Faltan: $audiosRemaining',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
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
                const SizedBox(height: 20),
              if (!isShowingSequence && isUserPlaying)
                Text(
                  'Te faltan ${userTapsByLevel[currentLevel - 1]} taps/${cardSequence.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
