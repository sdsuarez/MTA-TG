import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import '../../controller/firebase_input_controller.dart';
import '../player/home_screen.dart';

class StroopGamePage extends StatefulWidget {
  @override
  _StroopGamePageState createState() => _StroopGamePageState();
}

class _StroopGamePageState extends State<StroopGamePage> {
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.brown,
  ];
  List<String> wordList = [
    'Rojo',
    'Verde',
    'Amarillo',
    'Naranja',
    'Morado',
    'Marrón',
  ];

  List<Color> shuffledColors = [];
  late List<String> shuffledWords;
  late int currentIndex;
  late Color currentColor;
  late String currentWord;
  late int previousIndex;
  late int score;
  late int totalAttempts;
  late Timer timer;
  int secondsRemaining = 60;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      score = 0;
      secondsRemaining=60;
      totalAttempts = 0;
      shuffledColors = shuffleList(colorList);
      shuffledWords = shuffleList(wordList);
      currentIndex = 0;
      previousIndex = -1;
      generateRandomWord();
      isGameOver = false;
    });
  }

  void generateRandomWord() {
    setState(() {
      currentIndex = getRandomIndex();
      currentWord = shuffledWords[currentIndex];
      currentColor = getColorFromWord(currentWord);
    });
  }

  int getRandomIndex() {
    Random random = Random();
    int newIndex = random.nextInt(shuffledWords.length);
    if (newIndex == previousIndex) {

      return getRandomIndex();
    }
    previousIndex = newIndex;
    return newIndex;
  }

  void handleColorSelection(Color selectedColor) {
    if (!isGameOver) {
      setState(() {
        totalAttempts++;

        if (selectedColor == currentColor) {
          score++;
        }

        generateRandomWord();
        shuffledColors = shuffleList(colorList);
        shuffledWords = shuffleList(wordList);
      });
    }
  }

  List<T> shuffleList<T>(List<T> list) {
    Random random = Random();
    List<T> shuffledList = List.from(list);
    shuffledList.shuffle(random);
    return shuffledList;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
          showScoreDialog();
        }
      });
    });
  }

  void showScoreDialog() {
    setState(() {
      isGameOver = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        FirebaseController.saveGameResult("stroop", score);
        return AlertDialog(
          title: const Text('Tiempo agotado'),
          content: Text('Puntaje: $score/$totalAttempts'),
          actions: <Widget>[

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

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
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
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              formatTime(secondsRemaining),
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  '¡Selecciona el color que dice el texto!',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20.0),
                                Container(
                                  width: 200.0,
                                  height: 200.0,
                                  decoration: BoxDecoration(
                                    color: shuffledColors[currentIndex],
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      currentWord,
                                      style: const TextStyle(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    for (var color in shuffledColors)
                                      ColorButton(
                                        color: color,
                                        onPressed: isGameOver
                                            ? null
                                            : () =>
                                            handleColorSelection(color),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Text(
                                  'Puntaje: $score/$totalAttempts',
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

Color getColorFromWord(String word) {
  switch (word.toLowerCase()) {
    case 'rojo':
      return Colors.red;
    case 'verde':
      return Colors.green;
    case 'amarillo':
      return Colors.yellow;
    case 'naranja':
      return Colors.orange;
    case 'morado':
      return Colors.purple;
    case 'marrón':
      return Colors.brown;
    default:
      return Colors.black;
  }
}

class ColorButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onPressed;

  const ColorButton({
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(20.0),
      ),
      onPressed: onPressed,
      child: SizedBox.shrink(),
    );
  }
}
