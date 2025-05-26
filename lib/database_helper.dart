// lib/database_helper.dart
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

class DatabaseHelper {
  // This helper is now a utility class. It doesn't maintain a single static database instance.
  // Each call to saveAttemptsToNewDb will create/open, populate, and close a specific DB file.

  // This _onCreate will be used by saveAttemptsToNewDb when a new DB file is created.
  Future<void> _createAttemptsTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE attempts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        correct INTEGER,        -- 1 for true, 0 for false
        time_taken INTEGER      -- Time in milliseconds
      )
    ''');
    print("Table 'attempts' created in database: ${db.path}");
  }

  Future<void> saveAttemptsToNewDb(String dbFileName, List<Map<String, dynamic>> attemptsData) async {
    if (attemptsData.isEmpty) {
      print("No attempts to save for session file: $dbFileName");
      return;
    }

    final String databasesPath = await getDatabasesPath(); // Get the directory for databases
    final String fullPath = p.join(databasesPath, dbFileName); // Use p.join for platform-correct path joining

    print("Attempting to save session to new database: $fullPath");

    Database? newDb; // Declare newDb as nullable
    try {
      // Open (or create if it doesn't exist) the new database file.
      newDb = await openDatabase(
        fullPath,
        version: 1,
        onCreate: _createAttemptsTable, // Call our table creation function
      );

      // Insert each attempt into the 'attempts' table.
      // Using a batch can be more efficient for many inserts, but a loop is fine for moderate numbers.
      Batch batch = newDb.batch();
      for (var attemptMap in attemptsData) {
        // The attemptMap already has 'correct' and 'time_taken' from GameAttempt.toMap()
        batch.insert('attempts', attemptMap); 
        print("  -> Queued for DB ($dbFileName): correct: ${attemptMap['correct']}, time_taken: ${attemptMap['time_taken']}");
      }
      await batch.commit(noResult: true); // Commit the batch

      print("Successfully saved ${attemptsData.length} attempts to $dbFileName at $fullPath");

    } catch (e) {
      print("Error saving attempts to database $dbFileName: $e");
      // You might want to throw the error or handle it more gracefully
    } finally {
      if (newDb != null && newDb.isOpen) {
        await newDb.close();
        print("Database closed: $fullPath");
      }
    }
  }

  Future<String?> exportAttemptsToCsv(String dbFileName) async {
    final String databasesPath = await getDatabasesPath();
    final String fullPath = p.join(databasesPath, dbFileName);

    Database? db;
    try {
      db = await openDatabase(fullPath, readOnly: true);
      final List<Map<String, dynamic>> maps = await db.query('attempts');

      if (maps.isEmpty) {
        print("No data found in $dbFileName to export.");
        return null;
      }

      // Prepare data for CSV
      List<List<dynamic>> csvData = [];
      // Add header row
      csvData.add(maps.first.keys.toList());
      // Add data rows
      for (var map in maps) {
        csvData.add(map.values.toList());
      }

      String csv = const ListToCsvConverter().convert(csvData);
      print("CSV content generated from $dbFileName.");
      return csv;
    } catch (e) {
      print("Error exporting database $dbFileName to CSV: $e");
      return null;
    } finally {
      if (db != null && db.isOpen) {
        await db.close();
        print("Database closed after CSV export: $fullPath");
      }
    }
  }

  Future<void> downloadCsv(String csvContent, String fileName) async {
    try {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      if (!status.isGranted) {
        print("Storage permission not granted.");
        return;
      }

      // Get the directory for saving files
      // For Android, getExternalStorageDirectory is often preferred for user-accessible downloads
      // For iOS, getApplicationDocumentsDirectory is more common.
      // For cross-platform, getApplicationDocumentsDirectory is generally safe.
      final directory = await getApplicationDocumentsDirectory();
      final filePath = p.join(directory.path, fileName);
      final file = File(filePath);

      await file.writeAsString(csvContent);
      print("CSV file saved to: $filePath");

      // Open the file
      final result = await OpenFilex.open(filePath);
      if (result.type == ResultType.done) {
        print("File opened successfully.");
      } else {
        print("Failed to open file: ${result.message}");
      }
    } catch (e) {
      print("Error downloading CSV file: $e");
    }
  }
}
