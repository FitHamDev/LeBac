import 'package:flutter/material.dart';

class SongStyle {
  final Color backgroundColor;
  final List<Color> gradientColors;
  final Color buttonColor;
  final Color textColor;

  const SongStyle({
    required this.backgroundColor,
    required this.gradientColors,
    required this.buttonColor,
    this.textColor = Colors.white,
  });

  static const defaultStyle = SongStyle(
    backgroundColor: Color(0xFF2C003E),
    gradientColors: [Color(0xFF2C003E), Colors.black],
    buttonColor: Color(0x00000000), 
  );

  static final Map<String, SongStyle> _styles = {
    'stigma': const SongStyle(
      backgroundColor: Color(0xFF121212), 
      
      gradientColors: [
        Color(0xFF2C2C2C), 
        Color(0xFF080808), 
      ],
  
      buttonColor: Color.fromARGB(255, 126, 108, 84), 
    ),
    'leblanc': const SongStyle(
      backgroundColor: Color(0xFF1A0505),
      gradientColors: [
        Color(0xFF2B0000),
        Color(0xFF4A0A0A),
      ],
      buttonColor: Color(0xFFFF3C38),
      textColor: Colors.white,
    ),
    'legoon': const SongStyle(
      backgroundColor: Color(0xFF1A0A00),
      gradientColors: [
        Color(0xFF2B1200),
        Color(0xFF5A2600),
      ],
      buttonColor: Color(0xFFFF7A00),
      textColor: Colors.white,
    ),
  };

  static SongStyle getStyle(String themeName) {
    return _styles[themeName] ?? defaultStyle;
  }
}
