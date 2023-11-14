import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FirebaseController {
  static Future<void> saveGameResult(String gameId, int score) async {
    final userId = await _getUserId();
    if (userId != null) {
      final userGamesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('games')
          .doc(gameId)
          .collection('results');

      final snapshot = await userGamesCollection.get();
      final timesPlayed = snapshot.docs.length + 1;

      final result = GameResult(
        timestamp: Timestamp.now(),
        score: score,
        timesPlayed: timesPlayed,
      );

      try {
        await userGamesCollection.add(result.toJson());
      } catch (e) {
        await _saveLocally(gameId, result);
      }
    } else {

    }
  }

  static Future<String?> _getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  static Future<void> _saveLocally(String gameId, GameResult result) async {
    final databasePath = await getDatabasesPath();
    final database = openDatabase(
      join(databasePath, 'game_results.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('CREATE TABLE IF NOT EXISTS $gameId (id INTEGER PRIMARY KEY AUTOINCREMENT, result TEXT)');
      },

    );

    final db = await database;
    await db.insert(gameId, result.toJson());
  }

  static Future<void> uploadLocalResults(String gameId) async {
    final databasePath = await getDatabasesPath();
    final database = openDatabase(
      join(databasePath, 'game_results.db'),
      version: 1,
    );

    final db = await database;
    final results = await db.query(gameId);

    final userId = await _getUserId();
    if (userId != null) {
      final userGamesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('games')
          .doc(gameId)
          .collection('results');

      for (final result in results) {
        final data = result['result'] as Map<String, dynamic>;
        try {
          await userGamesCollection.add(data);
          await db.delete(gameId, where: 'id = ?', whereArgs: [result['id']]);
        } catch (e) {

        }
      }
    }
  }
}

class GameResult {
  final Timestamp timestamp;
  final int score;
  final int timesPlayed;

  GameResult({
    required this.timestamp,
    required this.score,
    required this.timesPlayed,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'score': score,
      'timesPlayed': timesPlayed,
    };
  }
}
