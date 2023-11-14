import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tdapp/screens/Auth/singin_screen.dart';
import 'package:tdapp/screens/player/favorites_screen.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'list_trainers.dart';

class Configuration extends StatefulWidget {
  @override
  _ConfigurationState createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  int selectedIndex = 2;
  String userName = '';
  String accountType = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final appDocumentDir = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final userDataBox = await Hive.openBox('userDataBox');

    final storedUserName = userDataBox.get('userName') as String?;
    final storedAccountType = userDataBox.get('accountType') as String?;
    final storedEmail = userDataBox.get('email') as String?;

    if (storedUserName != null && storedAccountType != null && storedEmail != null) {
      setState(() {
        userName = storedUserName;
        accountType = storedAccountType;
        email = storedEmail;
      });
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDocument = FirebaseFirestore.instance.collection('users').doc(user.uid);
      userDocument.get().then((doc) {
        if (doc.exists) {
          final fetchedUserName = doc.data()?['user'] ?? '';
          final fetchedAccountType = doc.data()?['account type'] ?? '';
          final fetchedEmail = user.email ?? '';

          setState(() {
            userName = fetchedUserName;
            accountType = fetchedAccountType;
            email = fetchedEmail;
          });

          userDataBox.put('userName', fetchedUserName);
          userDataBox.put('accountType', fetchedAccountType);
          userDataBox.put('email', fetchedEmail);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      'Mis Configuraciones',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                buildInfoTile('Nombre de usuario', userName),
                buildInfoTile('Tipo de cuenta', accountType),
                buildInfoTile('Email', email),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrainerListScreen()),
                    );
                  },
                  child: Text('Escoger entrenador'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _signOut();
                  },
                  child: Text('Cerrar Sesión'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteAccount();
                  },
                  child: Text('Borrar Cuenta'),
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
            GButton(
              icon: FontAwesome.trophy,
              text: "Estadisticas",
              onPressed: () {
                setState(() {
                  selectedIndex = 1;
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  void _signOut() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro que deseas cerrar la sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro que deseas borrar la cuenta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    await user.delete();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                  } catch (e) {
                    print('Error al borrar la cuenta!: $e');
                  }
                }
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }}
