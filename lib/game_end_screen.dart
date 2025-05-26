import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'match_case_screen.dart'; // Import to use GameAttempt class

class GameEndScreen extends StatelessWidget {
  final List<GameAttempt> sessionAttempts;

  const GameEndScreen({super.key, required this.sessionAttempts});

  Future<void> _exportAndDownloadData(BuildContext context) async {
    if (sessionAttempts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No game data to download.')),
      );
      return;
    }

    final DatabaseHelper dbHelper = DatabaseHelper();
    final String timestamp = DateFormat('yyyyMMdd_HHmmss_SSS').format(DateTime.now());
    final String dbFileName = '$timestamp.db';

    // Convert GameAttempt objects to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> attemptsToSave = sessionAttempts.map((attempt) => attempt.toMap()).toList();

    try {
      await dbHelper.saveAttemptsToNewDb(dbFileName, attemptsToSave);
      print("Session data saved to $dbFileName.");

      final String? csvContent = await dbHelper.exportAttemptsToCsv(dbFileName);
      if (csvContent != null) {
        final String csvFileName = dbFileName.replaceAll('.db', '.csv');
        await dbHelper.downloadCsv(csvContent, csvFileName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data downloaded as $csvFileName')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate CSV content.')),
        );
      }
    } catch (e) {
      print("Error during data export and download: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
        automaticallyImplyLeading: false, // No back button on game over screen
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Game Session Ended!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Total attempts: ${sessionAttempts.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _exportAndDownloadData(context),
              icon: const Icon(Icons.download),
              label: const Text('Download Game Data (CSV)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the welcome screen or start a new game
                Navigator.of(context).popUntil((route) => route.isFirst); // Go back to the first route (e.g., WelcomeScreen)
              },
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
