import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:math_game/screens/math_game_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState()  => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const MathGameScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle
                ),
                child: Image.asset('assets/images/logo.png',)),
            const Text('Math Game',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 45,
                color: Colors.white
            ),),
            const SizedBox(height: 16,),
            Column(
              children: [
                Center(
                  child: LoadingAnimationWidget.discreteCircle(color: Colors.white, size: 40),
                )
              ],
            ),
            const Spacer(),

          ],
        ),
      ),
    );
  }
}