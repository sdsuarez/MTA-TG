import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../controller/firebase_input_controller.dart';
import '../player/home_screen.dart';

class NumberSequencesGame extends StatefulWidget {
  @override
  _NumberSequencesGameState createState() => _NumberSequencesGameState();
}

class _NumberSequencesGameState extends State<NumberSequencesGame> {
  String _gameStatus = 'Presiona el botón para iniciar el juego';
  String _userAnswer = '';
  List<int> _numberSequence = [];
  bool _showSequence = true;
  int _currentNumberIndex = 0;
  int _numDigits = 4;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  bool _isGameStarted = false;
  late Timer _timer;
  int _countdown = 3;
  int _elapsedSeconds = 0;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _startGame();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _timer.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startGame() {
    _gameStatus =
    'Mira la secuencia de números y repítelos en el orden correcto';
    _numberSequence = _generateNumberSequence(_numDigits);
    _showSequence = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        if (_countdown == 0) {
          _showSequence = false;
          _gameStatus = 'Ingresa la secuencia de números en el orden correcto';
          _startTimer();
        }
      });
    });
    _isGameStarted = true;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
        if (_elapsedSeconds == 60) {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _timer.cancel();
    _showSequence = true;
    _gameStatus =
    'Juego finalizado\n\nAciertos: $_correctAnswers\nErrores: $_wrongAnswers';
    FirebaseController.saveGameResult(
        "masterNúmeros", _correctAnswers - _wrongAnswers);
    _isGameStarted = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Juego terminado!'),
          content: Text('Puntaje: ${_correctAnswers-_wrongAnswers}'),
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

  List<int> _generateNumberSequence(int numDigits) {
    List<int> numbers = [];
    for (int i = 0; i < numDigits; i++) {
      numbers.add(Random().nextInt(9) + 1);
    }
    return numbers;
  }

  void _checkAnswer() {
    if (_userAnswer == _numberSequence.join()) {
      _correctAnswers++;
      _gameStatus = '¡Felicidades! Acertaste la secuencia';
    } else {
      _wrongAnswers++;
      _gameStatus = 'Lo siento, la secuencia correcta era ${_numberSequence.join()}';
    }
    _showSequence = true;
    _currentNumberIndex++;
    _numDigits = _currentNumberIndex ~/ 4 + 4;
    _numberSequence = _generateNumberSequence(_numDigits);
    _userAnswer = '';
    _timer.cancel();
    _countdown = 3;
    _showNextSequence();
  }

  void _showNextSequence() {
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showSequence = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: _isGameStarted
                      ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Tiempo transcurrido: $_elapsedSeconds segundos',
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : const SizedBox(),
                ),
                Expanded(
                  child: Center(
                    child: _showSequence
                        ? Text(
                      _numberSequence.join(),
                      style: const TextStyle(
                        fontSize: 44.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : TextField(
                      onChanged: (value) => _userAnswer = value,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '...',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(
                        fontSize: 44.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      focusNode: _focusNode,
                      autofocus: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 42.0),
                  child: ElevatedButton(
                    onPressed: _showSequence ? null : _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(
                      _showSequence ? 'Siguiente' : 'Verificar respuesta',
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  child: Text(
                    _gameStatus,
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (!_showSequence && _currentNumberIndex > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Respuestas correctas: $_correctAnswers',
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (!_showSequence && _currentNumberIndex > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Respuestas incorrectas: $_wrongAnswers',
                      style: const TextStyle(
                        fontSize: 20.0,
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
}
