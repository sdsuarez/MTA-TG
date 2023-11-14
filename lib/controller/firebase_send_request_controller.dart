import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController {
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> fetchTrainers() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance
        .collection('users')
        .where('account type', isEqualTo: 'entrenador')
        .get();

    return snapshot.docs;
  }

  Future<void> sendTrainingRequest(
      String trainerId, String trainerUsername, String trainerEmail) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final CollectionReference<Map<String, dynamic>> playerRequestsCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('solicitud de entrenadores');

      final CollectionReference<Map<String, dynamic>> trainerRequestsCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc(trainerId)
          .collection('solicitud de jugadores');

      final username = user.displayName ?? '';
      final email = user.email ?? '';


      final playerRequestsSnapshot = await playerRequestsCollection.limit(1).get();
      if (playerRequestsSnapshot.size > 0) {
        throw Exception(
            'Ya has enviado una solicitud. Espera la respuesta antes de enviar otra.');
      }


      final playerSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final playerName = playerSnapshot.data()?['user'] ?? '';

      try {

        final playerRequestId = playerRequestsCollection.doc().id;
        await playerRequestsCollection.doc(playerRequestId).set({
          'entrenador': trainerUsername,
          'correo': trainerEmail,
          'fecha': DateTime.now(),
          'usuarioId': user.uid,
        });


        final trainerRequestId = trainerRequestsCollection.doc().id;
        await trainerRequestsCollection.doc(trainerRequestId).set({
          'usuario_jugador': username.isNotEmpty ? username : email,
          'nombre_jugador': playerName,
          'fecha': DateTime.now(),
          'usuarioId': user.uid,
        });
      } catch (e) {

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('trainerId', trainerId);
        prefs.setString('trainerUsername', trainerUsername);
        prefs.setString('trainerEmail', trainerEmail);
        prefs.setString('playerName', playerName);


        throw e;
      }
    }
  }

  Future<void> sendPendingRequests() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? trainerId = prefs.getString('trainerId');
    final String? trainerUsername = prefs.getString('trainerUsername');
    final String? trainerEmail = prefs.getString('trainerEmail');
    final String? playerName = prefs.getString('playerName');


    if (trainerId != null &&
        trainerUsername != null &&
        trainerEmail != null &&
        playerName != null) {
      try {
        await sendTrainingRequest(trainerId, trainerUsername, trainerEmail);


        prefs.remove('trainerId');
        prefs.remove('trainerUsername');
        prefs.remove('trainerEmail');
        prefs.remove('playerName');

      } catch (e) {

        print('Error al enviar la solicitud: $e');
      }
    }
  }
}
