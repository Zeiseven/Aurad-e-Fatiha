import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Color Picker package

class RiqabScreen extends StatefulWidget {
  const RiqabScreen({Key? key}) : super(key: key);

  @override
  _RiqabScreenState createState() => _RiqabScreenState();
}

class _RiqabScreenState extends State<RiqabScreen> {
  List<List<String>> excelData = [];
  late double arabicFontSize;
  late double translationFontSize;
  late bool displayTranslation;
  late double scrollSpeed;
  late ScrollController _scrollController;
  Timer? _timer;
  bool isAutoScrolling = false;
  String selectedFont = 'Indopak'; // Default font

  Color backgroundColor = Color(0xffdfe6e3); // Changed to match SalamScreen
  Color textColor = Colors.black; // Default text color

  // List of available fonts
  final List<String> fonts = ['Indopak', 'Muhamadi', 'Musharaf', 'Qalam', 'Saleem'];

  @override
  void initState() {
    super.initState();
    loadSettings();
    loadExcelData();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> saveSettings(
      double arabicFontSize,
      double translationFontSize,
      bool displayTranslation,
      double scrollSpeed,
      String selectedFont,
      Color backgroundColor,
      Color textColor,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabicFontSize', arabicFontSize);
    await prefs.setDouble('translationFontSize', translationFontSize);
    await prefs.setBool('displayTranslation', displayTranslation);
    await prefs.setDouble('scrollSpeed', scrollSpeed);
    await prefs.setString('selectedFont', selectedFont); // Save selected font
    await prefs.setInt('backgroundColor', backgroundColor.value); // Save background color
    await prefs.setInt('textColor', textColor.value); // Save text color
    setState(() {
      this.arabicFontSize = arabicFontSize;
      this.translationFontSize = translationFontSize;
      this.displayTranslation = displayTranslation;
      this.scrollSpeed = scrollSpeed;
      this.selectedFont = selectedFont;
      this.backgroundColor = backgroundColor;
      this.textColor = textColor;
    });
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      arabicFontSize = prefs.getDouble('arabicFontSize') ?? 30;
      translationFontSize = prefs.getDouble('translationFontSize') ?? 22;
      displayTranslation = prefs.getBool('displayTranslation') ?? false;
      scrollSpeed = prefs.getDouble('scrollSpeed') ?? 30;
      selectedFont = prefs.getString('selectedFont') ?? 'Indopak';
      backgroundColor = Color(prefs.getInt('backgroundColor') ?? 0xffdfe6e3);
      textColor = Color(prefs.getInt('textColor') ?? Colors.black.value);
    });
  }

  Future<void> loadExcelData() async {
    ByteData data = await rootBundle.load("assets/arabic_data.xlsx");
    Uint8List bytes = data.buffer.asUint8List();
    var excel = Excel.decodeBytes(bytes);
    var table = excel.tables['Sheet1'];

    // Load entries from 273 onwards
    for (int i = 273; i < table!.rows.length; i++) {
      var row = table.rows[i];
      excelData.add([row[1]?.value.toString() ?? '', row[2]?.value.toString() ?? '']);
    }

    setState(() {});
  }

  void startAutoScroll() {
    isAutoScrolling = true;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_scrollController.position.pixels < _scrollController.position.maxScrollExtent) {
        _scrollController.jumpTo(_scrollController.position.pixels + scrollSpeed / 20);
      } else {
        _scrollController.jumpTo(0);
      }
    });
  }

  void stopAutoScroll() {
    _timer?.cancel();
    isAutoScrolling = false;
  }

  void updateScrollSpeed(double newSpeed) {
    setState(() {
      scrollSpeed = newSpeed;
      if (isAutoScrolling) {
        stopAutoScroll();
        startAutoScroll();
      }
    });
  }

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
                saveSettings(
                  arabicFontSize,
                  translationFontSize,
                  displayTranslation,
                  scrollSpeed,
                  selectedFont,
                  backgroundColor,
                  textColor,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
          ),
          leadingWidth: 70,
          actions: [
            IconButton(
              icon: Icon(
                isAutoScrolling ? Icons.pause : Icons.play_arrow,
                size: 36,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (isAutoScrolling) {
                    stopAutoScroll();
                  } else {
                    startAutoScroll();
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white, size: 36),
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
                              DropdownButton<String>(
                                value: selectedFont,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedFont = newValue!;
                                    saveSettings(
                                      arabicFontSize,
                                      translationFontSize,
                                      displayTranslation,
                                      scrollSpeed,
                                      selectedFont,
                                      backgroundColor,
                                      textColor,
                                    );
                                  });
                                },
                                items: fonts.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              Text('Arabic Font Size'),
                              Slider(
                                value: arabicFontSize,
                                min: 20,
                                max: 60,
                                divisions: 4,
                                onChanged: (value) {
                                  setState(() {
                                    arabicFontSize = value;
                                    saveSettings(
                                      arabicFontSize,
                                      translationFontSize,
                                      displayTranslation,
                                      scrollSpeed,
                                      selectedFont,
                                      backgroundColor,
                                      textColor,
                                    );
                                  });
                                },
                              ),
                              Text('Urdu Font Size'),
                              Slider(
                                value: translationFontSize,
                                min: 20,
                                max: 60,
                                divisions: 4,
                                onChanged: (value) {
                                  setState(() {
                                    translationFontSize = value;
                                    saveSettings(
                                      arabicFontSize,
                                      translationFontSize,
                                      displayTranslation,
                                      scrollSpeed,
                                      selectedFont,
                                      backgroundColor,
                                      textColor,
                                    );
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
                                        saveSettings(
                                          arabicFontSize,
                                          translationFontSize,
                                          displayTranslation,
                                          scrollSpeed,
                                          selectedFont,
                                          backgroundColor,
                                          textColor,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Text('Scroll Speed'),
                              Slider(
                                value: scrollSpeed,
                                min: 10,
                                max: 100,
                                divisions: 9,
                                onChanged: (value) {
                                  setState(() {
                                    updateScrollSpeed(value);
                                    saveSettings(
                                      arabicFontSize,
                                      translationFontSize,
                                      displayTranslation,
                                      scrollSpeed,
                                      selectedFont,
                                      backgroundColor,
                                      textColor,
                                    );
                                  });
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  pickColor(context, true); // Background color picker
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
                                  pickColor(context, false); // Text color picker
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
              color: Color(0xFF3c7962), // Changed to match SalamScreen
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  'Dua e Riqab',
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
        controller: _scrollController,
        itemCount: excelData.length,
        itemBuilder: (context, index) {
          final arabicText = excelData[index][0];
          final translation = excelData[index][1];

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
                      fontSize: arabicFontSize,
                      fontFamily: selectedFont,
                      color: textColor,
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
      bottomNavigationBar: Container( // Added bottom bar to match SalamScreen
        height: 30,
        decoration: BoxDecoration(
          color: Color(0xFF3c7962),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }
}