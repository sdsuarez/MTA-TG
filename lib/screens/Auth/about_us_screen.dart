import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Acerca de',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Nuestra aplicación está diseñada para ayudar a mejorar la memoria de trabajo, una función ejecutiva del cerebro que desempeña un papel importante en diversas tareas cognitivas.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Nuestro enfoque es una serie de 6 juegos diseñados específicamente para entrenar las diferentes partes de la memoria de trabajo. Estos juegos te ayudarán a entrenar tu capacidad de retener y manipular información en tu mente.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Además, nuestra aplicación te permite realizar un seguimiento de tus propias estadísticas personales, lo que te permitirá ver tu progreso a lo largo del tiempo y establecer metas para mejorar.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'También ofrecemos la posibilidad de conectarte con tu psicólogo, quien podrá acceder a tus resultados y brindarte un apoyo en tu entrenamiento de memoria de trabajo.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '*Esta aplicación ha sido desarrollada con el propósito de completar el requisito trabajo de grado para obtener el título de Ingeniero de Sistemas en la Pontificia Universidad Javeriana. Es importante resaltar que los datos recopilados a través de esta aplicación se utilizan exclusivamente con fines educativos y académicos, en cumplimiento de los principios éticos y legales establecidos por la normativa de protección de datos personales. ',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
