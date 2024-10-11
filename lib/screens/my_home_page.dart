import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  final bool startOver;

  MyHomePage({Key? key, required this.startOver}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<List<String>> excelData = [];
  AudioPlayer audioPlayer = AudioPlayer();
  int currentIndex = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double _sliderValue = 0.0;
  bool isPlaying = false;
  int? currentlyPlayingIndex;
  double arabicFontSize = 25.0;
  double playbackSpeed = 1.0; // Default playback speed
  bool isInBackground = false; // Track if app is in background
  bool isRepeatMode = false; // Repeat mode

  _MyHomePageState() {
    loadSettings(); // Move here to ensure settings are loaded only once
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void initState() {
    super.initState();
    loadExcelData();
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      setState(() {
        duration = updatedDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((updatedPosition) {
      setState(() {
        position = updatedPosition;
        _sliderValue = updatedPosition.inSeconds.toDouble();
      });
    });
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        if (isRepeatMode) {
          // Repeat the current audio with the user-set playback speed
          playAudio(excelData[currentIndex][3], currentIndex);
        } else {
          playNextAudio();
        }
      }
    });
    if (widget.startOver) {
      currentIndex = 0;
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      audioPlayer.stop(); // Stop the audio player
      audioPlayer.dispose(); // Dispose the audio player
      isInBackground = true;
    } else if (state == AppLifecycleState.resumed) {
      audioPlayer = AudioPlayer(); // Create a new instance of the audio player
      audioPlayer.onDurationChanged.listen((updatedDuration) {
        setState(() {
          duration = updatedDuration;
        });
      });
      audioPlayer.onPositionChanged.listen((updatedPosition) {
        setState(() {
          position = updatedPosition;
          _sliderValue = updatedPosition.inSeconds.toDouble();
        });
      });
      audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.completed) {
          if (isRepeatMode) {
            // Repeat the current audio with the user-set playback speed
            playAudio(excelData[currentIndex][3], currentIndex);
          } else {
            playNextAudio();
          }
        }
      });
      isInBackground = false;
    }
  }

  Future<void> loadExcelData() async {
    var bytes = await rootBundle.load('assets/arabic_data.xlsx');
    var excel = Excel.decodeBytes(bytes.buffer.asUint8List());
    var sheet = excel.tables.keys.first;
    var table = excel.tables[sheet];

    setState(() {
      excelData = table!.rows.map((row) {
        return row.map((cell) => cell?.value.toString() ?? '').toList();
      }).toList();
    });
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      arabicFontSize = prefs.getDouble('arabicFontSize') ?? 25.0;
      playbackSpeed = prefs.getDouble('playbackSpeed') ?? 1.0;
      isRepeatMode = prefs.getBool('isRepeatMode') ?? false;
    });
  }

  Future<void> saveSettings(double newArabicFontSize, double newPlaybackSpeed, bool newRepeatMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabicFontSize', newArabicFontSize);
    await prefs.setDouble('playbackSpeed', newPlaybackSpeed);
    await prefs.setBool('isRepeatMode', newRepeatMode);
    setState(() {
      arabicFontSize = newArabicFontSize;
      playbackSpeed = newPlaybackSpeed;
      isRepeatMode = newRepeatMode;
    });
  }

  Future<void> playAudio(String audioPath, int index) async {
    try {
      if (isInBackground) {
        // Don't play audio if the app is in the background
        return;
      }

      if (!audioPath.startsWith('assets')) {
        audioPath = 'assets/$audioPath';
      }
      await audioPlayer.setSource(AssetSource(audioPath));
      await audioPlayer.setPlaybackRate(playbackSpeed); // Set playback speed before playing
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
        currentlyPlayingIndex = index;
        currentIndex = index; // Set current index to the selected index
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error playing audio. Please try again.")),
      );
      print("Error playing audio: $error");
    }
  }

  void playNextAudio() {
    if (currentIndex < excelData.length - 1) {
      currentIndex++;
    } else {
      currentIndex = 0; // Loop back to the beginning
    }
    final audioName = excelData[currentIndex][3];
    playAudio(audioName, currentIndex);
  }

  void playPreviousAudio() {
    if (currentIndex > 0) {
      currentIndex--;
    } else {
      currentIndex = excelData.length - 1; // Loop back to the end
    }
    final audioName = excelData[currentIndex][3];
    playAudio(audioName, currentIndex);
  }

  void handlePlayPauseButton() {
    if (isInBackground) {
      // Don't play audio if the app is in the background
      return;
    }

    if (audioPlayer.state == PlayerState.stopped || currentlyPlayingIndex == null) {
      // If no audio is currently playing, start playing the first audio
      final audioName = excelData[currentIndex][3];
      playAudio(audioName, currentIndex);
    } else {
      if (isPlaying) {
        audioPlayer.pause();
        setState(() {
          isPlaying = false; // Set isPlaying to false when audio is paused
        });
      } else {
        audioPlayer.resume();
        setState(() {
          isPlaying = true; // Set isPlaying to true when audio is resumed
        });
      }
    }
  }

  void toggleRepeatMode() {
    setState(() {
      isRepeatMode = !isRepeatMode;
    });
    saveSettings(arabicFontSize, playbackSpeed, isRepeatMode);

    if (isPlaying && isRepeatMode) {
      // If audio is currently playing and repeat mode is enabled, update playback speed
      audioPlayer.setPlaybackRate(playbackSpeed);
    }
  }

  void openSettings() {
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
                  Text('Arabic Font Size'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (arabicFontSize > 10) {
                            setState(() {
                              arabicFontSize -= 5;
                            });
                            saveSettings(arabicFontSize, playbackSpeed, isRepeatMode);
                          }
                        },
                      ),
                      Expanded(
                        child: Slider(
                          value: arabicFontSize,
                          min: 10,
                          max: 50,
                          onChanged: (value) {
                            setState(() {
                              arabicFontSize = value;
                            });
                            saveSettings(arabicFontSize, playbackSpeed, isRepeatMode);
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (arabicFontSize < 50) {
                            setState(() {
                              arabicFontSize += 5;
                            });
                            saveSettings(arabicFontSize, playbackSpeed, isRepeatMode);
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Playback Speed'),
                  DropdownButton<double>(
                    value: playbackSpeed,
                    onChanged: (newValue) {
                      setState(() {
                        playbackSpeed = newValue!;
                      });
                      saveSettings(arabicFontSize, playbackSpeed, isRepeatMode);
                      if (isPlaying) {
                        // If audio is currently playing, update playback speed
                        audioPlayer.setPlaybackRate(playbackSpeed);
                      }
                    },
                    items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                        .map<DropdownMenuItem<double>>((double value) {
                      return DropdownMenuItem<double>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0),
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
              color: Colors.white.withOpacity(0.0),
            ),
          ),
          title: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: Container(
                  width: double.infinity, // Ensure it takes the full width
                  child: Text(
                    'Aurad e Fatiha',
                    textAlign: TextAlign.center, // Center the text horizontally
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
          ),


          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: openSettings,
            ),
          ],
        ),
      ),

      body: excelData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: excelData.length,
              itemBuilder: (context, index) {
                final entry = excelData[index];
                final serialNo = entry[0]; // Assuming serial number is at index 0
                final arabicText = entry[1];
                final audioName = entry[3];

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: InkWell(
                    onTap: () {
                      final audioName = entry[3];
                      playAudio(audioName, index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 40,
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Color(0xFF3c7962),
                                child: Text(
                                  serialNo,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Margin before Arabic text
                          Expanded(
                            child: Container(
                              child: CustomPaint(
                                painter: _ProgressPainter(
                                  isPlaying: isPlaying,
                                  currentIndex: index,
                                  duration: duration,
                                  position: position,
                                  currentIndexPosition: currentlyPlayingIndex,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                      width: double.infinity,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        arabicText,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: arabicFontSize,
                                          color: Colors.black,
                                          fontFamily: 'Indopak',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF77bba2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/icon/backward.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: playPreviousAudio,
                  color: Colors.black,
                ),
                IconButton(
                  icon: Image.asset(
                    isPlaying ? 'assets/icon/pause.png' : 'assets/icon/play.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: handlePlayPauseButton,
                  color: Colors.black,
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icon/forward.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: playNextAudio,
                  color: Colors.red,
                ),
                IconButton(
                  icon: Icon(
                    isRepeatMode ? Icons.repeat : Icons.repeat_one,
                    color: isRepeatMode ? Colors.blue : Colors.black,
                  ),
                  onPressed: toggleRepeatMode,),
                Expanded(
                  child: Slider(
                    value: duration.inSeconds == 0
                        ? 0.0
                        : _sliderValue.clamp(0.0, duration.inSeconds.toDouble()) /
                        duration.inSeconds.toDouble(),
                    max: 1.0,
                    onChanged: (value) {
                      final newPosition = Duration(
                        seconds: (value * duration.inSeconds).round(),
                      );
                      audioPlayer.seek(newPosition);
                      setState(() {
                        _sliderValue = newPosition.inSeconds.toDouble();
                      });
                    },
                  ),
                ),
                Text(
                  duration.inSeconds == 0
                      ? '0:00 / 0:00'
                      : '${Duration(seconds: _sliderValue.round()).toString().split('.')[0]} / ${Duration(seconds: duration.inSeconds).toString().split('.')[0]}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final bool isPlaying;
  final int currentIndex;
  final Duration duration;
  final Duration position;
  final int? currentIndexPosition;

  _ProgressPainter({
    required this.isPlaying,
    required this.currentIndex,
    required this.duration,
    required this.position,
    required this.currentIndexPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isPlaying || currentIndexPosition != currentIndex) return;

    Paint paint = Paint()
      ..color = Colors.green.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint); // Draw complete static overlay
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}