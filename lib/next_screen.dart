import 'package:flutter/material.dart';

class NextScreen extends StatelessWidget {
  const NextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF57D31),
        title: const Text(
          'Next Screen',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFDF4EB),
      body: const Center(
        child: Text(
          'Welcome to the Next Screen!',
          style: TextStyle(
            fontFamily: 'Belanosima',
            fontSize: 24,
            color: Color(0xFFF57D31),
          ),
        ),
      ),
    );
  }
}
