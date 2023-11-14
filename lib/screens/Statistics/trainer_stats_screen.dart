import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tdapp/screens/Trainer/list_favorites_screen.dart';

import '../../controller/firebase_trainer_read_controller.dart';

class GameStats extends StatefulWidget {
  final String gameId;
  final String userId;
  

  GameStats(this.gameId, this.userId);

  @override
  _GameStatsState createState() => _GameStatsState();
}

class _GameStatsState extends State<GameStats> {
  int selectedIndex=1;
  List<DocumentSnapshot> gameResults = [];
  GameController _controller = GameController();
  bool _isLoading = true;
  String usuarioFId = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    usuarioFId = widget.userId;
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true; // Mostrar la animación de carga
    });

    await _controller.fetchUserId( widget.gameId, widget.userId); // Utilizar el ID del usuario proporcionado
    final results = await _controller.fetchGameResults();

    setState(() {
      gameResults = results;
      _isLoading = false; // Ocultar la animación de carga
    });
  }

  int getTimesPlayed() {
    return gameResults.fold(0, (maxTimesPlayed, result) {
      final timesPlayed = result.get('timesPlayed') as int? ?? 0;
      return timesPlayed > maxTimesPlayed ? timesPlayed : maxTimesPlayed;
    });
  }

  int getMaxScore() {
    return gameResults.fold(0, (maxScore, result) {
      final score = result.get('score') as int? ?? 0;
      return score > maxScore ? score : maxScore;
    });
  }

  double getAverageScore() {
    if (gameResults.isEmpty) return 0;
    int totalScore = gameResults.fold(0, (total, result) {
      final score = result.get('score') as int? ?? 0;
      return total + score;
    });
    return totalScore / gameResults.length;
  }

  List<LineSeries<GameResult, int>> getChartData() {
    final data = gameResults.asMap().entries.map((entry) {
      final index = entry.key;
      final result = entry.value;
      final score = (result.get('score') as int? ?? 0);
      final timesPlayed = gameResults.length - index;
      return GameResult(timesPlayed, score);
    }).toList();


    return [
      LineSeries<GameResult, int>(
        dataSource: data.reversed.toList(),
        xValueMapper: (GameResult result, _) => result.timesPlayed,
        yValueMapper: (GameResult result, _) => result.score,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final chartWidth = 300.0;
    final chartHeight = 200.0;

    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    home: WillPopScope(
    onWillPop: () async {
    Navigator.pop(context);
    return false;
    },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Estadísticas ${widget.gameId}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  if (_isLoading)
                    SpinKitWave(
                      color: Colors.white,
                      size: 50.0,
                    ),
                  if (!_isLoading)
                    Container(
                      width: chartWidth,
                      height: chartHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                          isVisible: true,
                          title: AxisTitle(
                            text: 'Partidas Jugadas',
                            textStyle: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          labelRotation: 0,
                          labelPlacement: LabelPlacement.onTicks,
                          axisLine: AxisLine(width: 0),
                          majorGridLines: MajorGridLines(width: 0),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        primaryYAxis: NumericAxis(
                          isVisible: true,
                          title: AxisTitle(
                            text: 'Puntuación',
                            textStyle: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        series: getChartData(),
                      ),
                    ),
                  SizedBox(height: 16.0),
                  InfoTile(
                    title: 'Veces jugadas',
                    value: getTimesPlayed().toString(),
                  ),
                  InfoTile(
                    title: 'Puntuación máxima',
                    value: getMaxScore().toString(),
                  ),
                  InfoTile(
                    title: 'Puntuación promedio',
                    value: getAverageScore().toStringAsFixed(2),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Lista de resultados:',
                    style: TextStyle(
                      //color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: gameResults.length,
                      itemBuilder: (context, index) {
                        final result = gameResults[index];

                        final timestamp = result.get('timestamp') as Timestamp?;
                        final score = result.get('score') as int? ?? 0;
                        DateTime? dateTime = timestamp?.toDate();
                        String formattedDateTime =
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime!);

                        return ListTile(
                          title: Text(
                            'Resultado ${gameResults.length - index}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha: $formattedDateTime',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Puntaje: $score',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GNav(
          backgroundColor: const Color.fromARGB(255, 118, 174, 225),
          color: Colors.white,
          iconSize: 20,
          tabBackgroundColor: const Color.fromARGB(255, 106, 156, 202),
          gap: 8,
          activeColor: Colors.white,
          padding: const EdgeInsets.all(16.0),
          selectedIndex: selectedIndex,
          tabs: [
            GButton(
              icon: Icons.home,
              text: "Volver",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  FavoritesScreen(usuarioId: usuarioFId)),
                );
              },
            ),

          ],
          onTabChange: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
      
    ),
    );
  }
}

class GameResult {
  final int timesPlayed;
  final int score;

  GameResult(this.timesPlayed, this.score);
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
