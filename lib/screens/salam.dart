import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Color picker package

class SalamScreen extends StatefulWidget {
  const SalamScreen({Key? key}) : super(key: key);

  @override
  _SalamScreenState createState() => _SalamScreenState();
}

class _SalamScreenState extends State<SalamScreen> {
  List<List<String>> arabicData = [];
  double fontSize = 30; // Initial font size
  String selectedFont = 'Indopak'; // Default font
  Color backgroundColor = Color(0xffdfe6e3); // Default background color
  Color textColor = Colors.black; // Default text color

  @override
  void initState() {
    super.initState();
    loadSettings(); // Load all shared settings when the widget initializes
    loadArabicData();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getDouble('arabicFontSize') ?? 30; // Load font size
      selectedFont = prefs.getString('selectedFont') ?? 'Indopak'; // Load selected font
      backgroundColor = Color(prefs.getInt('backgroundColor') ?? 0xffdfe6e3); // Load background color
      textColor = Color(prefs.getInt('textColor') ?? Colors.black.value); // Load text color
    });
  }

  Future<void> saveSettings(double fontSize, String selectedFont, Color backgroundColor, Color textColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabicFontSize', fontSize); // Save font size
    await prefs.setString('selectedFont', selectedFont); // Save font
    await prefs.setInt('backgroundColor', backgroundColor.value); // Save background color
    await prefs.setInt('textColor', textColor.value); // Save text color
    setState(() {
      this.fontSize = fontSize;
      this.selectedFont = selectedFont;
      this.backgroundColor = backgroundColor;
      this.textColor = textColor;
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
          backgroundColor: Color(0xFF3c7962), // Same color as AsmaUlHusnaScreen
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
                              // Arabic Font Selection Dropdown
                              Text('Arabic Font'),
                              DropdownButton<String>(
                                value: selectedFont,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedFont = newValue!;
                                    saveSettings(fontSize, selectedFont, backgroundColor, textColor);
                                  });
                                },
                                items: ['Indopak', 'Muhamadi', 'Musharaf', 'Qalam', 'Saleem'].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),

                              // Font Size Slider
                              Text('Arabic Font Size'),
                              Slider(
                                value: fontSize,
                                min: 20,
                                max: 60,
                                divisions: 4,
                                onChanged: (value) {
                                  setState(() {
                                    fontSize = value;
                                  });
                                  saveSettings(fontSize, selectedFont, backgroundColor, textColor);
                                },
                              ),

                              // Color Pickers for Background and Text
                              TextButton(
                                onPressed: () {
                                  pickColor(context, true); // Pick background color
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: backgroundColor,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text('Background Color'),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  pickColor(context, false); // Pick text color
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: textColor,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text('Text Color'),
                                  ],
                                ),
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
              color: Color(0xFF3c7962), // Same color as AppBar background
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
          color: Color(0xFF3c7962), // Same color as AppBar
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
                color: backgroundColor, // Use the selected background color
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
                      fontFamily: selectedFont, // Use the selected font for Arabic text
                      color: textColor, // Use the selected text color
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

  // Color picker method
  void pickColor(BuildContext context, bool isBackground) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isBackground ? 'Pick Background Color' : 'Pick Text Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: isBackground ? backgroundColor : textColor,
              onColorChanged: (color) {
                setState(() {
                  if (isBackground) {
                    backgroundColor = color;
                  } else {
                    textColor = color;
                  }
                });
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Select'),
              onPressed: () {
                saveSettings(fontSize, selectedFont, backgroundColor, textColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SalamScreen(),
  ));
}
