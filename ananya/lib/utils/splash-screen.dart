import 'package:ananya/screens/landing/landing.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        'assets/gif/loading.gif',
        height: 400,
        fit: BoxFit.contain,
      ),
      nextScreen: Landing(),
      backgroundColor: Colors.white,
      splashIconSize: 400,
    );
  }
}
