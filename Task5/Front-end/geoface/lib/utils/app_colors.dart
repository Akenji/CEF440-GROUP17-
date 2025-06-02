import 'package:flutter/material.dart';

class AppColors {
  // Background Gradient Colors
  static const Color backgroundGradientStart = Color(0xFF1e3c72);
  static const Color backgroundGradientMid1 = Color(0xFF2a5298);
  static const Color backgroundGradientMid2 = Color(0xFF6dd5ed);
  static const Color backgroundGradientEnd = Color(0xFF2193b0);

  // Icon and Header Gradient Colors
  static const Color gradientAccentStart = Colors.cyanAccent;
  static const Color gradientAccentEnd = Colors.blueAccent;

  // Text and UI Element Colors
  static const Color primaryText = Color.fromRGBO(19, 3, 46, 1);
  static const Color secondaryText = Colors.black;
  static const Color hintText = Colors.white54;
  static const Color divider = Colors.white30;

  // Button and Accent Colors
  static const Color primaryAccent = Color.fromARGB(255, 16, 62, 155);
  static const Color secondaryAccent = Colors.blueAccent;
  static const Color error = Colors.red;
  static const Color errorAccent = Colors.redAccent;

  // Shadow Colors
  static const Color shadow = Colors.black;

  // Social Login Button Colors
  static const Color googleButton = Colors.red;
  static const Color facebookButton = Colors.blue;

  // Password Strength Indicator Colors
  static const Color passwordStrengthWeak = Colors.redAccent;
  static const Color passwordStrengthFair = Color.fromARGB(255, 209, 178, 137);
  static const Color passwordStrengthGood = Colors.yellowAccent;
  static const Color passwordStrengthStrong = Colors.greenAccent;
// 191D32
// 00B383
  // Dropdown Background Color
  static const Color dropdownBackground = Color(0x191D32);
  static const Color backgroundColor = Colors.blueAccent;
  static const Color cardColor = Color.fromARGB(255, 16, 62, 155);
  static const Color cardtext = Color.fromRGBO(19, 3, 46, 1);

  // Opacity Variations
  static Color primaryTextFieldFill = Colors.white.withOpacity(0.1);
  static Color formContainerBackground = Colors.white;
  static Color formContainerBorder = Colors.white.withOpacity(0.2);
  static Color shadowWithOpacity = Colors.black.withOpacity(0.2);
  static Color accentShadow = Colors.cyanAccent.withOpacity(0.4);
  static Color errorBackground = Colors.redAccent.withOpacity(0.2);
  static Color errorBorder = Colors.redAccent.withOpacity(0.5);
}
