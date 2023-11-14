import 'package:flutter/material.dart';

import 'package:tdapp/screens/Trainer/trainer_configuration_screen.dart';
import 'package:tdapp/screens/Trainer/trainer_home_screen.dart';
import 'package:tdapp/screens/Trainer/trainer_request_screen.dart';

import '../../utils/colors_utils.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int selectedIndex = 0;

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
                const Padding(
                  padding: EdgeInsets.all(60.0),
                  child: Text(
                    '¡Hola, entrenador!',
                    style: TextStyle(
                      fontSize: 34.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'En esta app podrás hacer seguimiento a los jugadores viendo sus estadísticas en cada uno de las actividades para entrenar los elementos cognitivos atencionales. Selecciona la opción que desees usar',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.people, color: Colors.white),
                        title: const Text(
                          'Ver tus jugadores actuales',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TrainerHomeScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.add_comment, color: Colors.white),
                        title: const Text(
                          'Ver solicitudes de jugadores para que los entrenes',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TrainerRequestScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.settings, color: Colors.white),
                        title: const Text(
                          'Configuraciones',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
