import 'package:flutter/material.dart';
import 'package:aurad_fatiha/constants/constants.dart';
import 'package:aurad_fatiha/screens/main_screen.dart';
import 'package:aurad_fatiha/screens/splash_screen.dart';
//import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key})  : super(key : key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aurad',
      theme: ThemeData(
          primarySwatch: Constants.kSwatchColor,
          primaryColor: Constants.kPrimary,
          scaffoldBackgroundColor: Colors.white,

          fontFamily: 'Poppins'
      ),
      home: SplashScreen(),
    );
  }
}

