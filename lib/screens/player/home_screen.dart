import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tdapp/screens/player/configuration_screen.dart';
import 'package:tdapp/screens/player/favorites_screen.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../reusable_widgets/tutorial.dart';
import '../../utils/colors_utils.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  String userName = '';

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
      final userDocument = FirebaseFirestore.instance.collection('users').doc(user.uid);
      userDocument.get().then((doc) {
        if (doc.exists) {
          final fetchedUserName = doc.data()?['user'] ?? '';

          setState(() {
            userName = fetchedUserName;
          });

          userDataBox.put('userName', fetchedUserName);
        }
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
            gradient: LinearGradient(colors: [
              hexStringToColor("0E5BC2"),
              hexStringToColor("47b1c1"),
              hexStringToColor("76aee1")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
              ),
              Padding(
                padding: EdgeInsets.all(60.0),
                child: Text(
                  "¡Bienvenido, $userName! ¿Cuál actividad deseas hacer hoy?",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TutoPage( index: 0 )));
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 0, 71, 95),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Image.asset("assets/images/memoryCard.png",
                                      width: 110.0),
                                  const SizedBox(height: 4.0),
                                  const Text("Memorama",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0)),
                                  const SizedBox(height: 1.0),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TutoPage( index: 1 )));
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 0, 71, 95),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Image.asset("assets/images/memories.png",
                                      width: 110.0),
                                  const SizedBox(height: 4.0),
                                  const Text("Auditivo",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0)),
                                  const SizedBox(height: 1.0),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TutoPage( index: 2 )));
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 0, 71, 95),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Image.asset("assets/images/numbers.png",
                                      width: 110.0),
                                  const SizedBox(height: 4.0),
                                  const Text("MasterNúmeros",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0)),
                                  const SizedBox(height: 1.0),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TutoPage( index: 3 )));
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 0, 71, 95),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Image.asset("assets/images/asociation.png",
                                      width: 110.0),
                                  const SizedBox(height: 1.0),
                                  const Text("Stroop",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0)),
                                  const SizedBox(height: 4.0),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TutoPage( index: 4 )));
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 0, 71, 95),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Image.asset("assets/images/cardsseries.png",
                                      width: 110.0),
                                  const SizedBox(height: 4.0),
                                  const Text("Secuencia Orden",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0)),
                                  const SizedBox(height: 1.0),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TutoPage( index: 5 )));
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 0, 71, 95),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Image.asset("assets/images/matriz.png",
                                      width: 110.0),
                                  const SizedBox(height: 4.0),
                                  const Text("Simón",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0)),
                                  const SizedBox(height: 1.0),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),),
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
            const GButton(
              icon: Icons.home,
              text: "Actividades",

            ),
            GButton(
              icon: FontAwesome.trophy,
              text: "Estadisticas",
              onPressed: () {
                setState(() {
                  selectedIndex = 1; // actualiza el índice seleccionado
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favorites()),
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
                  MaterialPageRoute(builder: (context) => Configuration()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


