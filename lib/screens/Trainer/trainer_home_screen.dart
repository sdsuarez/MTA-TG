import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tdapp/screens/Trainer/trainer_configuration_screen.dart';
import 'package:tdapp/screens/Trainer/trainer_request_screen.dart';
// Importar la pantalla "Favorites"
import '../../utils/colors_utils.dart';
import 'list_favorites_screen.dart';

class TrainerHomeScreen extends StatefulWidget {
  const TrainerHomeScreen({Key? key}) : super(key: key);

  @override
  _TrainerHomeScreenState createState() => _TrainerHomeScreenState();
}

class _TrainerHomeScreenState extends State<TrainerHomeScreen> {
  int selectedIndex = 0;
  String userName = '';
  List<Map<String, dynamic>> entrenados = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final userDataBox = await Hive.openBox('userDataBox');

    final storedUserName = userDataBox.get('userName') as String?;

    if (storedUserName != null) {
      setState(() {
        userName = storedUserName;
      });
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDocument =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      userDocument.get().then((doc) {
        if (doc.exists) {
          final fetchedUserName = doc.data()?['user'] ?? '';

          setState(() {
            userName = fetchedUserName;
          });

          userDataBox.put('userName', fetchedUserName);
        }
      });


      final entrenadosCollection = userDocument.collection('Entrenados');
      final entrenadosSnapshot = await entrenadosCollection.get();

      final nombresJugadores = entrenadosSnapshot.docs.map((doc) {
        final nombreJugador = doc.data()['nombre_jugador'] ?? '';
        final correoJugador = doc.data()['usuario_jugador'] ?? '';
        final usuarioId =
            doc.data()['usuarioId'] ?? '';
        return {
          'nombre': nombreJugador,
          'correo': correoJugador,
          'usuarioId': usuarioId,
        };
      }).toList();

      setState(() {
        entrenados = nombresJugadores;
      });
    }
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
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
                    '¡Hola, $userName!, escoge a tu jugador para ver sus avances',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entrenados.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final nombreJugador = entrenados[index]['nombre'];
                    final correoJugador = entrenados[index]['correo'];
                    final usuarioId = entrenados[index]
                        ['usuarioId'];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoritesScreen(
                                usuarioId:
                                    usuarioId),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombreJugador,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              correoJugador,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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
              icon: Icons.person,
              text: "Actividades",
              onPressed: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
            GButton(
              icon: Icons.add_comment,
              text: "Solicitudes",
              onPressed: () {
                setState(() {
                  selectedIndex = 1;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TrainerRequestScreen()),
                );
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
                  MaterialPageRoute(
                      builder: (context) => TrainerConfiguration()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
