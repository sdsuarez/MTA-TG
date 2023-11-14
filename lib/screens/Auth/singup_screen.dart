import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tdapp/reusable_widgets/reusable_widget.dart';

import '../../utils/colors_utils.dart';
import '../Trainer/trainer_home_screen.dart';
import '../Trainer/welcome_screen.dart';
import '../player/home_screen.dart';
import 'about_us_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  String _accountType = 'jugador';
  bool _acceptDataTreatment = false;

  @override
  void initState() {
    super.initState();
    // Inicializar Firebase
    Firebase.initializeApp();
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Crear cuenta",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
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
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField(
                    "Ingrese nombre de usuario",
                    Icons.person_outline,
                    false,
                    _userNameTextController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField(
                    "Ingrese correo",
                    Icons.person_outline,
                    false,
                    _emailTextController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField(
                    "Ingrese contraseña",
                    Icons.lock_outline,
                    true,
                    _passwordTextController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      accountTypeButton('jugador'),
                      const SizedBox(width: 20),
                      accountTypeButton('entrenador'),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _acceptDataTreatment,
                        onChanged: (value) {
                          setState(() {
                            _acceptDataTreatment = value ?? false;
                          });
                        },
                        checkColor: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Aceptas tratamiento de datos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "conoce ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutPage()),
                          );
                        },
                        child: const Text(
                          "Acerca de nosotros",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  signInSignUpButton(context, false, () async {
                    if (!_acceptDataTreatment) {
                      _showErrorDialog("Para crear tu cuenta debes aceptar el tratamiento de datos.");
                      return;
                    }

                    if (_emailTextController.text.isEmpty || !_emailTextController.text.contains("@")) {
                      _showErrorDialog("Por favor, ingresa un correo electrónico válido.");
                      return;
                    }

                    if (_userNameTextController.text.isEmpty) {
                      _showErrorDialog("Por favor, ingresa un nombre de usuario válido.");
                      return;
                    }

                    if (_passwordTextController.text.length < 8) {
                      _showErrorDialog("La contraseña debe tener al menos 8 caracteres.");
                      return;
                    }

                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      );

                      await addUserDetails(
                        userCredential.user!.uid,
                        _userNameTextController.text.trim(),
                        _accountType.trim(),
                        _emailTextController.text.trim(),
                      );

                      print("Cuenta creada");
                      if (_accountType == 'jugador') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else if (_accountType == 'entrenador') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomeScreen()),
                        );
                      } else {

                      }
                    } catch (error) {
                      _showErrorDialog("Ocurrió un error al crear la cuenta. Por favor, verifica tus datos.");
                      print('Error: $error');
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> addUserDetails(
      String uid,
      String user,
      String type,
      String email,
      ) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'user': user,
      'account type': type,
      'email': email,
    });
  }

  Widget accountTypeButton(String type) {
    bool isSelected = _accountType == type;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _accountType = type;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.blue : Colors.white,
        backgroundColor: isSelected ? Colors.white : Colors.transparent,
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      child: Text(
        type.toUpperCase(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
