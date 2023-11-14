import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/firebase_input_controller.dart';
import '../player/home_screen.dart';

class CardData {
  final String image;
  bool isFlipped;

  CardData({required this.image, this.isFlipped = false});
}

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final List<CardData> _cards = [
    CardData(image: 'assets/images/memoryCard/banano.png'),
    CardData(image: 'assets/images/memoryCard/cereza.png'),
    CardData(image: 'assets/images/memoryCard/fresa.png'),
    CardData(image: 'assets/images/memoryCard/manzana.png'),
    CardData(image: 'assets/images/memoryCard/pina.png'),
    CardData(image: 'assets/images/memoryCard/sandia.png'),
    CardData(image: 'assets/images/memoryCard/banano.png'),
    CardData(image: 'assets/images/memoryCard/cereza.png'),
    CardData(image: 'assets/images/memoryCard/fresa.png'),
    CardData(image: 'assets/images/memoryCard/manzana.png'),
    CardData(image: 'assets/images/memoryCard/pina.png'),
    CardData(image: 'assets/images/memoryCard/sandia.png'),
  ];

  List<CardData> _shuffledCards = [];
  final List<CardData> _selectedCards = [];
  final List<CardData> _foundPairs = [];
  bool _gameComplete = false;

  int _gameDuration = 60;
  bool _timerExpired = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _shuffledCards = List.of(_cards);
    _shuffledCards.shuffle();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_gameComplete) {
          _timer.cancel();
        } else if (_gameDuration > 0) {
          _gameDuration--;
        } else {
          _timer.cancel();
          _timerExpired = true;
          _gameComplete = true;
          _showLoseDialog();
        }
      });
    });
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
        body: Builder(
          builder: (BuildContext context) {
            ScreenUtil.init(context);

            return Container(
              width: double.infinity,
              height: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TimerWidget(
                            durationInSeconds: _gameDuration,
                            onTimerExpired: () {
                              setState(() {
                                _timerExpired = true;
                                _gameComplete = true;
                              });
                              FirebaseController.saveGameResult("memorama",_foundPairs.length ~/ 2);
                              _showLoseDialog();
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                              child: Text(
                                " Encontrados: ${_foundPairs.length ~/ 2} de ${_cards.length ~/ 2} parejas",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(15),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(26)),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 3 / 4,
                            crossAxisCount: 3,
                          ),
                          itemCount: _shuffledCards.length,
                          itemBuilder: (context, index) {
                            final cardData = _shuffledCards[index];
                            return InkWell(
                              onTap: _timerExpired || _gameComplete || _selectedCards.contains(cardData)
                                  ? null
                                  : () {
                                _flipCard(cardData);
                              },
                              child: Card(
                                color: cardData.isFlipped ? Colors.white : Colors.transparent,
                                child: cardData.isFlipped ? Image.asset(cardData.image) : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _flipCard(CardData card) {
    if (!_foundPairs.contains(card)) {
      setState(() {
        card.isFlipped = true;
        _selectedCards.add(card);

        if (_selectedCards.length == 2) {
          if (_selectedCards[0].image == _selectedCards[1].image) {
            _foundPairs.addAll(_selectedCards);
            _selectedCards.clear();

            if (_foundPairs.length == _shuffledCards.length) {
              _gameComplete = true;
              _timer.cancel();
              FirebaseController.saveGameResult("memorama",_foundPairs.length ~/ 2 * (_gameDuration > 0 ? _gameDuration : 1));
              _showWinDialog();

            }
          } else {
            Timer(const Duration(milliseconds: 300), () {
              _selectedCards.forEach((card) => card.isFlipped = false);
              _selectedCards.clear();
            });
          }
        }
      });
    }
  }


  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Felicidades!'),
          content: const Text('Has ganado el juego.'),
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

  void _showLoseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Tiempo agotado!'),
          content: const Text('Mejor suerte la próxima vez.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
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

class TimerWidget extends StatelessWidget {
  final int durationInSeconds;
  final VoidCallback onTimerExpired;

  TimerWidget({
    required this.durationInSeconds,
    required this.onTimerExpired,
  });

  @override
  Widget build(BuildContext context) {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;

    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      child: Text(
        'Tiempo restante: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        style: TextStyle(
          color: Colors.white,
          fontSize: ScreenUtil().setSp(19),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}