import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'session_data_manager.dart';
import 'match_case_screen.dart'; // Import to use GameAttempt class
import 'export_all_sessions_screen.dart'; // Import ExportAllSessionsScreen

class GameEndScreen extends StatefulWidget {
  final List<GameAttempt> sessionAttempts;

  const GameEndScreen({super.key, required this.sessionAttempts});

  @override
  State<GameEndScreen> createState() => _GameEndScreenState();
}

class _GameEndScreenState extends State<GameEndScreen> {
  Future<void> _exportAndDownloadData(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context); 

    if (widget.sessionAttempts.isEmpty) {
      if (!mounted) return; 
      messenger.showSnackBar(
        const SnackBar(content: Text('No game data to download.')),
      );
      return;
    }

    final SessionDataManager dataManager = SessionDataManager();
    final String timestamp = DateFormat('yyyyMMdd_HHmmss_SSS').format(DateTime.now());
    final String fileName = '$timestamp.json'; 

    final List<Map<String, dynamic>> attemptsToSave = widget.sessionAttempts.map((attempt) => attempt.toMap()).toList();

    try {
      await dataManager.saveAttemptsToNewFile(fileName, attemptsToSave);

      final String? csvContent = await dataManager.exportAttemptsToCsv(fileName);
      String csvFileName = fileName.replaceAll('.json', '.csv'); // Declare here

      if (csvContent != null) {
        await dataManager.downloadCsv(csvContent, csvFileName);
        if (!mounted) return; 
        messenger.showSnackBar(
          SnackBar(content: Text('Data downloaded as $csvFileName')),
        );
      } else {
        if (!mounted) return; 
        messenger.showSnackBar(
          const SnackBar(content: Text('Failed to generate CSV content.')),
        );
      }
    } catch (e) {
      if (!mounted) return; 
      messenger.showSnackBar(
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
              'Total attempts: ${widget.sessionAttempts.length}',
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExportAllSessionsScreen()),
                );
              },
              child: const Text('View All Sessions'),
            ),
          ],
        ),
      ),
    );
  }
}
