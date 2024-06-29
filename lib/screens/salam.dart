import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalamScreen extends StatefulWidget {
  const SalamScreen({Key? key}) : super(key: key);

  @override
  _SalamScreenState createState() => _SalamScreenState();
}

class _SalamScreenState extends State<SalamScreen> {
  List<List<String>> arabicData = [];
  double fontSize = 30; // Initial font size

  @override
  void initState() {
    super.initState();
    loadFontSettings(); // Load font settings when the widget initializes
    loadArabicData();
  }

  Future<void> loadFontSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load font size from SharedPreferences, if available
      fontSize = prefs.getDouble('fontSize') ?? 30;
    });
  }

  Future<void> saveFontSettings(double fontSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize); // Save font size to SharedPreferences
    setState(() {
      this.fontSize = fontSize; // Update font size in the state
    });
  }

  Future<void> loadArabicData() async {
    ByteData data = await rootBundle.load("assets/arabic_data.xlsx");
    Uint8List bytes = data.buffer.asUint8List();
    var excel = Excel.decodeBytes(bytes);
    var table = excel.tables['Sheet1'];
    for (int i = 247; i < 273; i++) { // Extract entries 248 to 273
      var row = table!.rows[i];
      arabicData.add([row[1]?.value.toString() ?? '', '']);
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
                          title: Text('Font Size'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Arabic Font'),
                              Slider(
                                value: fontSize,
                                min: 20,
                                max: 60,
                                divisions: 4,
                                onChanged: (value) {
                                  setState(() {
                                    fontSize = value;
                                  });
                                  saveFontSettings(fontSize);
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  saveFontSettings(fontSize); // Save font size when done button is pressed
                                  Navigator.pop(context);
                                },
                                child: Text('Done'),
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
                  'Salam',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          leading: Container( // Encircle back button
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.5),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          leadingWidth: 70,
        ),
      ),
      bottomNavigationBar: Container( // Add bottom bar with low height
        height: 30,
        decoration: BoxDecoration(
          color: Colors.purple.shade300,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      body: arabicData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: arabicData.length,
        itemBuilder: (context, index) {
          final arabicText = arabicData[index][0];

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
                      fontSize: fontSize,
                      fontFamily: 'Indopak', // Use the Indopak font family for Arabic text
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
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
    home: SalamScreen(),
  ));
}
