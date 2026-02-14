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
    backgroundColor: Color(0xFF00051E), 
    gradientColors: [
      Color(0xFF00051E), 
      Color(0xFF2B0050), 
    ],
    buttonColor: Color(0xFF651FFF), 
    textColor: Colors.white,
  );

  static final Map<String, SongStyle> _styles = {
    
    'stigma': const SongStyle(
      backgroundColor: Color(0x33000000), 
      gradientColors: [
        Color(0xFF0D1111), 
        Color(0xFF000000),
      ],
      buttonColor: Color(0xFF4F635B), 
    ),
    'leblanc': const SongStyle(
      backgroundColor: Color(0xFF1A0505),
      gradientColors: [
      Color(0xFFFF0000), 
      Color(0xFF3D0000), 
      ],
      buttonColor: Color(0xFFFF3C38),
      textColor: Colors.white,
    ),
    'legoon': const SongStyle(
      backgroundColor: Color(0xFF001524), 
      gradientColors: [
        Color(0xFF00A8E8), 
        Color(0xFF003459), 
      ],
      buttonColor: Color(0xFF00F5D4), 
      textColor: Colors.white,
    ),
    'leschnable': const SongStyle(
      backgroundColor: Color(0xFF000200), // Pitch black green
      gradientColors: [
        Color(0xFF005C00), // Rich Green (Top)
        Color(0xFF000500), // Abyssal Green (Bottom)
      ],
      buttonColor: Color(0xFF00FF22), // High-vis Neon Grass Green
      textColor: Colors.white,
    ),
      };

  static SongStyle getStyle(String themeName) {
    return _styles[themeName] ?? defaultStyle;
  }
}
