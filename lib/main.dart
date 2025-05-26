import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'match_the_case_screen.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Allow all orientations by not setting preferred orientations
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mtach The Case',
      theme: ThemeData(
        primaryColor: const Color(0xFFF57D31),
        scaffoldBackgroundColor: const Color(0xFFFDF4EB),
      ),
      debugShowCheckedModeBanner: false,
      home: const MatchTheCaseScreen(), // Set the home property
    );
  }
}
