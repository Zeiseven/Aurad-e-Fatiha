import 'package:flutter/material.dart';

class PrayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  'About',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'About App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Aurad-e-Fatiha" is a collection of prayers and devotional practices attributed to Mir Sayyid Ali Hamadani, a prominent Islamic scholar who lived in the 14th century. He was instrumental in spreading Islam, in the Kashmir region and Central Asia. The Aurad-e-Fatiha app is your gateway to spiritual enrichment through the timeless practice of Aurad-e-Fatiha as expounded by the venerable Mir Syed Ali Hamdani. Designed with simplicity and spiritual growth in mind, this app offers a comprehensive platform for learning, reciting, and understanding the profound verses of Aurad-e-Fatiha. We have added on tap audio with each line. The Reciter of the audio is Qari Adam Ahmad',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/dev.png'),
            ),
            SizedBox(height: 20),
            Text(
              'About the Developer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Allow me to introduce you to Arsalan Murtaza, a passionate and driven developer hailing from the breathtaking valleys of Kashmir. Currently immersed in the pursuit of a Bachelors degree in Computer Engineering at the esteemed Aligarh Muslim University (AMU) in Aligarh, India. Despite facing numerous challenges along the way, I remained undeterred, pouring countless hours into the development process. As I single-handedly crafted every line of code with precision and care, I encountered hurdles that tested my skills and determination. Yet, with each obstacle, I saw an opportunity to learn and grow, refining my craft and pushing the boundaries of what I believed possible.However, I am aware that in the pursuit of perfection, there may be areas for improvement. As such, I welcome any feedback or suggestions for enhancing the app further. If you encounter any errors or have ideas for features that could enhance the user experience, please do not hesitate to share them. Together, we can collaborate to refine and perfect the app, ensuring it meets the needs and expectations of its users.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
                  Text(
                    'For Errors, Bugs, Suggestions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Feel free to email us!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Also, don\'t forget to rate us on Play Store!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Developer Contact Email:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'arsalanmurtaza@zhcet.ac.in',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
