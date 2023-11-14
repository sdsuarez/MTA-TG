import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseConnection {
  static late CollectionReference<Map<String, dynamic>> trainerRequestsCollection;
  static late String userId;

  static void fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      trainerRequestsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('solicitud de jugadores');
    }
  }

  static void acceptRequest(String playerId, String playerName, String playerUserId) async {
    try {
      final requestDoc = await trainerRequestsCollection.doc(playerId).get();
      final requestData = requestDoc.data();

      if (requestData != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('Entrenados')
            .doc(playerId)
            .set(requestData);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(playerUserId)
            .update({'entrenado': userId});

        await trainerRequestsCollection.doc(playerId).delete();

        print('Solicitud del jugador con ID $playerId aceptada y movida a la colección "Entrenados"');
      } else {
        print('No se encontró la solicitud del jugador con ID $playerId');
      }
    } catch (error) {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('acceptPlayerId', playerId);
      prefs.setString('acceptPlayerName', playerName);
      prefs.setString('acceptPlayerUserId', playerUserId);


      print('Error al aceptar la solicitud: $error');
    }
  }

  static void rejectRequest(String playerId, String playerUserId) async {
    try {
      await trainerRequestsCollection.doc(playerId).delete();

      final userRef = FirebaseFirestore.instance.collection('users').doc(playerUserId);
      final requestCollection = userRef.collection('solicitud de entrenadores');
      final querySnapshot = await requestCollection.get();
      final documents = querySnapshot.docs;

      for (var document in documents) {
        await document.reference.delete();
      }
      print('Solicitud del jugador con ID $playerId rechazada');
    } catch (error) {
      // Si ocurre un error, guardar los datos localmente
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('rejectPlayerId', playerId);
      prefs.setString('rejectPlayerUserId', playerUserId);
      // Puedes guardar otros datos necesarios para rechazar la solicitud más tarde

      print('Error al rechazar la solicitud: $error');
    }
  }

  static void sendPendingRequests() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? acceptPlayerId = prefs.getString('acceptPlayerId');
    final String? acceptPlayerName = prefs.getString('acceptPlayerName');
    final String? acceptPlayerUserId = prefs.getString('acceptPlayerUserId');
    final String? rejectPlayerId = prefs.getString('rejectPlayerId');
    final String? rejectPlayerUserId = prefs.getString('rejectPlayerUserId');


    if (acceptPlayerId != null &&
        acceptPlayerName != null &&
        acceptPlayerUserId != null) {
      try {
         acceptRequest(acceptPlayerId, acceptPlayerName, acceptPlayerUserId);


        prefs.remove('acceptPlayerId');
        prefs.remove('acceptPlayerName');
        prefs.remove('acceptPlayerUserId');

      } catch (e) {
        print('Error al enviar la solicitud pendiente de aceptación: $e');
      }
    }

    if (rejectPlayerId != null && rejectPlayerUserId != null) {
      try {
         rejectRequest(rejectPlayerId, rejectPlayerUserId);


        prefs.remove('rejectPlayerId');
        prefs.remove('rejectPlayerUserId');

      } catch (e) {
        print('Error al enviar la solicitud pendiente de rechazo: $e');
      }
    }
  }
}
