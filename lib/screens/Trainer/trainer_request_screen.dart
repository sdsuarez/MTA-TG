import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tdapp/screens/Trainer/trainer_configuration_screen.dart';
import 'package:tdapp/screens/Trainer/trainer_home_screen.dart';
import '../../controller/firebase_trainer_request_controller.dart';
import '../../utils/colors_utils.dart';


class TrainerRequestScreen extends StatefulWidget {
  const TrainerRequestScreen({Key? key}) : super(key: key);

  @override
  _TrainerRequestScreenState createState() => _TrainerRequestScreenState();
}

class _TrainerRequestScreenState extends State<TrainerRequestScreen> {
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    FirebaseConnection.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
              ),
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: Text(
                  'Solicitudes de Seguimiento',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseConnection.trainerRequestsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final requests = snapshot.data!.docs;
                    if (requests.isEmpty) {
                      return Text(
                        'No hay solicitudes de jugadores',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        final playerId = request.id;
                        final playerName = request.data()['nombre_jugador'] as String?;
                        final playerEmail = request.data()['usuario_jugador'] as String?;
                        final playerUserId = request.data()['usuarioId'] as String?;

                        if (playerName == null) {
                          return SizedBox();
                        }

                        return Column(
                          children: [
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    playerName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    playerEmail ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => FirebaseConnection.acceptRequest(playerId, playerName!, playerUserId!),

                                      icon: Icon(Icons.check),
                                      label: Text('Aceptar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => FirebaseConnection.rejectRequest(playerId, playerUserId!),
                                      icon: Icon(Icons.close),
                                      label: Text('Rechazar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error al cargar las solicitudes',
                      style: TextStyle(color: Colors.white),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
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
            icon: Icons.people,
            text: "Actividades",
            onPressed: () {
              setState(() {
                selectedIndex = 0;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrainerHomeScreen()),
              );
            },
          ),
          GButton(
            icon: Icons.add_comment,
            text: "Solicitud",
            onPressed: () {
              setState(() {
                selectedIndex = 1;
              });

            },
          ),
          GButton(
            icon: Icons.person,
            text: "Configuración",
            onPressed: () {
              setState(() {
                selectedIndex = 2;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrainerConfiguration()),
              );
            },
          ),
        ],
      ),
    );
  }
}
