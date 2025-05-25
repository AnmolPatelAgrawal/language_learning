import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'export_db_screen.dart';
import 'match_the_case_screen.dart'; // Import your screen here

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MyApp());
    //runApp(MaterialApp(home: ExportDbScreen()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome App',
      theme: ThemeData(
        primaryColor: const Color(0xFFF57D31),
        scaffoldBackgroundColor: const Color(0xFFFDF4EB),
      ),
      debugShowCheckedModeBanner: false,
      home: const MatchTheCaseScreen(), // Set the home property
    );
  }
}  