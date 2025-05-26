import 'package:flutter/material.dart';

class AppStyles {
  // Colors
  static const Color primaryRed = Color(0xFFAF4128);
  static const Color bgColor = Color(0xFFF4EFEC);
  static const Color lightBeige = Color(0xFFFDF4EB);

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 96,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w900,
    color: primaryRed,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 24,
    fontFamily: 'Belanosima',
    color: lightBeige,
  );

  static const TextStyle backButtonStyle = TextStyle(
    fontSize: 16,
    fontFamily: 'Belanosima',
    color: primaryRed,
  );
}

