import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:open_filex/open_filex.dart';

class SessionDataManager {
  Future<void> saveAttemptsToNewFile(
      String fileName, List<Map<String, dynamic>> attemptsData) async {
    if (attemptsData.isEmpty) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = p.join(directory.path, fileName);

    try {
      final file = File(filePath);
      final jsonString = jsonEncode(attemptsData);
      await file.writeAsString(jsonString);
    } catch (e) {
      // Error handling for saving attempts
    }
  }

  Future<String?> exportAttemptsToCsv(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = p.join(directory.path, fileName);

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return null;
      }

      final jsonString = await file.readAsString();
      final List<dynamic> decodedData = jsonDecode(jsonString);

      if (decodedData.isEmpty) {
        return null;
      }

      // Prepare data for CSV
      List<List<dynamic>> csvData = [];
      if (decodedData.isNotEmpty && decodedData.first is Map) {
        csvData.add((decodedData.first as Map<String, dynamic>).keys.toList());
      }
      for (var item in decodedData) {
        if (item is Map) {
          csvData.add(item.values.toList());
        }
      }

      String csv = const ListToCsvConverter().convert(csvData);
      return csv;
    } catch (e) {
      // Error handling for exporting to CSV
      return null;
    }
  }

  Future<void> downloadCsv(String csvContent, String fileName) async {
    try {
      Directory? directory;
      directory = await getApplicationDocumentsDirectory();

      if (directory == null) {
        return; // Exit if no suitable directory
      }

      final filePath = p.join(directory.path, fileName);
      final file = File(filePath);
      await file.writeAsString(csvContent);

      // Try to open the file
      final result = await OpenFilex.open(filePath);
      if (result.type == ResultType.done) {
        // File opened successfully.
      } else {
        // Failed to open file.
      }
    } catch (e) {
      // Error handling for downloading CSV
    }
  }

  Future<List<String>> getAllSessionFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      List<String> sessionFiles = [];

      if (await directory.exists()) {
        sessionFiles = directory
            .listSync()
            .where(
                (item) => item.path.endsWith('.json'))
            .map((item) => p.basename(item.path))
            .toList();
        sessionFiles.sort((a, b) => b.compareTo(a));
      }
      return sessionFiles;
    } catch (e) {
      // Error handling for getting all session files
      return [];
    }
  }

  Future<void> deleteAllSessionFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      if (await directory.exists()) {
        final List<FileSystemEntity> files = directory.listSync();
        for (var file in files) {
          if (file.path.endsWith('.json')) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      // Error handling for deleting all session files
    }
  }
}
