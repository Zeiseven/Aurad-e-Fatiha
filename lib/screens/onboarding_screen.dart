import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'package:aurad_fatiha/constants/constants.dart'; // Import your main screen here

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  void _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;

    if (!isFirstLaunch) {
      // If not the first launch, navigate to the main screen directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Learn To Read",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Learn Line By Line To Read Aurad e Fatiha With Audio Support",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              image: Center(
                child: Image.asset(
                  'assets/quran.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            PageViewModel(
              title: "Read With Meaning",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Read Aurad e Fatiha With Urdu Translation ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              image: Center(
                child: Image.asset('assets/prayer.png'),
              ),
            ),
            PageViewModel(
              title: "Report Errors, Bugs, Changes, Suggestions",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "We Are Always Eager To Serve You Best, Contact Us And Report Issues ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              image: Center(
                child: Image.asset('assets/zakat.png'),
              ),
            ),
          ],
          onDone: () async {
            // Set the flag to indicate that the onboarding has been completed
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('firstLaunch', false);

            // Navigate to the main screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
          showNextButton: true,
          next: Icon(Icons.arrow_forward, color: Colors.black),
          done: Text("Done",
              style:
              TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Constants.kPrimary,
            color: Colors.grey,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
