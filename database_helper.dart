// lib/database_helper.dart
// import 'dart:io'; // Not strictly needed for this version
import 'package:path/path.dart' as p; // Use 'p' as prefix for clarity
// import 'package:path_provider/path_provider.dart'; // path_provider is used by sqflite's getDatabasesPath
import 'package:sqflite/sqflite.dart';

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

  // The following methods (_database, _dbName, get database, databasePath, _initDB, _onCreate, insertSampleData,
  // closeDatabase, reopenDatabase) from your provided code are related to managing a single,
  // persistent database (my_app_database.db with my_table).
  // Since the current requirement is to save each session to a *new* uniquely named file,
  // these methods are not directly used by the `saveAttemptsToNewDb` logic above.
  // You can keep them if you have other parts of your app that use a general-purpose database,
  // or remove them if this helper is *only* for saving game session attempts.

  // --- Optional: Keep if you need a general purpose DB elsewhere ---
  // static Database? _generalPurposeDatabase;
  // static const String _generalPurposeDbName = "my_app_database.db";

  // Future<Database> get generalPurposeDatabase async {
  //   if (_generalPurposeDatabase != null) return _generalPurposeDatabase!;
  //   _generalPurposeDatabase = await _initGeneralPurposeDB();
  //   return _generalPurposeDatabase!;
  // }

  // Future<String> get generalPurposeDatabasePath async {
  //   return p.join(await getDatabasesPath(), _generalPurposeDbName);
  // }

  // Future<Database> _initGeneralPurposeDB() async {
  //   String path = await generalPurposeDatabasePath;
  //   return await openDatabase(path, version: 1, onCreate: _createMyTable);
  // }

  // Future<void> _createMyTable(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE my_table (
  //       id INTEGER PRIMARY KEY,
  //       name TEXT
  //     )
  //   ''');
  // }

  // Future<void> insertSampleDataIntoMyTable() async {
  //   final db = await generalPurposeDatabase;
  //   await db.insert('my_table', {'id': 1, 'name': 'Sample Data from general DB'});
  // }
  // --- End Optional ---
}