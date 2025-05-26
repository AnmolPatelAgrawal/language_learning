import 'package:flutter/material.dart';
import 'match_case_screen.dart'; // Import the correct screen

class MatchTheCaseScreen extends StatelessWidget {
  const MatchTheCaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EFEC),
      body: Stack(
        children: [
          // Background character image
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.network(
              'https://dashboard.codeparrot.ai/api/image/aBoKiy9L86pAlMJU/image-14.png',
              width: 350, // Make the image bigger
              height: 350,
              fit: BoxFit.contain,
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
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Match\nThe Case',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w900,
                      fontSize: 80,
                      color: Color(0xFFAF4128),
                      shadows: [
                        Shadow(
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // Play button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAF4128),
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10), // Make button thinner vertically
                      shape: const StadiumBorder(),
                      elevation: 10,
                      shadowColor: Colors.black.withAlpha((0.5 * 255).toInt()),
                    ),
                    onPressed: () {
                      // Navigate to MatchCaseScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MatchCaseScreen()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFDF4EB),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Play',
                          style: TextStyle(
                            fontFamily: 'Belanosima',
                            fontSize: 20,
                            color: Color(0xFFFDF4EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
