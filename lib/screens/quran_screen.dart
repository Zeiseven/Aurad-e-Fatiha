import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<List<String>> excelData = [];
  late double arabicFontSize;
  late double translationFontSize;
  late bool displayTranslation;

  @override
  void initState() {
    super.initState();
    loadSettings();
    loadExcelData();
  }

  Future<void> saveFontSettings(
      double arabicFontSize, double translationFontSize, bool displayTranslation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabicFontSize', arabicFontSize);
    await prefs.setDouble('translationFontSize', translationFontSize);
    await prefs.setBool('displayTranslation', displayTranslation);
    setState(() {
      this.arabicFontSize = arabicFontSize;
      this.translationFontSize = translationFontSize;
      this.displayTranslation = displayTranslation;
    });
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      arabicFontSize = prefs.getDouble('arabicFontSize') ?? 30;
      translationFontSize = prefs.getDouble('translationFontSize') ?? 22;
      displayTranslation = prefs.getBool('displayTranslation') ?? true;
    });
  }

  Future<void> loadExcelData() async {
    ByteData data = await rootBundle.load("assets/arabic_data.xlsx");
    Uint8List bytes = data.buffer.asUint8List();
    var excel = Excel.decodeBytes(bytes);
    var table = excel.tables['Sheet1'];
    for (var row in table!.rows) {
      excelData.add([row[1]?.value.toString() ?? '', row[2]?.value.toString() ?? '']);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: AppBar(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text('Settings'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Arabic Font'),
                              Slider(
                                value: arabicFontSize,
                                min: 20,
                                max: 60,
                                divisions: 4,
                                onChanged: (value) {
                                  setState(() {
                                    arabicFontSize = value;
                                    saveFontSettings(arabicFontSize, translationFontSize, displayTranslation);
                                  });
                                },
                              ),
                              Text('Urdu Font'),
                              Slider(
                                value: translationFontSize,
                                min: 20,
                                max: 60,
                                divisions: 4,
                                onChanged: (value) {
                                  setState(() {
                                    translationFontSize = value;
                                    saveFontSettings(arabicFontSize, translationFontSize, displayTranslation);
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  Text('Translation'),
                                  Switch(
                                    value: displayTranslation,
                                    onChanged: (value) {
                                      setState(() {
                                        displayTranslation = value;
                                        saveFontSettings(arabicFontSize, translationFontSize, displayTranslation);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  'Aurad e Fatiha Reading',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: excelData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: excelData.length,
        itemBuilder: (context, index) {
          final arabicText = excelData[index][0];
          final translation = excelData[index][1];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    arabicText,
                    style: TextStyle(
                      fontSize: arabicFontSize,
                      fontFamily: 'Indopak',
                      color: Colors.purple.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (displayTranslation) SizedBox(height: 10),
                  if (displayTranslation)
                    Text(
                      translation,
                      style: TextStyle(
                        fontSize: translationFontSize,
                        color: Colors.black,
                        fontFamily: 'read',
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QuranScreen(),
  ));
}
