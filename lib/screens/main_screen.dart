import 'package:aurad_fatiha/screens/audio_screen.dart';
import 'package:aurad_fatiha/screens/prayer_screen.dart';
import 'package:aurad_fatiha/screens/quran_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:aurad_fatiha/constants/constants.dart';
import 'package:aurad_fatiha/screens/home_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectindex = 0;
  final List<Widget> _widgetsList = [HomeScreen(),QuranScreen(),PrayerScreen()];




  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: _widgetsList[selectindex],
            bottomNavigationBar: ConvexAppBar(
              items: [
                TabItem(icon: Image.asset('assets/audio.png',color: Colors.white,), title: 'Home'),
                TabItem(icon: Image.asset('assets/holyQuran.png',color: Colors.white,), title: 'Read'),
                TabItem(icon: Image.asset('assets/set.png',color: Colors.white,), title: 'About'),
              ],
              initialActiveIndex: 0, //optional, default as 0
              onTap: updateIndex,
              backgroundColor: Constants.kPrimary,
              activeColor: Constants.kPrimary,
            )
        )
    );
  }

  void updateIndex(index){
    setState(() {
      selectindex = index;
    });
  }
}