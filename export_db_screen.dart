// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;

// import 'database_helper.dart';

// class ExportDbScreen extends StatefulWidget {
//   @override
//   _ExportDbScreenState createState() => _ExportDbScreenState();
// }

// class _ExportDbScreenState extends State<ExportDbScreen> {
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   String _message = "";

//   Future<void> _exportDatabase() async {
//     setState(() => _message = "Requesting permissions...");

//     // Step 1: Request permission
//     var status = await Permission.manageExternalStorage.status;
//     if (!status.isGranted) {
//       await Permission.manageExternalStorage.request();
//     }

//     if (!await Permission.manageExternalStorage.isGranted) {
//       setState(() => _message = "Permission denied.");
//       return;
//     }

//     try {
//       // Step 2: Close DB to avoid corruption
//       await _dbHelper.closeDatabase();

//       // Step 3: Get source path
//       final sourcePath = await _dbHelper.databasePath;
//       final sourceFile = File(sourcePath);

//       if (!await sourceFile.exists()) {
//         setState(() => _message = "Database not found at $sourcePath");
//         return;
//       }

//       // Step 4: Destination - Downloads/MyAppExports
//       final downloadsDir = Directory('/storage/emulated/0/Download/MyAppExports');
//       if (!await downloadsDir.exists()) {
//         await downloadsDir.create(recursive: true);
//       }

//       final destFile = File(p.join(downloadsDir.path, "exported_my_app_database.db"));

//       setState(() => _message = "Copying to ${destFile.path}...");
//       await sourceFile.copy(destFile.path);

//       setState(() => _message = "Export successful: ${destFile.path}");
//     } catch (e) {
//       setState(() => _message = "Export failed: $e");
//     } finally {
//       await _dbHelper.reopenDatabase();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Export Database")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: _dbHelper.insertSampleData,
//               child: Text("Insert Sample Data"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _exportDatabase,
//               child: Text("Export to Downloads"),
//             ),
//             SizedBox(height: 20),
//             Text(_message),
//           ],
//         ),
//       ),
//     );
//   }
// }
