import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Pgracias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Espera 3 segundos y luego regresa a la pantalla anterior
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(99, 139, 211, 1),
      body: Center(
        child: Stack(
          children: [
            // Center element with text
            Positioned(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                        'assets/like.json'), // Replace with your center Lottie file path
                    SizedBox(
                        height:
                            10), // Add a small space between Lottie and text
                    Text(
                      '¡Gracias por ayudarnos a mejorar tu experiencia!',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
