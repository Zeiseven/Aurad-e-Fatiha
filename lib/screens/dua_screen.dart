import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({Key? key}) : super(key: key);

  @override
  _DuaScreenState createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  List<String> arabicTexts = [];
  double fontSize = 30; // Initial font size
  String selectedFont = 'Indopak'; // Initial selected font
  Color backgroundColor = Color(0xffdfe6e3); // Changed to match SalamScreen
  Color textColor = Colors.black; // Initial text color
  final List<String> fonts = [
    'Indopak',
    'Muhamadi',
    'Musharaf',
    'Qalam',
    'Saleem'
  ];

  @override
  void initState() {
    super.initState();
    loadFontSettings(); // Load font settings when the widget initializes
    loadExcelData();
  }

  Future<void> loadFontSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getDouble('fontSize') ?? 30;
      selectedFont = prefs.getString('selectedFont') ?? 'Indopak';
      int? colorValue = prefs.getInt('backgroundColor');
      int? textColorValue = prefs.getInt('textColor');
      if (colorValue != null) {
        backgroundColor = Color(colorValue);
      }
      if (textColorValue != null) {
        textColor = Color(textColorValue);
      }
    });
  }

  Future<void> saveFontSettings(double fontSize, String font, Color bgColor, Color textColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
    await prefs.setString('selectedFont', font);
    await prefs.setInt('backgroundColor', bgColor.value);
    await prefs.setInt('textColor', textColor.value);
    setState(() {
      this.fontSize = fontSize;
      this.selectedFont = font;
      this.backgroundColor = bgColor;
      this.textColor = textColor;
    });
  }

  Future<void> loadExcelData() async {
    ByteData data = await rootBundle.load("assets/dua.xlsx");
    Uint8List bytes = data.buffer.asUint8List();
    var excel = Excel.decodeBytes(bytes);
    var table = excel.tables['Sheet1'];

    for (var row in table!.rows) {
      arabicTexts.add(row[1]?.value.toString() ?? '');
    }
    setState(() {});
  }

  void selectBackgroundColor(BuildContext context) async {
    Color? newColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = backgroundColor;
        return AlertDialog(
          title: Text('Select Background Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (Color color) {
                tempColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Select'),
              onPressed: () {
                Navigator.of(context).pop(tempColor);
              },
            ),
          ],
        );
      },
    );

    if (newColor != null) {
      saveFontSettings(fontSize, selectedFont, newColor, textColor);
    }
  }

  void selectTextColor(BuildContext context) async {
    Color? newColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = textColor;
        return AlertDialog(
          title: Text('Select Text Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (Color color) {
                tempColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Select'),
              onPressed: () {
                Navigator.of(context).pop(tempColor);
              },
            ),
          ],
        );
      },
    );

    if (newColor != null) {
      saveFontSettings(fontSize, selectedFont, backgroundColor, newColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: AppBar(
          backgroundColor: Color(0xFF3c7962), // Changed to match SalamScreen
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          automaticallyImplyLeading: false,
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
                          title: Text('Font and Color Settings'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Select Arabic Font'),
                              DropdownButton<String>(
                                value: selectedFont,
                                items: fonts.map((String font) {
                                  return DropdownMenuItem<String>(
                                    value: font,
                                    child: Text(font),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedFont = newValue!;
                                    saveFontSettings(fontSize, selectedFont, backgroundColor, textColor);
                                  });
                                },
                              ),
                              Text('Font Size'),
                              Slider(
                                value: fontSize,
                                min: 20,
                                max: 60,
                                divisions: 4,
                                onChanged: (value) {
                                  setState(() {
                                    fontSize = value;
                                    saveFontSettings(fontSize, selectedFont, backgroundColor, textColor);
                                  });
                                },
                              ),
                              SizedBox(height: 20),
                              Text('Background Color'),
                              GestureDetector(
                                onTap: () => selectBackgroundColor(context),
                                child: Container(
                                  width: 100,
                                  height: 40,
                                  color: backgroundColor,
                                  child: Center(
                                    child: Text('Select', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text('Text Color'),
                              GestureDetector(
                                onTap: () => selectTextColor(context),
                                child: Container(
                                  width: 100,
                                  height: 40,
                                  color: textColor,
                                  child: Center(
                                    child: Text('Select', style: TextStyle(color: Colors.white)),
                                  ),
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
              color: Color(0xFF3c7962), // Changed to match SalamScreen
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  'Dua e Subuh',
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
      bottomNavigationBar: Container(
        height: 30,
        decoration: BoxDecoration(
          color: Color(0xFF3c7962), // Changed to match SalamScreen
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      body: arabicTexts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: arabicTexts.length,
        itemBuilder: (context, index) {
          final arabicText = arabicTexts[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
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
                      fontFamily: selectedFont,
                      color: textColor,
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