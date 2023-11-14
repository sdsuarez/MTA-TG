import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GameController {
  late String userId;
  late CollectionReference userGamesCollection;
  StreamSubscription<QuerySnapshot>? gameResultsSubscription;

  Future<void> fetchUserId(String gameId) async {
    final user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    userGamesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('games')
        .doc(gameId)
        .collection('results');
  }

  Future<List<QueryDocumentSnapshot<Object?>>> fetchGameResults() async {
    final query = userGamesCollection.orderBy('timestamp', descending: true);
    final snapshot = await query.get();


    gameResultsSubscription = query.snapshots().listen((snapshot) {

    });
    gameResultsSubscription?.cancel();
    return snapshot.docs;
  }

  Future<void> saveGameResult(String gameId, int score) async {
    final result = GameResult(
      timestamp: Timestamp.now(),
      score: score,
    );

    final isConnected = await hasInternetConnection();

    if (isConnected) {
      try {
        await userGamesCollection.add(result.toJson());
      } catch (e) {
        await _saveLocally(gameId, result);
      }
    } else {
      await _saveLocally(gameId, result);
    }
  }

  Future<void> _saveLocally(String gameId, GameResult result) async {
    final databasePath = await getDatabasesPath();
    final database = await openDatabase(
      join(databasePath, 'game_results.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE IF NOT EXISTS $gameId (id INTEGER PRIMARY KEY AUTOINCREMENT, result TEXT)');
      },
    );

    final db = await database;
    await db.insert(gameId, result.toJson());
  }

  Future<bool> hasInternetConnection() async {
    final isConnected = await InternetConnectionChecker().hasConnection;
    return isConnected;
  }

  void dispose() {
    gameResultsSubscription?.cancel();
  }
}

class GameResult {
  final Timestamp timestamp;
  final int score;

  GameResult({
    required this.timestamp,
    required this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'score': score,
    };
  }
}
