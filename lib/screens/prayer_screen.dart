import 'package:flutter/material.dart';

class PrayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3c7962),
                  Color(0xFF3c7962),// Updated to match SalamScreen
                 /* Color(0xFF77bba2), */
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  'About',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
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
            // About Author Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    'About Author',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'آپؒ  کا اسم گرامی سید علی ہے ۔ آپؒ بارہ (۱۲)  ماہ رجب المرجب ۷۱۴ ھ میں شہر ہمدان میں تولد ہوئے ۔ والد گرامی کا اسم مبارک سید شہاب الدین اور والدہ محترمہ کا نام نامی حضرت سیدہ فاطمہ ہے۔ اس خط کشمیر میں آپؒ کا ورد مسعود سلطان شہاب الدین کے دور حکومت میں ہوا۔ اس دفعہ فقط چار مہینے آپؒ نے یہاں کشمیر میں قیام فرمایا۔ پھر ہندوستان کے راستہ سے واپس تشریف لے گئے ۔ دوسری دفعہ ۷۸۱ ھ میں سلطان قطب الدین کے زمانے میں سات سو (۷۰۰) سادات و علماء کے ہمراہ کشمیر تشریف فرما ہو کر سرینگر کے محلہ علاؤالدین پورہ میں قیام فرما ہوئے اور کالی شری بت خانے کے شاہ پور نامی پجاری کو اپنی خداداد قوت اور جذبہء ولایت سے قائیل کر کے دین اسلام کی نعمت سے سرفراز فرمایا۔ پھر آپؒ نے اپنے قیام کے حجرہ ء خاص کے مقام پر خیمہ نصب فرمایا اور وہیں دو چلے خلوت میں گزارنے کے بعد سنتیس ہزار ( ۳۷۰۰۰) لوگوں کو اسلام کے نور سے منور فرمایا۔ اس طرح کشمیر جو دارالکفر تھا، بقعہ اسلام بن گیا۔ کشمیر میں ڈھائی سال کی مدت تک رہکر آپؒ نے یہاں بہت سی خانقا ہیں تعمیر کروائیں اور اسلام کی اشاعت فرما کر بدعات کی بیخ کنی کی اور پھر لداخ کے راستے سے ترکستان تشریف لے گئے ۔ تیسری دفعہ ۷۸۵ھ میں پھر وارد کشمیر  ہوئے اور یہاں قوانین شریعت اور احکام اسلام کی ترویج فرمائی اور مسلمانان کشمیر کو ذکر بالجبر کی اجازت عام دی اور اور اد فتحیہ کو بالجہر پڑھنے کی اجازت مرحمت فرمائی۔ اس کا مطلب یہ ہرگز نہیں کہ ذکر بالخفی کی اجازت نہیں ہے بلکہ اس موضوع پر آپؒ نے تفصیل کے ساتھ دو کتا ہیں ایک ذکر ہاتھی یعنی "رسالہ ذکریہ اور دوسری کتاب "رسالہ اور ادیہ ذکر بالجہر کے بارے میں برصفحہ قرطاس لا کر منصہ شہود پر لائے ۔ حضرت امیر کبیر میر سید علی ہمدانی ؒ  کے دور میں جب چہار دانگ ذکر بالجہر اور ذکر بالخفی کی بحث چھڑی ہوئی تھی ، تو آپؒ نے یہاں ” اورا فتحیہ “ کو بالجہر پڑھنے کی اجازت مرحمت فرمائی۔',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontFamily: 'read'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // About App Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                children: [
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
                      'Aurad-e-Fatiha" is a collection of prayers and devotional practices attributed to " Mir Syed Ali Hamdani " [RA], a prominent Islamic scholar who lived in the 14th century. He [RA] was instrumental in spreading Islam, in the Kashmir region and Central Asia. The "Aurad-e-Fatiha App" is your gateway to spiritual enrichment through the timeless practice of "Aurad-e-Fatiha" as expounded by the venerable " Mir Syed Ali Hamdani "[RA] . Designed with simplicity and spiritual growth in mind, this app offers a comprehensive platform for learning, reciting, and understanding the profound verses of "Aurad-e-Fatiha". We have added on tap audio with each line. The Reciter of the audio is Qari Adam Ahmad',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/dev'),
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
                'Allow me to introduce you to Syed Arsalan Murtaza, a passionate and driven developer hailing from the breathtaking valleys of Kashmir. Currently immersed in the pursuit of a Bachelors degree in Computer Engineering at the esteemed Aligarh Muslim University (AMU) in Aligarh, India. Despite facing numerous challenges along the way, I remained undeterred, pouring countless hours into the development process. As I single-handedly crafted every line of code with precision and care, I encountered hurdles that tested my skills and determination. Yet, with each obstacle, I saw an opportunity to learn and grow, refining my craft and pushing the boundaries of what I believed possible. However, I am aware that in the pursuit of perfection, there may be areas for improvement. As such, I welcome any feedback or suggestions for enhancing the app further. If you encounter any errors or have ideas for features that could enhance the user experience, please do not hesitate to share them. Together, we can collaborate to refine and perfect the app, ensuring it meets the needs and expectations of its users.',
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
                    'arsalanmurtaza33@gmail.com',
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
