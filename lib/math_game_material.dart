import 'package:flutter/material.dart';
import 'package:math_game/screens/splash_screen.dart';

class MathGame extends StatelessWidget {
  const MathGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
