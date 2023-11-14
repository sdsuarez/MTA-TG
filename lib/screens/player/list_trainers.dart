import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../controller/firebase_send_request_controller.dart';
import '../../utils/colors_utils.dart';


class TrainerListScreen extends StatefulWidget {
  @override
  _TrainerListScreenState createState() => _TrainerListScreenState();
}

class _TrainerListScreenState extends State<TrainerListScreen> {
  List<DocumentSnapshot<Map<String, dynamic>>> trainers = [];
  List<DocumentSnapshot<Map<String, dynamic>>> filteredTrainers = [];
  bool isRequestSent = false;

  FirebaseController firebaseController = FirebaseController();

  @override
  void initState() {
    super.initState();
    fetchTrainers();
  }

  void fetchTrainers() async {
    final trainers = await firebaseController.fetchTrainers();

    setState(() {
      this.trainers = trainers;
      filteredTrainers = trainers;
    });
  }

  void searchTrainers(String searchTerm) {
    setState(() {
      filteredTrainers = trainers.where((trainer) {
        final username = trainer.data()?['user'] ?? '';
        final email = trainer.data()?['email'] ?? '';
        return username.contains(searchTerm) || email.contains(searchTerm);
      }).toList();
    });
  }

  void sendTrainingRequest(
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


      final playerRequestsSnapshot =
      await playerRequestsCollection.limit(1).get();
      if (playerRequestsSnapshot.size > 0) {
        showRequestSentDialog();
        return;
      }


      final playerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final playerName = playerSnapshot.data()?['user'] ?? '';


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

      setState(() {
        isRequestSent = true;
      });
    }
  }

  void showRequestSentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Solicitud enviada'),
        content: Text(
            'Ya has enviado una solicitud. Espera la respuesta antes de enviar otra.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("0E5BC2"),
                hexStringToColor("47b1c1"),
                hexStringToColor("76aee1"),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 32.0),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Lista de Entrenadores',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: searchTrainers,
                  decoration: InputDecoration(
                    hintText: 'Buscar entrenador',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTrainers.length,
                  itemBuilder: (context, index) {
                    final trainer = filteredTrainers[index];
                    final username = trainer.data()?['user'] ?? '';
                    final email = trainer.data()?['email'] ?? '';
                    final trainerId = trainer.id;

                    return ListTile(
                      title: Text(username),
                      subtitle: Text(email),
                      trailing: isRequestSent
                          ? Text('Solicitud enviada')
                          : Container(
                        width: 120.0,
                        child: ElevatedButton(
                          onPressed: () {
                            sendTrainingRequest(
                              trainerId,
                              username,
                              email,
                            );
                          },
                          child: Text('Solicitar'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
