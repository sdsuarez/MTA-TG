import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tdapp/screens/player/home_screen.dart';
import 'package:tdapp/screens/Auth/singup_screen.dart';
import 'package:tdapp/utils/colors_utils.dart';

import '../../reusable_widgets/reusable_widget.dart';
import '../Trainer/trainer_home_screen.dart';
import '../Trainer/welcome_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? token = await user.getIdToken();
      if (token != null) {

        print('Valid token: $token');
      }


      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();


      String? accountType = userSnapshot.data()?['account type'];


      if (accountType == 'jugador') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else if (accountType == 'entrenador') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      } else {

      }
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      final User? user = userCredential.user;
      if (user != null) {
        final String? token = await user.getIdToken();
        if (token != null) {

          print('Token de validez: $token');
        }


        DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();


        String? accountType = userSnapshot.data()?['account type'];


        if (accountType == 'jugador') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else if (accountType == 'entrenador') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
          );
        } else {

        }
      }
    } catch (error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error de inicio de sesión'),
            content: Text('Datos Incorrectos'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/logoMTA.png"),
                  const SizedBox(
                    height: 10,
                  ),
                  reusableTextField(
                    "Ingresa Usuario",
                    Icons.person_outline,
                    false,
                    _emailTextController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  reusableTextField(
                    "Ingresa Contraseña",
                    Icons.lock_outline,
                    true,
                    _passwordTextController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  signInSignUpButton(
                      context, true, _signInWithEmailAndPassword),
                  signUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "¿No tienes cuenta? ",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            "Crear cuenta",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
