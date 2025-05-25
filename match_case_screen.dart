import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'package:intl/intl.dart'; // For DateFormat in filename
import 'database_helper.dart';   // Your updated DatabaseHelper

// Helper class to store attempt data in memory
class GameAttempt {
  final bool wasCorrect;
  final int timeTakenMs;

  GameAttempt({required this.wasCorrect, required this.timeTakenMs});

  Map<String, dynamic> toMap() {
    return {
      'correct': wasCorrect ? 1 : 0,
      'time_taken': timeTakenMs,
    };
  }
}

class MatchCaseScreen extends StatefulWidget {
  const MatchCaseScreen({super.key});

  @override
  MatchCaseScreenState createState() => MatchCaseScreenState();
}

class MatchCaseScreenState extends State<MatchCaseScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();
  final double letterSize = 110.0;
  final double internalPadding = 10.0;

  final List<String> _allPossibleLetters = List.generate(26, (index) => String.fromCharCode(index + 97));
  late String _currentTargetLetter;
  late List<String> _displayedOptionLetters;

  // --- ADDED FOR SESSION DATA COLLECTION & DB ---
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final List<GameAttempt> _sessionAttempts = []; // List to store attempts for current session
  late DateTime _attemptStartTime;
  // --- END OF ADDED ---

  @override
  void initState() {
    super.initState();
    print("MatchCaseScreen initState: New session started.");
    _sessionAttempts.clear(); // Ensure list is empty for a new session
    _startNewRound();
  }

  void _startNewRound() {
    _currentTargetLetter = _allPossibleLetters[_random.nextInt(_allPossibleLetters.length)];
    List<String> options = [_currentTargetLetter];
    List<String> tempList = List.from(_allPossibleLetters);
    tempList.remove(_currentTargetLetter);
    tempList.shuffle(_random);
    int remainingSlots = 4;
    options.addAll(tempList.take(min(remainingSlots, tempList.length)));
    options.shuffle(_random);

    if (mounted) {
      setState(() {
        _displayedOptionLetters = options;
        _attemptStartTime = DateTime.now(); // Start timer for this attempt
      });
    }
  }

  void _playSound(String soundPath) async {
    try {
      await _audioPlayer.play(AssetSource(soundPath));
      print("Playing sound: $soundPath");
    } catch (e) {
      print("Error playing sound $soundPath: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing sound: $e')),
        );
      }
    }
  }

  // --- MODIFIED TO COLLECT ATTEMPT DATA ---
  void _handleLetterTap(String selectedLetter) {
    bool isCorrect = (selectedLetter == _currentTargetLetter);
    final int timeTakenMs = DateTime.now().difference(_attemptStartTime).inMilliseconds;

    // Add attempt to session list
    _sessionAttempts.add(GameAttempt(wasCorrect: isCorrect, timeTakenMs: timeTakenMs));
    print("Attempt recorded in memory: Correct: $isCorrect, Time: $timeTakenMs ms. Total attempts: ${_sessionAttempts.length}");

    _playSound(isCorrect ? 'sounds/success.wav' : 'sounds/failure.wav');

    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Tapped: $selectedLetter. Correct: $isCorrect. Time: ${timeTakenMs / 1000}s')),
    //   );
    // }
    _startNewRound();
  }
  // --- END OF MODIFICATION ---

  Widget _buildLetterButton(String letter, bool isTarget) {
    return GestureDetector(
      onTap: () {
        _handleLetterTap(letter); // Calls the modified handler
      },
      child: Container(
        width: letterSize,
        height: letterSize,
        margin: const EdgeInsets.all(8.0),
        color: Color(0xFFAF4128),
        alignment: Alignment.center,
        child: Text(
          letter,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w900,
            fontSize: letterSize * 0.8,
            color: Color(0xFFF4EFEC),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentTargetLetter == null || _displayedOptionLetters == null) {
      _startNewRound();
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      // ),
      appBar: null,
      body: Row(
        // ... (UI structure remains unchanged, only showing relevant parts below)
        children: [
          // Left Panel
          Expanded(
            child: Container(
              color: const Color(0xFFF4EFEC),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentTargetLetter.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w900,
                        fontSize: 120,
                        color: Color(0xFFAF4128),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        _playSound('sounds/${_currentTargetLetter.toUpperCase()}.wav');
                        // print("Tapped on ${_currentTargetLetter.toUpperCase()} sound icon");
                         if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Playing letter sound')),
                            );
                        }
                      },
                      child: Image.network(
                        'https://dashboard.codeparrot.ai/api/image/aBoX2i9L86pAlMJ3/volume-b.png',
                        width: 36,
                        height: 36,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red, size: 36);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right Panel (Grid based placement logic remains unchanged)
          Expanded(
            child: Container(
              color: const Color(0xFFAF4128),
              child: Padding(
                padding: EdgeInsets.all(internalPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    List<Widget> letterWidgets = [];
                    final int numberOfColumns = 3;
                    final int numberOfRows = 2;
                    double cellWidth = constraints.maxWidth / numberOfColumns;
                    double cellHeight = constraints.maxHeight / numberOfRows;

                    if (_displayedOptionLetters == null || _displayedOptionLetters.isEmpty) { // Safety check
                        return const Center(child: Text("Loading letters...", style: TextStyle(color: Colors.white)));
                    }

                    for (int i = 0; i < _displayedOptionLetters.length; i++) {
                      String letter = _displayedOptionLetters[i];
                      int col = i % numberOfColumns;
                      int row = i ~/ numberOfColumns;
                      double baseCellX = col * cellWidth;
                      double baseCellY = row * cellHeight;
                      double randomPlacementRangeX = cellWidth - letterSize;
                      double randomPlacementRangeY = cellHeight - letterSize;
                      double randomOffsetX = (randomPlacementRangeX > 0)
                          ? _random.nextDouble() * randomPlacementRangeX
                          : 0.0;
                      double randomOffsetY = (randomPlacementRangeY > 0)
                          ? _random.nextDouble() * randomPlacementRangeY
                          : 0.0;
                      
                      if (randomPlacementRangeX <=0) {
                        randomOffsetX = (cellWidth - letterSize) / 2.0;
                      }
                       if (randomPlacementRangeY <=0) {
                        randomOffsetY = (cellHeight - letterSize) / 2.0;
                      }

                      double finalLeft = baseCellX + randomOffsetX;
                      double finalTop = baseCellY + randomOffsetY;
                      finalLeft = max(0, min(finalLeft, constraints.maxWidth - letterSize));
                      finalTop = max(0, min(finalTop, constraints.maxHeight - letterSize));
                      
                      if (letterSize > cellWidth) {
                          print("Warning: Letter '$letter' (width ${letterSize.toStringAsFixed(1)}) is wider than its allocated cell width (${cellWidth.toStringAsFixed(1)}).");
                      }
                      if (letterSize > cellHeight) {
                          print("Warning: Letter '$letter' (height ${letterSize.toStringAsFixed(1)}) is taller than its allocated cell height (${cellHeight.toStringAsFixed(1)}).");
                      }

                      letterWidgets.add(
                        Positioned(
                          top: finalTop,
                          left: finalLeft,
                          child: _buildLetterButton(letter, letter == _currentTargetLetter),
                        ),
                      );
                    }

                    // --- START OF CODE BLOCK FOR CUSTOM BACK ARROW ---
                    Widget customBackButton = Positioned(
                      top: 8,  // Adjust as needed for desired vertical padding from the top of the red zone
                      left: 8, // Adjust as needed for desired horizontal padding from the left of the red zone
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back), // Or Icons.arrow_back
                        color: const Color(0xFFFDF4EB), // Your beige color (scaffoldBackgroundColor from main.dart)
                        iconSize: 30.0, // Adjust size as needed
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        // Optional: Add padding to increase tappable area without making icon huge
                        // padding: EdgeInsets.all(12.0),
                        // constraints: BoxConstraints(), // To remove default IconButton padding if needed
                      ),
                    );
                    // --- END OF CODE BLOCK FOR CUSTOM BACK ARROW ---
                    return Stack(
                      children: [customBackButton, ...letterWidgets],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print("MatchCaseScreen dispose: Session ending. Saving attempts.");
    // --- ADDED: Save collected attempts to a new DB file ---
    if (_sessionAttempts.isNotEmpty) {
      final String timestamp = DateFormat('yyyyMMdd_HHmmss_SSS').format(DateTime.now()); // Timestamp for end of test
      final String dbFileName = '$timestamp.db';
      
      // Convert GameAttempt objects to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> attemptsToSave = _sessionAttempts.map((attempt) => attempt.toMap()).toList();
      
      _dbHelper.saveAttemptsToNewDb(dbFileName, attemptsToSave)
          .then((_) => print("Session saving process initiated for $dbFileName."));
          // .catchError((e) => print("Error during session saving initiation: $e"));
    } else {
      print("No attempts in this session to save.");
    }
    // --- END OF ADDED ---
    
    _audioPlayer.dispose();
    super.dispose();
  }
}