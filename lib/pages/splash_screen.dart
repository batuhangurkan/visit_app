import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:myapp1/pages/login_page.dart';

import 'flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context)
            .size
            .width, // this will take full width of screen
        height: MediaQuery.of(context).size.height,
        child: AnimatedSplashScreen(
            splash: Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            nextScreen: LoginPage(),
            splashTransition: SplashTransition.fadeTransition,
            splashIconSize: 500,
            duration: 3000,
            backgroundColor: Colors.white),
      ),
    );
  }
}
