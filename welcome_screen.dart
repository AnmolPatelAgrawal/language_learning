import 'package:flutter/material.dart';

class MatchCaseScreen extends StatelessWidget {
  const MatchCaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EFEC),
      body: Stack(
        children: [
          // Background character image
          Positioned.fill(
            child: Image.network(
              'https://dashboard.codeparrot.ai/api/image/aBoKiy9L86pAlMJU/image-14.png',
              fit: BoxFit.cover,
            ),
          ),

          // App Logo in top left
          Positioned(
            top: 48,
            left: 57,
            child: Container(
              width: 71,
              height: 67,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://dashboard.codeparrot.ai/api/image/aBoKiy9L86pAlMJU/image-14-2.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Settings icon in top right
          Positioned(
            top: 69,
            right: 48,
            child: IconButton(
              icon: Image.network('https://dashboard.codeparrot.ai/api/image/aBoKiy9L86pAlMJU/settings.png'),
              iconSize: 56,
              onPressed: () {
                // Handle settings tap
              },
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Match\nThe Case',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w900,
                    fontSize: 96,
                    color: Color(0xFFAF4128),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Play button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAF4128),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.5),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to next screen
                    Navigator.pushNamed(context, '/game');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF4EB),
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Play',
                        style: TextStyle(
                          fontFamily: 'Belanosima',
                          fontSize: 24,
                          color: Color(0xFFFDF4EB),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
