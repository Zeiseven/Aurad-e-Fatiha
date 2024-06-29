import 'package:aurad_fatiha/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 170,
              left: 0,
              right: 0,
              child: Image.asset('assets/name.png'),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset('assets/islamic.png'),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset('assets/upper.png'),
            ),

          ],
        ),
      ),
    );
  }
}

