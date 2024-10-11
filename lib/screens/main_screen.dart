import 'package:aurad_fatiha/screens/audio_screen.dart';
import 'package:aurad_fatiha/screens/prayer_screen.dart';
import 'package:aurad_fatiha/screens/my_home_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for SystemChrome
import 'package:aurad_fatiha/constants/constants.dart';
import 'package:aurad_fatiha/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectindex = 0;
  bool startOver = false;
  final List<Widget> _widgetsList = [];

  @override
  void initState() {
    super.initState();
    _widgetsList.addAll([
      HomeScreen(),
      MyHomePage(startOver: startOver),
      PrayerScreen(),
    ]);

    // Set the status bar color to match the app bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF3c7962), // Same color as bottomNavigationBar
      statusBarIconBrightness: Brightness.light, // Optional: for better visibility
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetsList[selectindex],
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Image.asset('assets/holyQuran.png', color: Colors.white), title: 'Home'),
          TabItem(icon: Image.asset('assets/audio.png', color: Colors.white), title: 'Learn'),
          TabItem(icon: Image.asset('assets/set.png', color: Colors.white), title: 'About'),
        ],
        initialActiveIndex: 0,
        onTap: updateIndex,
        backgroundColor: Color(0xFF3c7962),
        activeColor: Color(0xFF7c9891),
      ),
    );
  }

  void updateIndex(index) {
    setState(() {
      selectindex = index;
    });
  }
}