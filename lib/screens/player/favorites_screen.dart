import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tdapp/screens/player/configuration_screen.dart';
import 'package:tdapp/screens/Statistics/game_stats_screen.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'home_screen.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  int selectedIndex = 1;

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
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
              Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'Estadisticas',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Center(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    SizedBox(
                      width: 320.0,
                      height: 100.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameStats("memorama"),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 0, 71, 95),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Memorama",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4.0),
                                        // Otros detalles o texto aquí
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/memoryCard.png",
                                    width: 80.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 320.0,
                      height: 100.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameStats("auditivo"),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 0, 71, 95),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Auditivo",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4.0),

                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/memories.png",
                                    width: 80.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 320.0,
                      height: 100.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameStats("masterNumeros"),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 0, 71, 95),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "MasterNumbers",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4.0),

                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/numbers.png",
                                    width: 80.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      height: 100.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameStats("stroop"),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 0, 71, 95),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Stroop",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4.0),

                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/asociation.png",
                                    width: 80.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      height: 100.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameStats("secuenciaOrden"),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 0, 71, 95),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Secuencia Orden",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4.0),

                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/cardsseries.png",
                                    width: 80.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      height: 100.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameStats("simon"),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 0, 71, 95),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Simón",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4.0),

                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/matriz.png",
                                    width: 80.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),],
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
    text: "Actividades",
    onPressed: () {
    setState(() {
    selectedIndex = 0;
    });
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
    },
    ),
    const GButton(
    icon: FontAwesome.trophy,
    text: "Estadisticas",
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
